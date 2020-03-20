using Microsoft.Extensions.Configuration;
using System;

namespace MasterData.Upgrade
{
    class Program
    {
        static void Main(string[] args)
        {

            var builder = new ConfigurationBuilder()
            .AddJsonFile($"appsettings.json", true, true);

            var configuration = builder.Build();

            var targetDatabase = configuration.GetConnectionString("TargetDatabase");
            var companyId = configuration["CompanyId"];


            var dbUp = new DbUp(targetDatabase, "./Scripts/Script.Manifest.Upgrade.config");

            dbUp.Upgrade(companyId: companyId, withFileListConfirmation: true);
        }
    }
}
