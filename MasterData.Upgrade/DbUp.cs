using DbUp;
using DbUp.Engine;
using DbUp.Engine.Transactions;
using MasterData.DbUp.Common;
using MasterData.DbUp.Common.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace MasterData.Upgrade
{
	public class DbUp : BaseDbUp
	{
		public DbUp(string connectionString, string scriptManifestPath, IScriptManifestFactory scriptManifestFactory) : base(connectionString, scriptManifestPath, scriptManifestFactory, new SqlCommandReaderFactory())
		{
		}

		public DbUp(string connectionString, string scriptManifestPath) : base(connectionString, scriptManifestPath, new SqlCommandReaderFactory())
		{
		}

		public DatabaseUpgradeResult Upgrade(string companyId = "1", IJournal journal = null, bool withFileListConfirmation = false)
		{
			ConsoleWrite.WriteLine("Start", ConsoleColor.Green);
			Stopwatch sw = new Stopwatch();
			sw.Start();


			var scripts = Manifest.GetScripts().Select(s => new SqlScript(s.Name, s.Contents));

			var engine = DeployChanges.To.SqlDatabase(ConnectionString)
				.WithScripts(scripts)
				.LogToConsole();

			engine.Configure(c =>
			{
				c.Variables.Add("CompanyId", companyId);

				foreach (var entry in Variables)
				{
					c.Variables.Add(entry.Key, entry.Value);
				}
			});

			if (journal != null)
			{
				engine.JournalTo(journal);
			}

			engine.Configure(c =>
			{
				c.ConnectionManager.TransactionMode = TransactionMode.NoTransaction;
				c.ScriptExecutor.ExecutionTimeoutSeconds = 30 * 60; // 30 minutes in seconds 
			});

			var build = engine.Build();

			if (withFileListConfirmation)
			{
				var scriptsToExecute = build.GetScriptsToExecute();
				for (int i = 0; i < scriptsToExecute.Count; i++)
				{
					ConsoleWrite.WriteLine((i + 1) + ". " + scriptsToExecute[i].Name, ConsoleColor.White);
				}

				ConsoleWrite.WriteLine("> Countinue ? (y/n)", ConsoleColor.Green);
				var key = Console.ReadKey();
				if (key.Key != ConsoleKey.Y)
				{
					ConsoleWrite.WriteLine("> Upgrade terminated", ConsoleColor.White);
					return null;
				}
			}


			var result = build.PerformUpgrade();

			sw.Stop();

			if (result.Successful && result.Scripts.Any())
			{
				ConsoleWrite.WriteLine("> Database Upgrade completed successfuly: ", ConsoleColor.Green);
				ConsoleWrite.Write("> Number of executed scripts: ", ConsoleColor.White);
				ConsoleWrite.WriteLine(result.Scripts.Count().ToString(), ConsoleColor.Green);
				ConsoleWrite.Write("> Time: ", ConsoleColor.White);
				ConsoleWrite.WriteLine(sw.Elapsed.Seconds + " sec.", ConsoleColor.Green);
				ConsoleWrite.WriteLine("> Refresing modules..", ConsoleColor.White);
				engine.RefreshModules();
				ConsoleWrite.WriteLine("> Modules refreshed", ConsoleColor.Green);

			}
			else if (!result.Successful)
			{
				ConsoleWrite.WriteLine("> Upgrade failed", ConsoleColor.Red);
			}
			else
			{
				ConsoleWrite.WriteLine("> Nothing to do, all is up to date", ConsoleColor.Green);
			}

			return result;
		}
	}
}
