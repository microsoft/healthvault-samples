using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Client;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
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
                PageAction = async () => await OpenWeightPageAsync(),
            });
            this.MenuViewRows.Add(new MenuItemViewRow()
            {
                Title = StringResource.Profile,
                Description = StringResource.ProfileDescription,
                DisclosureImagePath = ResourceProvider.DisclosureIcon,
                PageAction = async () => await OpenPersonPageAsync(),
                BackgroundColor = Color.FromHex("#00b294"),
                ImageUrl = ResourceProvider.ProfileIcon,
            });
        }

        private async Task GoToPageAsync(MenuItemViewRow obj)
        {
            obj.Opening = true;
            await obj.PageAction();
            obj.Opening = false;
        }

        private async Task OpenWeightPageAsync()
        {
            var person = await connection.GetPersonInfoAsync();
            IThingClient thingClient = connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            IReadOnlyCollection<Weight> items = await thingClient.GetThingsAsync<Weight>(record.Id);

            var medicationsMainPage = new WeightPage
            {
                BindingContext = new WeightViewModel(items, thingClient, record.Id, NavigationService, ResourceProvider)
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenMedicationsPageAsync()
        {
            var person = await connection.GetPersonInfoAsync();
            IThingClient thingClient = connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            IReadOnlyCollection<Medication> items = await thingClient.GetThingsAsync<Medication>(record.Id);

            var medicationsMainPage = new MedicationsMainPage
            {
                BindingContext = new MedicationsMainViewModel(items, thingClient, record.Id, NavigationService, ResourceProvider)
            };
            await NavigationService.NavigateAsync(medicationsMainPage);
        }

        private async Task OpenPersonPageAsync()
        {
            var person = await connection.GetPersonInfoAsync();
            var thingClient = connection.CreateThingClient();
            HealthRecordInfo record = person.SelectedRecord;
            Guid recordId = record.Id;
            BasicV2 basicInformation = (await thingClient.GetThingsAsync<BasicV2>(recordId)).FirstOrDefault();
            IReadOnlyCollection<Weight> weights = await thingClient.GetThingsAsync<Weight>(recordId);
            double weight = weights.Count > 0 ? weights.First().Value.DisplayValue.Value : 0;

            ImageSource imageSource = await GetImage(thingClient, recordId);

            var personViewModel = new PersonViewModel()
            {
                FirstName = record.DisplayName,
                BirthMonth = "",
                BirthYear = basicInformation.BirthYear.HasValue ? basicInformation.BirthYear.Value.ToString() : "",
                Gender = basicInformation.Gender.HasValue ? basicInformation.Gender.Value.ToString() : "",
                Weight = weight.ToString(),
                ImageSource = imageSource,

            };
            var menuPage = new PersonPage()
            {
                BindingContext = personViewModel
            };

            await NavigationService.NavigateAsync(menuPage);
        }

        private async Task<ImageSource> GetImage(IThingClient thingClient, Guid recordId)
        {
            var query = new ThingQuery(PersonalImage.TypeId)
            {
                View = { Sections = ThingSections.Xml | ThingSections.BlobPayload | ThingSections.Signature }
            };

            var things = await thingClient.GetThingsAsync(recordId, query);
            IThing firstThing = things.FirstOrDefault()?.FirstOrDefault();
            if (firstThing == null)
            {
                return null;
            }
            PersonalImage image = (PersonalImage)firstThing;
            return ImageSource.FromStream(() => image.ReadImage());
        }
    }
}