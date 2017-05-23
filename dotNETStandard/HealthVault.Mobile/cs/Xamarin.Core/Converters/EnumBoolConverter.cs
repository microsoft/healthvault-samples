using System;
using System.Globalization;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.Converters
{
    public class EnumBoolConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value.ToString() == parameter.ToString();
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
