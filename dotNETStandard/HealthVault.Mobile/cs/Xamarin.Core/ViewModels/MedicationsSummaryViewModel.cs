using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.Views;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationsSummaryViewModel : ViewModel
    {
        private readonly Medication medication;
        private ObservableCollection<MedicationItemViewRow> items;

        public ObservableCollection<MedicationItemViewRow> Items
        {
            get => items;
            private set
            {
                items = value;
                RaisePropertyChanged(() => Items);
            }
        }

        public ICommand EditCommand { get; }

        public MedicationsSummaryViewModel(Medication medication, IThingClient thingClient, Guid recordId, INavigationService navigationService, IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            this.medication = medication;
            EditCommand = new Command(async () => await GoToEditAsync(thingClient, recordId));

            UpdateDisplay();
        }

        public override async Task OnNavigateBack()
        {
            UpdateDisplay();
            await base.OnNavigateBack();
        }

        private void UpdateDisplay()
        {
            Items = new ObservableCollection<MedicationItemViewRow>
            {
                new MedicationItemViewRow
                {
                    Title = StringResource.Name,
                    Value = medication.Name?.Text ?? ""
                },
                new MedicationItemViewRow
                {
                    Title = StringResource.Strength,
                    Value = medication.Strength?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.Dosage,
                    Value = medication.Dose?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.HowOftenTaken,
                    Value = medication.Frequency?.Display ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.HowTaken,
                    Value = medication.Route?.Text ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.ReasonForTaking,
                    Value = medication.Indication?.Text ?? ""
                },
                new MedicationItemViewRow()
                {
                    Title = StringResource.DateStarted,
                    Value = DataTypeFormatter.ApproximateDateTimeToString(medication.DateStarted)
                },
            };
        }

        private async Task GoToEditAsync(IThingClient thingClient, Guid recordId)
        {
            var viewModel = new MedicationEditViewModel(medication, thingClient, recordId, NavigationService, ResourceProvider);

            var medicationsMainPage = new MedicationEditPage()
            {
                BindingContext = viewModel,
            };
            await NavigationService.NavigateAsync(medicationsMainPage);

        }
    }

    public class MedicationItemViewRow
    {
        public string Title { get; set; }
        public string Value { get; set; }
    }
}