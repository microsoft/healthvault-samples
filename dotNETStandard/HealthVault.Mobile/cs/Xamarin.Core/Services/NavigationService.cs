using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.Services
{
    public class NavigationService : INavigationService
    {
        private Application CurrentApplication => Application.Current;
        
        public async Task NavigateBackAsync()
        {
            if (CurrentApplication.MainPage != null)
            {
                if (!(CurrentApplication.MainPage is Views.MainPage))
                {
                    await CurrentApplication.MainPage.Navigation.PopAsync();

                }
            }
        }

        public void Navigate(Page page)
        {
            CurrentApplication.MainPage = page;
        }
    }
}