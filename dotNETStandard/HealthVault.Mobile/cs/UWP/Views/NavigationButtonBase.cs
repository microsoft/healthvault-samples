using System;

namespace HealthVaultMobileSample.UWP.Views
{
    /// <summary>
    /// This class contains the base properties for a NavigationButton.
    /// </summary>
    public class NavigationButtonBase
    {
        public string Description { get; set; }
        public string ImageSource { get; set; }
        public string Title { get; set; }

        /// <summary>
        /// RGB color string in the format "#FFFFFF"
        /// </summary>
        public string BackgroundColor { get; set; }
        public Type Destination { get; set; }
        public string FontIcon { get; set; }
    }
}
