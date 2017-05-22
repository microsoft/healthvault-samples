using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Models;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using Microsoft.HealthVault.Vocabulary;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MenuViewModel : ViewModel
    {
        private readonly IHealthVaultSodaConnection connection;

        public ObservableCollection<MenuItemViewRow> MenuViewRows { get; } =
            new ObservableCollection<MenuItemViewRow>();

        public ICommand ItemSelectedCommand { get; }

        public MenuViewModel(
            IHealthVaultSodaConnection connection,
            INavigationService navigationService)
            : base(navigationService)
        {
            this.connection = connection;
            ItemSelectedCommand = new Command<MenuItemViewRow>(async o => await this.GoToPageAsync(o));

            this.LoadState = LoadState.Loading;

            this.MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.ActionPlans,
                Description = StringResource.ActionPlansDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.ap_icon.png"),
                BackgroundColor = Color.FromHex("#e88829"),
                PageAction = async () => await this.OpenActionPlansPageAsync(),
            });
            this.MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.Medications,
                Description = StringResource.MedicationsDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.meds_icon.png"),
                BackgroundColor = Color.FromHex("#86bbbf"),
                PageAction = async () => await this.OpenMedicationsPageAsync(),
            });
            this.MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.Weight,
                Description = StringResource.WeightDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.weight_icon.png"),
                BackgroundColor = Color.FromHex("#f8b942"),
                PageAction = async () => await this.OpenWeightPageAsync(),
            });
            this.MenuViewRows.Add(new MenuItemViewRow
            {
                Title = StringResource.Profile,
                Description = StringResource.ProfileDescription,
                Image = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images.profile_icon.png"),
                BackgroundColor = Color.FromHex("#00b294"),
                PageAction = async () => await this.OpenPersonPageAsync(),
            });
        }

        public override async Task OnNavigateToAsync()
        {
            await this.LoadAsync(async () =>
            {
                await this.connection.AuthenticateAsync();
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
                await this.DisplayAlertAsync(StringResource.ErrorDialogTitle, exception.ToString());
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
                BindingContext = new ActionPlansViewModel(this.connection, this.NavigationService)
            };
            await this.NavigationService.NavigateAsync(actionPlansPage);
        }

        private async Task OpenWeightPageAsync()
        {
            var medicationsMainPage = new WeightPage
            {
                BindingContext = new WeightViewModel(this.connection, this.NavigationService)
            };
            await this.NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenMedicationsPageAsync()
        {
            var medicationsMainPage = new MedicationsMainPage
            {
                BindingContext = new MedicationsMainViewModel(this.connection, this.NavigationService)
            };
            await this.NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenPersonPageAsync()
        {
            var personViewModel = new ProfileViewModel(this.connection, this.NavigationService);
            var menuPage = new ProfilePage
            {
                BindingContext = personViewModel
            };

            await this.NavigationService.NavigateAsync(menuPage);
        }
    }
}