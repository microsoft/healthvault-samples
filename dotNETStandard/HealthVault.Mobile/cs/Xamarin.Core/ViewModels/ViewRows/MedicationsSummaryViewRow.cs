using Microsoft.HealthVault.ItemTypes;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MedicationsSummaryViewRow
    {
        public MedicationsSummaryViewRow(Medication medication, string disclosureImagePath)
        {
            Medication = medication;

            Text = medication.Name?.Text ?? "";
            Detail = DataTypeFormatter.FormatMedicationDetail(medication.Strength, medication.Dose);
            Note = medication.CommonData?.Note ?? "";
            DisclosureImagePath = disclosureImagePath;
        }

        public Medication Medication { get; }

        public string Text { get; }
        public string Detail { get; }
        public string Note { get; }
        public string DisclosureImagePath { get; }

        public override string ToString() => Text;
    }
}