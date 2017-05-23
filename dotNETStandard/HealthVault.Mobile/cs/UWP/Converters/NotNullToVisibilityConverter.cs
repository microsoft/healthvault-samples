using System;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    public class NotNullToVisibilityConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object areNullsVisible, string language)
        {
            return value == null ? Visibility.Visible : Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            throw new NotImplementedException();
        }
    }
}
