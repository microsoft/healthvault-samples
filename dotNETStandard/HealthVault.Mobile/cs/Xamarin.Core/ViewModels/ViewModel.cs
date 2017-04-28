using System.Threading.Tasks;
using HealthVault.Sample.Xamarin.Core.Services;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public abstract class ViewModel : ExtendedBindableObject, ICanNavigateBack
    {
        protected readonly IPlatformResourceProvider ResourceProvider;
        protected readonly INavigationService NavigationService;

        private bool isBusy;

        public bool IsBusy
        {
            get => isBusy;
            set
            {
                isBusy = value;
                RaisePropertyChanged(() => IsBusy);
            }
        }

        protected ViewModel(INavigationService navigationService, IPlatformResourceProvider resourceProvider)
        {
            ResourceProvider = resourceProvider;
            NavigationService = navigationService;
        }

        public virtual Task InitializeAsync(object navigationData)
        {
            return Task.FromResult(false);
        }

        public virtual async Task OnNavigateBack()
        {
            await Task.CompletedTask;
        }
    }

    public interface ICanNavigateBack
    {
        Task OnNavigateBack();
    }
}
