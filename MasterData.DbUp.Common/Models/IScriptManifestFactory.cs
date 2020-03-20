using System;
using System.Collections.Generic;
using System.Text;

namespace MasterData.DbUp.Common.Models
{
    public interface IScriptManifestFactory
    {
        IScriptManifest CreateScriptManifestByXml(string scriptManifestPath);
    }
}
