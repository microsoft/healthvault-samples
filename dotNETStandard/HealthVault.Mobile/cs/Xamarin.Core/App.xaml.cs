using System.Threading.Tasks;
using HealthVault.Sample.Xamarin.Core.Configuration;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core
{
    public partial class App : Application
    {
        public App(
            IPlatformResourceProvider resourceProvider)
        {
            InitializeComponent();

            var connection = HealthVaultConnectionFactory.Current.GetOrCreateSodaConnection(ConfigurationReader.ReadConfiguration());

            var navigationService = new NavigationService();
            var mainPage = new LoginPage
            {
                BindingContext = new LoginPageViewModel(connection, navigationService, resourceProvider),
            };

            var navigationPage = new NavigationPage(mainPage);

            navigationService.RegisterNavigateBack(navigationPage);
            MainPage = navigationPage;
        }

        protected override void OnStart()
        {
            // Handle when your app starts
        }

        protected override void OnSleep()
        {
            // Handle when your app sleeps
        }

        protected override void OnResume()
        {
            // Handle when your app resumes
        }
    }
}
