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
            ItemSelectedCommand = new Command<MenuItemViewRow>(async o => await GoToPageAsync(o));

            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = StringResource.ActionPlans,
                Description = StringResource.ActionPlansDescription,
                ImageUrl = ResourceProvider.ActionPlanIcon,
                BackgroundColor = Color.FromHex("#e88829"),
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => { },
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = StringResource.Medications,
                Description = StringResource.MedicationsDescription,
                ImageUrl = ResourceProvider.MedsIcon,
                BackgroundColor = Color.FromHex("#86bbbf"),
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => await OpenMedicationsPageAsync(),
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = StringResource.Weight,
                Description = StringResource.WeightDescription,
                ImageUrl = ResourceProvider.WeightIcon,
                BackgroundColor = Color.FromHex("#f8b942"),
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => { },
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = StringResource.Profile,
                Description = StringResource.ProfileDescription,
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => await OpenPersonPageAsync(),
            });
        }

        private async Task GoToPageAsync(MenuItemViewRow obj)
        {
            await obj.PageAction();
        }

        private async Task OpenMedicationsPageAsync()
        {
            var medicationsMainPage = new MedicationsMainPage
            {
                BindingContext = new MedicationsMainViewModel(NavigationService, ResourceProvider)
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenPersonPageAsync()
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