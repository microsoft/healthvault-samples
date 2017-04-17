using HealthVault.Sample.Xamarin.ViewModels;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin
{
    public partial class App : Application
    {
        public App()
        {
            InitializeComponent();

            var mainPage = new MainPage()
            {
                BindingContext = new MainPageViewModel(),
            };

            MainPage = mainPage;
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
