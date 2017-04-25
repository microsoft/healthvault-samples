using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
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
            INavigationService navigationService,
            IPlatformResourceProvider resourceProvider)
            : base(navigationService, resourceProvider)
        {
            this.connection = connection;
            ItemSelectedCommand = new Command<MenuItemViewRow>(async o => await GoToPage(o));

            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Action plans",
                Description = "Get help accomplishing your goals in a structred way",
                ImageUrl = ResourceProvider.ActionPlanIcon,
                BackgroundColor = Color.FromHex("#e88829"),
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => { },
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Medications",
                Description = "Keep track of your current and past medications",
                ImageUrl = ResourceProvider.MedsIcon,
                BackgroundColor = Color.FromHex("#86bbbf"),
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => await OpenMedicationsPage(),
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Weight",
                Description = "One of many metrics you can keep track of here",
                ImageUrl = ResourceProvider.WeightIcon,
                BackgroundColor = Color.FromHex("#f8b942"),
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => { },
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = "Profile",
                Description = "Edit personal information associated with the account",
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => await OpenPersonPage(),
            });
        }

        private async Task GoToPage(MenuItemViewRow obj)
        {
            await obj.PageAction();
        }

        private async Task OpenMedicationsPage()
        {
            var medicationsMainPage = new MedicationsMainPage
            {
                BindingContext = new MedicationsMainViewModel(NavigationService, ResourceProvider)
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenPersonPage()
        {
            var person = await connection.GetPersonInfoAsync();
            var thingClient = connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            BasicV2 basicInformation = (await thingClient.GetThingsAsync<BasicV2>(record.Id)).FirstOrDefault();
            IReadOnlyCollection<Weight> weights = await thingClient.GetThingsAsync<Weight>(record.Id);
            double weight = weights.Count > 0 ? weights.First().Value.DisplayValue.Value : 0;
            var personViewModel = new PersonViewModel()
            {
                FirstName = record.DisplayName,
                BirthMonth = "",
                BirthYear = basicInformation.BirthYear.HasValue ? basicInformation.BirthYear.Value.ToString() : "",
                Gender = basicInformation.Gender.HasValue ? basicInformation.Gender.Value.ToString() : "",
                Weight = weight.ToString()
            };
            var menuPage = new PersonPage()
            {
                BindingContext = personViewModel
            };

            await NavigationService.NavigateAsync(menuPage);
        }
    }
}