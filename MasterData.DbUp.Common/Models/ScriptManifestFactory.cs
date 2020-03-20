using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml.Serialization;

namespace MasterData.DbUp.Common.Models
{
    public class ScriptManifestFactory : IScriptManifestFactory
    {
        public IScriptManifest CreateScriptManifestByXml(string scriptManifestFilePath)
        {
            if (!File.Exists(scriptManifestFilePath))
            {
                throw new FileNotFoundException("Script manifest config file not exits in ");
            }

            var xmlSerializer = new XmlSerializer(typeof(ScriptManifest));
            var scriptManifest = (ScriptManifest)xmlSerializer.Deserialize(File.OpenRead(scriptManifestFilePath));

            scriptManifest.BaseFolder = Path.GetDirectoryName(new FileInfo(scriptManifestFilePath).FullName);
            return scriptManifest;
        }
    }
}
