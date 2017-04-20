using System.Collections.ObjectModel;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MenuViewModel: ViewModel
    {
        public ObservableCollection<MenuItemViewRow> MenuViewRows { get; } = new ObservableCollection<MenuItemViewRow>();

        public MenuViewModel(INavigationService navigationService, IPlatformResourceProvider resourceProvider) 
            : base(navigationService, resourceProvider)
        {
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Profile",
                Description = "Edit personal information associated with HealthVault",
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Medications",
                Description = "Edit Medications information associated with HealthVault",
                ImageSource = ResourceProvider.MedsIcon,
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Weight",
                Description = "Edit Weight information associated with HealthVault",
                ImageSource = ResourceProvider.WeightIcon,
            });
        }

    }
}