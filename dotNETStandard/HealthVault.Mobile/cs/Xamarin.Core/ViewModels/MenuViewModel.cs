using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Models;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MenuViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection _connection;

        public ObservableCollection<MenuItemViewRow> MenuViewRows { get; } =
            new ObservableCollection<MenuItemViewRow>();

        public ICommand ItemSelectedCommand { get; }

        public MenuViewModel(
            IHealthVaultSodaConnection connection,
            INavigationService navigationService)
            : base(navigationService)
        {
            _connection = connection;
            ItemSelectedCommand = new Command<MenuItemViewRow>(async o => await GoToPageAsync(o));

            LoadState = LoadState.Loading;

            MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.ActionPlans,
                Description = StringResource.ActionPlansDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.ap_icon.png"),
                BackgroundColor = Color.FromHex("#e88829"),
                PageAction = async () => await OpenActionPlansPageAsync(),
            });
            MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.Medications,
                Description = StringResource.MedicationsDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.meds_icon.png"),
                BackgroundColor = Color.FromHex("#86bbbf"),
                PageAction = async () => await OpenMedicationsPageAsync(),
            });
            MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.Weight,
                Description = StringResource.WeightDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.weight_icon.png"),
                BackgroundColor = Color.FromHex("#f8b942"),
                PageAction = async () => await OpenWeightPageAsync(),
            });
            MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.Profile,
                Description = StringResource.ProfileDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.profile_icon.png"),
                BackgroundColor = Color.FromHex("#00b294"),
                PageAction = async () => await OpenPersonPageAsync(),
            });
        }

        public override async Task OnNavigateToAsync()
        {
            await LoadAsync(async () =>
            {
                await _connection.AuthenticateAsync();
            });
        }

        private async Task GoToPageAsync(MenuItemViewRow obj)
        {
            obj.Opening = true;

            try
            {
                await obj.PageAction();
            }
            catch (Exception exception)
            {
                await DisplayAlertAsync(StringResource.ErrorDialogTitle, exception.ToString());
            }
            finally
            {
                obj.Opening = false;
            }
        }

        private async Task OpenActionPlansPageAsync()
        {
            var actionPlansPage = new ActionPlansPage
            {
                BindingContext = new ActionPlansViewModel(_connection, NavigationService)
            };
            await NavigationService.NavigateAsync(actionPlansPage);
        }

        private async Task OpenWeightPageAsync()
        {
            var medicationsMainPage = new WeightPage
            {
                BindingContext = new WeightViewModel(_connection, NavigationService)
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenMedicationsPageAsync()
        {
            var medicationsMainPage = new MedicationsMainPage
            {
                BindingContext = new MedicationsMainViewModel(_connection, NavigationService)
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenPersonPageAsync()
        {
            var personViewModel = new ProfileViewModel(_connection, NavigationService);
            var menuPage = new ProfilePage
            {
                BindingContext = personViewModel
            };

            await NavigationService.NavigateAsync(menuPage);
        }
    }
}