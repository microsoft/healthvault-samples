using System;
using System.Globalization;

namespace HealthVaultMobileSample.UWP.Helpers
{
    public static class WeightHelper
    {
        private const double kgToLbsFactor = 2.20462;

        /// <summary>
        /// Converts from kilograms to pounds
        /// </summary>
        /// <param name="kg"></param>
        /// <returns></returns>
        public static double ConvertKgToLbs(double kg)
        {
            return kg * kgToLbsFactor;
        }

        /// <summary>
        /// Converts from pounds to kilograms
        /// </summary>
        /// <param name="lbs"></param>
        /// <returns></returns>
        public static double ConvertLbsToKg(double lbs)
        {
            return lbs / kgToLbsFactor;
        }

        /// <summary>
        /// Uses the CurrentUICulture to determine whether the user expects to see lbs or kg
        /// and returns an appropriate string which corresponds.
        /// </summary>
        /// <returns></returns>
        public static string GetUnitDisplayString()
        {
            switch (CultureInfo.CurrentUICulture.Name)
            {
                case "en-US":
                    return "lbs";
                default:
                    return "kg";
            }
        }
    }
}
