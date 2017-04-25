using HealthVault.Sample.Xamarin.Core.Configuration;
using Microsoft.HealthVault.Client;

namespace HealthVault.Sample.Xamarin.UWP
{
    public sealed partial class MainPage
    {
        public MainPage()
        {
            this.InitializeComponent();

            var connection = HealthVaultConnectionFactory.Current.GetOrCreateSodaConnection(DefaultConfiguration.GetPpeDefaultConfiguration());

            LoadApplication(new Core.App(connection, new PlatformResourceProvider()));
        }
    }
}
