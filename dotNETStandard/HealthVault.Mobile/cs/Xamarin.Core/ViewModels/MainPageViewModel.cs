using System.Threading.Tasks;
using System.Windows.Input;
using Microsoft.HealthVault.Client;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.ViewModels
{
    public class MainPageViewModel
    {
        private readonly IHealthVaultSodaConnection connection;

        public MainPageViewModel(IHealthVaultSodaConnection connection)
        {
            this.connection = connection;
            LoginCommand = new Command(async () => await Login());
        }

        private async Task Login()
        {
            await connection.AuthenticateAsync();

            var personInfo = await connection.GetPersonInfoAsync();

        }

        public ICommand LoginCommand { private set; get; }
    }
}