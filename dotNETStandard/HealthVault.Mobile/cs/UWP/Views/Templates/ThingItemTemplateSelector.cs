using System;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace HealthVaultMobileSample.UWP.Views.Templates
{
    /// <summary>
    /// Chooses a template based on a ThingBase's TypeName.
    /// </summary>
    public class ThingItemTemplateSelector : DataTemplateSelector
    {
        public DataTemplate BloodPressure { get; set; }
        public DataTemplate Weight { get; set; }
        public DataTemplate Default { get; set; }

        protected override DataTemplate SelectTemplateCore(object item)
        {
            switch (((Microsoft.HealthVault.Thing.ThingBase)item).TypeName)
            {
                case "Blood pressure":
                    return BloodPressure;
                case "Weight":
                    return Weight;
                default:
                    return Default;
            }
        }
    }
}
