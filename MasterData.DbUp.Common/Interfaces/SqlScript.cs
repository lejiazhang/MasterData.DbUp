using System;
using System.Collections.Generic;
using System.Text;

namespace MasterData.DbUp.Common.Interfaces
{
	public interface ISqlScript
	{
		string Name { get; }
		string Contents { get; }
	}

	public class SqlScript : ISqlScript
	{
		public SqlScript(string name, string contents)
		{
			Name = name;
			Contents = contents;
		}

		public string Name { get; }

		public string Contents { get; }
	}
}
