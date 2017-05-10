using System;
using Microsoft.HealthVault.ItemTypes;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public static class DataTypeFormatter
    {
        public static DateTime EmptyDate { get; } = new DateTime(1900, 1, 1);

        public static string ApproximateDateTimeToString(ApproximateDateTime medicationDateStarted)
        {
            var current = ApproximateDateTimeToDateTime(medicationDateStarted);
            return current.ToString(System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortDatePattern);
        }

        public static DateTime ApproximateDateTimeToDateTime(ApproximateDateTime medicationDateStarted)
        {
            ApproximateDate date = medicationDateStarted?.ApproximateDate;
            DateTime current;
            if (date == null)
            {
                current = EmptyDate;
            }
            else
            {
                var year = date.Year;
                var month = (date.Month != null) ? date.Month.Value : 1;
                var day = (date.Day != null) ? date.Day.Value : 1;
                current = new DateTime(year, month, day);
            }
            return current;
        }

        public static string FormatMedicationDetail(GeneralMeasurement medicationStrength, GeneralMeasurement medicationDose)
        {
            if (medicationStrength == null)
            {
                return medicationDose?.Display ?? "";
            }
            if (medicationDose == null)
            {
                return medicationStrength?.Display ?? "";
            }
            return $"{medicationStrength.Display}, {medicationDose.Display}";
        }
    }
}