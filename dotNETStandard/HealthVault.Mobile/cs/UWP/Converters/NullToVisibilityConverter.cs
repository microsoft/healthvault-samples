using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    /// <summary>
    /// If the input is null, it returns Visibility.Collapsed. Otherwise, it returns Visibility.Visible. 
    /// </summary>
    public class NullToVisibilityConverter: IValueConverter
    {
        public object Convert(object value, Type targetType, object areNullsVisible, string language)
        {
            return value == null ? Visibility.Collapsed : Visibility.Visible;
        }

        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            throw new NotImplementedException();
        }
    }
}
