using System;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Configuration;

namespace HealthVault.Sample.Xamarin.UWP
{
    public sealed partial class MainPage
    {
        public MainPage()
        {
            this.InitializeComponent();

            var connection = HealthVaultConnectionFactory.Current.GetOrCreateSodaConnection(GetAppAuthConfiguration());

            LoadApplication(new Xamarin.App(connection));
        }

        private static HealthVaultConfiguration GetAppAuthConfiguration()
        {
            var appAuthConfiguration = new HealthVaultConfiguration
            {
                HealthVaultShellUrl = new Uri("https://account.healthvault-ppe.com/"),
                HealthVaultUrl = new Uri("https://platform.healthvault-ppe.com/platform/"),
                MasterApplicationId = Guid.Parse("<YOUR-APP-ID>"),
            };
            return appAuthConfiguration;
        }
    }
}
