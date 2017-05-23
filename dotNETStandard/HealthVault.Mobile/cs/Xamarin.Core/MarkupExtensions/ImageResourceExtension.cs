using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace HealthVault.Sample.Xamarin.Core.MarkupExtensions
{
    [ContentProperty("Source")]
    public class ImageResourceExtension : IMarkupExtension
    {
        public string Source { get; set; }

        public object ProvideValue(IServiceProvider serviceProvider)
        {
            if (Source == null)
            {
                return null;
            }

            var imageSource = ImageSource.FromResource("HealthVault.Sample.Xamarin.Core.Images." + Source);

            return imageSource;
        }
    }
}
