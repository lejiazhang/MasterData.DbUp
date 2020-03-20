using MasterData.DbUp.Common.Interfaces;
using MasterData.DbUp.Common.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;

namespace MasterData.DbUp.Common
{
	public abstract class BaseDbUp
	{
		protected readonly IScriptManifest Manifest;
		protected readonly string ConnectionString;
		protected readonly ISqlCommandReaderFactory SqlCommandReaderFactory;
		protected readonly Dictionary<string, string> Variables = new Dictionary<string, string>();

		public string Target { get; }
		public string Source { get; }

		protected BaseDbUp(string connectionString, string scriptManifestPath, IScriptManifestFactory scriptManifestFactory, ISqlCommandReaderFactory sqlCommandReaderFactory)
		{
			ConnectionString = connectionString;
			SqlCommandReaderFactory = sqlCommandReaderFactory;
			Manifest = scriptManifestFactory.CreateScriptManifestByXml(scriptManifestPath);

			var builder = GetSqlConnectionStringBuilder(ConnectionString);

			Source = builder.DataSource;
			Target = builder.InitialCatalog;
		}

		protected BaseDbUp(string connectionString, string scriptManifestPath, ISqlCommandReaderFactory sqlCommandReaderFactory) : this(connectionString, scriptManifestPath, new ScriptManifestFactory(), sqlCommandReaderFactory)
		{
		}

		public BaseDbUp WithVariable(string key, string value)
		{
			Variables.Add(key, value);
			return this;
		}

		public void PrintInfo()
		{
			ConsoleWrite.WriteLine("-----------------------------------------------------------", ConsoleColor.White);
			ConsoleWrite.Write("> Database: ", ConsoleColor.White);
			ConsoleWrite.WriteLine(Target, ConsoleColor.Green);

			ConsoleWrite.Write("> Source: ", ConsoleColor.White);
			ConsoleWrite.WriteLine(Source, ConsoleColor.Green);

			ConsoleWrite.Write("> Scripts base folder: ", ConsoleColor.White);
			ConsoleWrite.WriteLine(Manifest.BaseFolder, ConsoleColor.Green);
			ConsoleWrite.WriteLine("-----------------------------------------------------------", ConsoleColor.White);
		}

		protected SqlConnectionStringBuilder GetSqlConnectionStringBuilder(string connectionString)
		{
			var builder = new SqlConnectionStringBuilder(connectionString);

			// TransacastionWrapperScriptPreprocessor wraps scripts with transaction scope, which is not allowed when MARS is enabled
			if (builder.MultipleActiveResultSets)
			{
				throw new Exception("Multiple Active Result Sets (MARS) is not supported");
			}

			return builder;
		}
	}
}
