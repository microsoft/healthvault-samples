using System;
using Microsoft.HealthVault.Configuration;

namespace HealthVault.Sample.Xamarin.Core.Configuration
{
    public class DefaultConfiguration
    {
        public static HealthVaultConfiguration GetPpeDefaultConfiguration()
        {
            var appAuthConfiguration = new HealthVaultConfiguration
            {
                DefaultHealthVaultShellUrl = new Uri("https://account.healthvault-ppe.com/"),
                DefaultHealthVaultUrl = new Uri("https://platform.healthvault-ppe.com/platform/"),
                MasterApplicationId = Guid.Parse("cc7db39e-f425-445a-8de6-75271b7ecbfa"),
                RestHealthVaultUrl = new Uri("https://data.ppe.microsofthealth.net/v3/")
            };
            return appAuthConfiguration;
        }
    }
}