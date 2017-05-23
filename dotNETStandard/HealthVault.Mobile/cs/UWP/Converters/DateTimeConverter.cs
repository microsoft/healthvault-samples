using System;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    public class DateTimeConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, string language)
        {
            DateTime current = (DateTime)value;
            return current.ToString(System.Globalization.DateTimeFormatInfo.CurrentInfo.ShortDatePattern);
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            throw new NotImplementedException();
        }
    }
}
