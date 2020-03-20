using MasterData.DbUp.Common.Interfaces;

namespace MasterData.DbUp.Common.Models
{
    public interface IScriptManifest
    {
        string BaseFolder { get; }
        ISqlScript[] GetScripts();
    }
}
