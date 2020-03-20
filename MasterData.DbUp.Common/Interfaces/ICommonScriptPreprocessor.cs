using System;
using System.Collections.Generic;
using System.Text;

namespace MasterData.DbUp.Common.Interfaces
{
	public interface ICommonScriptPreprocessor
	{
		/// <summary>Performs some proprocessing step on a script</summary>
		string Process(string contents);
	}
}
