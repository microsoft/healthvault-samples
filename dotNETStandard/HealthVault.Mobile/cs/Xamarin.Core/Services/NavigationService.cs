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

        public void RegisterNavigateEvents(NavigationPage navigationPage)
        {
            navigationPage.Pushed += NavigationPageOnPushed;
            navigationPage.Popped += NavigationPageOnPopped;

            // Cover the corner case: the first page doesn't fire the Pushed event but we still want to
            // call the relevant methods.
            navigationPage.Appearing += (sender, args) => HandleNavigationPageAppearing(navigationPage);
        }

        private void NavigationPageOnPushed(object sender, NavigationEventArgs navigationEventArgs)
        {
            var viewModel = navigationEventArgs.Page?.BindingContext as ViewModel;
            viewModel?.OnNavigateToAsync();
        }

        private void NavigationPageOnPopped(object sender, NavigationEventArgs navigationEventArgs)
        {
            var viewModel = GetNextPage()?.BindingContext as ViewModel;
            viewModel?.OnNavigateBackAsync();
        }

        private void HandleNavigationPageAppearing(NavigationPage page)
        {
            ViewModel viewModel = page.CurrentPage?.BindingContext as ViewModel;
            viewModel?.OnNavigateToAsync();
        }

        private Page GetNextPage()
        {
            return CurrentApplication.MainPage?.Navigation.NavigationStack.LastOrDefault();
        }
    }
}