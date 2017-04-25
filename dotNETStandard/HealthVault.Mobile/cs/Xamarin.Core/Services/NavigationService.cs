using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.Services
{
    public class NavigationService : INavigationService
    {
        private Application CurrentApplication => Application.Current;
        
        public async Task NavigateAsync(Page page)
        {
            await CurrentApplication.MainPage.Navigation.PushAsync(page);
        }
    }
}