using HealthVault.Sample.Xamarin.Core.Configuration;
using Microsoft.HealthVault.Client;

namespace HealthVault.Sample.Xamarin.UWP
{
    public sealed partial class MainPage
    {
        public MainPage()
        {
            this.InitializeComponent();

            LoadApplication(new Core.App(new PlatformResourceProvider()));
        }
    }
}
