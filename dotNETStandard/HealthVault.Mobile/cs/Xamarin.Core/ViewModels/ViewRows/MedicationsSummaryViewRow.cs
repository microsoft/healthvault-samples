using System;
using System.Collections.Generic;
using Microsoft.HealthVault.ItemTypes;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MedicationsSummaryViewRow
    {
        public MedicationsSummaryViewRow(Medication medication)
        {
            Medication = medication;

            Text = medication.Name?.Text ?? "";
            Detail = DataTypeFormatter.FormatMedicationDetail(medication.Strength, medication.Dose);

            string note = medication.CommonData?.Note;
            if (note != null)
            {
                Note = note;
            }
            else
            {
                DateTimeOffset now = DateTimeOffset.Now;
                ApproximateDate today = new ApproximateDate(now.Year, now.Month, now.Day);

                var noteParts = new List<string>();

                ApproximateDate approximateDateStarted = medication.DateStarted?.ApproximateDate;
                if (approximateDateStarted != null)
                {
                    noteParts.Add(string.Format(
                        StringResource.PrescribedDateFormat,
                        FormatApproximateDate(approximateDateStarted)));
                }

                ApproximateDate approximateDateEnded = medication.DateDiscontinued?.ApproximateDate;
                if (approximateDateEnded != null && approximateDateEnded < today)
                {
                    noteParts.Add(string.Format(StringResource.ExpiredDateFormat, FormatApproximateDate(approximateDateStarted)));
                }

                Note = string.Join(", ", noteParts);
            }
        }

        public Medication Medication { get; }

        public string Text { get; }
        public string Detail { get; }
        public string Note { get; }

        public override string ToString() => Text;

        private static string FormatApproximateDate(ApproximateDate date)
        {
            return date.Month + "/" + date.Day + "/" + date.Year;
        }
    }
}