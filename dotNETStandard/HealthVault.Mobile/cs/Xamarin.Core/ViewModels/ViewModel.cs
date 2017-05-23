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

        private LoadState _loadState;

        public LoadState LoadState
        {
            get { return _loadState; }

            set
            {
                _loadState = value;
                OnPropertyChanged();
            }
        }

        private string _errorText;

        public string ErrorText
        {
            get { return _errorText; }

            set
            {
                _errorText = value;
                OnPropertyChanged();
            }
        }

        protected async Task LoadAsync(Func<Task> loadFunc)
        {
            LoadState = LoadState.Loading;

            try
            {
                await loadFunc();

                LoadState = LoadState.Loaded;
            }
            catch (Exception exception)
            {
                ErrorText = exception.ToString();
                LoadState = LoadState.Error;
            }
        }

        protected async Task DisplayAlertAsync(string title, string message)
        {
            var navStack = Application.Current.MainPage.Navigation.NavigationStack;
            await navStack[navStack.Count - 1].DisplayAlert(title, message, StringResource.OK);
        }

        protected ViewModel(INavigationService navigationService)
        {
            LoadState = LoadState.Loaded;
            NavigationService = navigationService;
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
