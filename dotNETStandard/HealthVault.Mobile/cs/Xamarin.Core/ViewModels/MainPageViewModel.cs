using System.Windows.Input;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.ViewModels
{
    public class MainPageViewModel
    {
        public MainPageViewModel()
        {
            LoginCommand = new Command(Login);
        }

        private void Login()
        {
            
        }

        public ICommand LoginCommand { private set; get; }

    }
}