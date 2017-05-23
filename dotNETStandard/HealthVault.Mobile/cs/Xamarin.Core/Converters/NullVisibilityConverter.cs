using System;
using System.Globalization;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.Converters
{
    public class NullVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string str = (string)value;
            return !string.IsNullOrWhiteSpace(str);
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
