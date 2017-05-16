using System;
using System.Threading.Tasks;
using HealthVault.Sample.Xamarin.Core.Models;
using HealthVault.Sample.Xamarin.Core.Services;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public abstract class ViewModel : BindableObject
    {
        protected readonly INavigationService NavigationService;

        private LoadState loadState;

        public LoadState LoadState
        {
            get { return this.loadState; }

            set
            {
                this.loadState = value;
                this.OnPropertyChanged();
            }
        }

        private string errorText;

        public string ErrorText
        {
            get { return this.errorText; }

            set
            {
                this.errorText = value;
                this.OnPropertyChanged();
            }
        }

        protected async Task LoadAsync(Func<Task> loadFunc)
        {
            this.LoadState = LoadState.Loading;

            try
            {
                await loadFunc();

                this.LoadState = LoadState.Loaded;
            }
            catch (Exception exception)
            {
                this.ErrorText = exception.ToString();
                this.LoadState = LoadState.Error;
            }
        }

        protected async Task DisplayAlertAsync(string title, string message)
        {
            var navStack = Application.Current.MainPage.Navigation.NavigationStack;
            await navStack[navStack.Count - 1].DisplayAlert(title, message, StringResource.OK);
        }

        protected ViewModel(INavigationService navigationService)
        {
            this.LoadState = LoadState.Loaded;
            this.NavigationService = navigationService;
        }

        public virtual Task InitializeAsync(object navigationData)
        {
            return Task.CompletedTask;
        }

        public virtual Task OnNavigateBackAsync()
        {
            return Task.CompletedTask;
        }

        public virtual Task OnNavigateToAsync()
        {
            return Task.CompletedTask;
        }
    }
}
