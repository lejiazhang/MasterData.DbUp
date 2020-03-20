using System;
using System.Collections.Generic;
using System.Text;

namespace MasterData.DbUp.Common.Interfaces
{
	public interface ISqlCommandReader : IDisposable
	{
		void ReadAllCommands(Action<string> handleCommand);
	}

	public interface ISqlCommandReaderFactory
	{
		ISqlCommandReader Create(string sqlText);
	}
}
