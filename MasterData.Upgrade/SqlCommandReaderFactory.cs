using DbUp.Support;
using MasterData.DbUp.Common.Interfaces;
using System;
using System.Collections.Generic;
using System.Text;

namespace MasterData.Upgrade
{
	public class SqlCommandReaderFactory : ISqlCommandReaderFactory
	{
		public ISqlCommandReader Create(string sqlText)
		{
			return new CustomSqlCommandReader(sqlText);
		}
	}

	public class CustomSqlCommandReader : SqlCommandReader, ISqlCommandReader
	{
		public CustomSqlCommandReader(string sqlText, string delimiter = "GO", bool delimiterRequiresWhitespace = true) : base(sqlText, delimiter, delimiterRequiresWhitespace)
		{
		}
	}
}
