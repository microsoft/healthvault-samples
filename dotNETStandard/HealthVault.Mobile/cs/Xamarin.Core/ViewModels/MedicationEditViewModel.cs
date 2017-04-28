using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class MedicationEditViewModel : ViewModel
    {
        public string Name { get; set; }
        public string DosageType { get; set; }
        public string Strength { get; set; }
        public string TreatmentProvider { get; set; }
        public string ReasonForTaking { get; set; }
        public DateTime DateStarted { get; set; }

        public ICommand SaveCommand { get; }

        public MedicationEditViewModel(Medication medication, IThingClient thingClient, Guid recordId, INavigationService navigationService, IPlatformResourceProvider resourceProvider) : base(navigationService, resourceProvider)
        {
            Name = medication.Name?.Text ?? "";
            DosageType = medication.Dose?.Display ?? "";
            Strength = medication.Strength?.Display ?? "";
            ReasonForTaking = medication.Indication?.Text ?? "";
            DateStarted = DataTypeFormatter.ApproximateDateTimeToDateTime(medication.DateStarted);
            SaveCommand = new Command(async () => await SaveAsync(medication, thingClient, recordId));
        }

        private async Task SaveAsync(Medication medication, IThingClient thingClient, Guid recordId)
        {
            UpdateMedication(medication);

            await thingClient.UpdateThingsAsync(recordId, new Collection<Medication>() { medication });

            await NavigationService.NavigateBackAsync();
        }

        private void UpdateMedication(Medication medication)
        {
            if (!string.IsNullOrWhiteSpace(Name))
            {
                medication.Name = new CodableValue(Name);
            }
            bool empty = string.IsNullOrWhiteSpace(DosageType) && medication.Dose == null;
            if (!empty)
            {
                medication.Dose = new GeneralMeasurement(DosageType);
            }

            empty = string.IsNullOrWhiteSpace(Strength) && medication.Strength == null;
            if (!empty)
            {
                medication.Strength = new GeneralMeasurement(Strength);
            }

            empty = string.IsNullOrWhiteSpace(ReasonForTaking) && medication.Indication == null;
            if (!empty)
            {
                medication.Indication = new CodableValue(ReasonForTaking);
            }

            var inputDateEmpty = DateStarted == DataTypeFormatter.EmptyDate;
            empty = inputDateEmpty && medication.DateStarted == null;
            if (!empty)
            {
                medication.DateStarted = new ApproximateDateTime(DateStarted);
            }
        }
    }
}