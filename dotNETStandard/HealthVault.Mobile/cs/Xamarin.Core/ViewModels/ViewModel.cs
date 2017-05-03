using System.Threading.Tasks;
using HealthVault.Sample.Xamarin.Core.Services;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public abstract class ViewModel : BindableObject
    {
        protected readonly IPlatformResourceProvider ResourceProvider;
        protected readonly INavigationService NavigationService;

        private bool isBusy;

        public bool IsBusy
        {
            get { return this.isBusy; }

            set
            {
                this.isBusy = value;
                this.OnPropertyChanged();
            }
        }

        protected ViewModel(INavigationService navigationService, IPlatformResourceProvider resourceProvider)
        {
            this.ResourceProvider = resourceProvider;
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
