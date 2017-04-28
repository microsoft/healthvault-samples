using System.Linq;
using System.Threading.Tasks;
using HealthVault.Sample.Xamarin.Core.ViewModels;
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

        public async Task NavigateBackAsync()
        {
            await CurrentApplication.MainPage.Navigation.PopAsync();
        }

        public void RegisterNavigateBack(NavigationPage navigationPage)
        {
            navigationPage.Popped += async (sender, args) => await OnPopped();
        }

        private async Task OnPopped()
        {
            var viewModel = GetNextPage()?.BindingContext as ICanNavigateBack;
            if (viewModel != null)
            {
                await viewModel.OnNavigateBack();
            }
        }

        private Page GetNextPage()
        {
            return CurrentApplication.MainPage?.Navigation.NavigationStack.LastOrDefault();
        }
    }
}