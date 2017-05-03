using System;
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
            navigationPage.Popped += this.NavigationPageOnPopped;
            navigationPage.Appearing += (sender, args) => this.HandleNavigationPageAppearing(navigationPage);
        }

        private void NavigationPageOnPopped(object sender, NavigationEventArgs navigationEventArgs)
        {
            var viewModel = this.GetNextPage()?.BindingContext as ViewModel;
            viewModel?.OnNavigateBackAsync();

            //var viewModel = navigationEventArgs.Page?.BindingContext as ViewModel;
            //viewModel?.OnNavigateBackAsync();
        }

        private void HandleNavigationPageAppearing(NavigationPage page)
        {
            ViewModel viewModel = page.CurrentPage?.BindingContext as ViewModel;
            viewModel?.OnNavigateToAsync();
        }

        private Page GetNextPage()
        {
            return this.CurrentApplication.MainPage?.Navigation.NavigationStack.LastOrDefault();
        }
    }
}