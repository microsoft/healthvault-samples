using System;
using HealthVault.Sample.Xamarin.Core.Services;
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

            LoadApplication(new Core.App(connection, new NavigationService(), new PlatformResourceProvider()));
        }

        // TODO: Move to config
        private static HealthVaultConfiguration GetAppAuthConfiguration()
        {
            var appAuthConfiguration = new HealthVaultConfiguration
            {
                HealthVaultShellUrl = new Uri("https://account.healthvault-ppe.com/"),
                HealthVaultUrl = new Uri("https://platform.healthvault-ppe.com/platform/"),
                MasterApplicationId = Guid.Parse("cc7db39e-f425-445a-8de6-75271b7ecbfa"),
            };
            return appAuthConfiguration;
        }
    }
}
