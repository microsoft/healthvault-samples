using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationViewModel : ViewModel
    {
        public ObservableCollection<MedicationViewRow> Items { get; }

        public ICommand EditCommand { get; }

        public MedicationViewModel(INavigationService navigationService,
            IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            EditCommand = new Command(async () => await GoToEditAsync());

            Items = new ObservableCollection<MedicationViewRow>()
            {
                new MedicationViewRow()
                {
                    Title = StringResource.Name,
                    Value = "Duloxetine"
                },

                new MedicationViewRow()
                {
                    Title = StringResource.Strength,
                    Value = "35 Milligram (mg)"
                },
                new MedicationViewRow()
                {
                    Title = StringResource.Dosage,
                    Value = "1 Capsules"
                },
                new MedicationViewRow()
                {
                    Title = StringResource.HowOftenTaken,
                    Value = "1 time daily"
                },
                new MedicationViewRow()
                {
                    Title = StringResource.HowTaken,
                    Value = "By mouth"
                },
                new MedicationViewRow()
                {
                    Title = StringResource.ReasonForTaking,
                    Value = "Generalized Anxiety"
                },
                new MedicationViewRow()
                {
                    Title = StringResource.DateStarted,
                    Value = "10/5/2016"
                },
            };
        }

        private async Task GoToEditAsync()
        {
            var viewModel = new MedicationEditViewModel(NavigationService, ResourceProvider)
            {
                Name = "Duloxetine",
                DosageType = "Tablet",
                Strength = "37.5 mg"
            };

            var medicationsMainPage = new MedicationEditPage()
            {
                BindingContext = viewModel,
            };
            await NavigationService.NavigateAsync(medicationsMainPage);

        }

        public string EditButtonLabel { get; set; } = StringResource.EditDetails;
    }

    public class MedicationViewRow
    {
        public string Title { get; set; }
        public string Value { get; set; }
    }
}