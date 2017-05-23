using System;
using System.Globalization;
using Windows.UI.Xaml.Data;

namespace HealthVaultMobileSample.UWP.Converters
{
    public class WeightConverter : IValueConverter
    {
        /// <summary>
        /// Decides whether to convert the input kg into pounds or to leave them alone based on the CurrentUICulture
        /// </summary>
        /// <param name="kg">Input value in kilograms, should be specified as a double. </param>
        /// <param name="targetType">This parameter is ignored.</param>
        /// <param name="parameter">This parameter is ignored.</param>
        /// <param name="language">This parameter is ignored. </param>
        /// <returns></returns>
        public object Convert(object kg, Type targetType, object parameter, string language)
        {
            switch (CultureInfo.CurrentUICulture.Name)
            {
                case "en-US":
                    return Math.Round(Helpers.WeightHelper.ConvertKgToLbs((double)kg));
                default:
                    return kg;
            }
        }

        /// <summary>
        /// Decides whether the input value is in lbs or kg using the CurrentUICulture, and then converts to kg as appropriate.
        /// </summary>
        /// <param name="value"></param>
        /// <param name="targetType"></param>
        /// <param name="parameter"></param>
        /// <param name="language"></param>
        /// <returns></returns>
        public object ConvertBack(object value, Type targetType, object parameter, string language)
        {
            switch (CultureInfo.CurrentUICulture.Name)
            {
                case "en-US":
                    return Helpers.WeightHelper.ConvertLbsToKg((double)value);
                default:
                    return value;
            }
        }
    }
}
