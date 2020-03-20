using MasterData.DbUp.Common.Interfaces;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;

namespace MasterData.DbUp.Common.Models
{
    [XmlRoot("manifest")]
    public class ScriptManifest : IScriptManifest
    {
        [XmlArray("folders")]
        [XmlArrayItem("folder")]
        public List<ScriptFolder> Folders { get; set; }

        public string BaseFolder { get; set; }

        public ISqlScript[] GetScripts()
        {
            var files = new List<ISqlScript>();
            var baseDir = BaseFolder;

            var filteredFolders = Folders.ToList();

            foreach (var folder in filteredFolders)
            {
                var fullPath = Path.Combine(baseDir, folder.Path.Trim('\\'));
                if (!Directory.Exists(fullPath))
                {
                    ConsoleWrite.WriteLine("> Folder not found (ignored): " + fullPath, ConsoleColor.Yellow);
                    continue;
                }

                foreach (var filePath in Directory.GetFiles(fullPath, "*.sql", SearchOption.AllDirectories))
                {
                    var content = File.ReadAllText(filePath);
                    var name = filePath.Replace(baseDir, "");
                    if (files.All(x => x.Name != name))
                    {
                        files.Add(new SqlScript(name, content));
                    }
                }
            }

            return files.ToArray();
        }
    }

    public class ScriptFolder
    {
        [XmlText]
        public string Path { get; set; }
        [XmlAttribute("scope")]
        public string Scope { get; set; }
    }
}
