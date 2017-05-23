using System;
using Microsoft.HealthVault.ItemTypes;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    /// <summary>
    /// Converts an ApproximateDateTime to a string.
    /// </summary>
    public class ApproximateDateTimeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, string language)
        {
            if (value != null)
            {
                var approxDateTime = value as ApproximateDateTime;

                // If ApproximateDateTime.Description is set, then we don't expect anything else to be present. Just output that content directly.
                if (!String.IsNullOrEmpty(approxDateTime.Description))
                {
                    return approxDateTime.Description;
                }
                else
                {
                    ApproximateDate date = approxDateTime.ApproximateDate;
                    var year = date.Year;
                    var month = (date.Month != null) ? date.Month.Value : 1;
                    var day = (date.Day != null) ? date.Day.Value : 1;
                    DateTime current = new DateTime(year, month, day);
                    return current.ToString(System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortDatePattern);
                }
            }
            else
            {
                return null;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            throw new NotImplementedException();
        }
    }
}
