using System;
using Microsoft.HealthVault.ItemTypes;
using Windows.ApplicationModel.Resources;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    public class StructuredMeasurementConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, string language)
        {
            ResourceLoader loader = new ResourceLoader();
            var structured = (value as GeneralMeasurement);
            if (structured != null &&
                structured.Structured != null &&
                structured.Structured.Count > 0)
            {
                var item = structured.Structured[0];

                if (item.Units?.Text == "h")
                {
                    return String.Format(loader.GetString("StructuredHoursString"), item.Value);
                }
                else return item.ToString();
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
