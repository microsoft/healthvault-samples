using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class LoginPageViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection connection;

        public LoginPageViewModel(
            IHealthVaultSodaConnection connection,
            INavigationService navigationService, 
            IPlatformResourceProvider resourceProvider) : 
            base(navigationService, resourceProvider)
        {
            this.connection = connection;
        }

        public override async Task OnNavigateToAsync()
        {
            await this.connection.AuthenticateAsync();

            var menuPage = new MenuPage
            {
                BindingContext = new MenuViewModel(this.connection, this.NavigationService, this.ResourceProvider)
            };
            await this.NavigationService.NavigateAsync(menuPage);
        }
    }
}