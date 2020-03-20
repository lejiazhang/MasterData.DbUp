using DbUp.Builder;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Text;
using MasterData.DbUp.Common;

namespace MasterData.Upgrade
{
    public static class BuilderExtensions
    {
        public static UpgradeEngineBuilder RefreshModules(this UpgradeEngineBuilder builder)
        {
            return builder.WithScriptsEmbeddedInAssembly(Assembly.GetAssembly(typeof(BaseDbUp)), s => s.Contains("RefreshModules.sql"));
        }
    }
}
