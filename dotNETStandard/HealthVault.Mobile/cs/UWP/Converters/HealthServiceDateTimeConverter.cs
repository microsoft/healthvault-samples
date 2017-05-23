using System;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    public class HealthServiceDateTimeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, string language)
        {
            Microsoft.HealthVault.ItemTypes.HealthServiceDate date = ((Microsoft.HealthVault.ItemTypes.HealthServiceDateTime)value).Date;
            DateTime current = new DateTime(date.Year, date.Month, date.Day);
            return current.ToString(System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortDatePattern);
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            throw new NotImplementedException();
        }
    }
}
