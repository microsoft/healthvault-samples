using HealthVault.Sample.Xamarin.Core.Services;

namespace Xamarin.iOS
{
    public class PlatformResourceProvider: IPlatformResourceProvider
    {
        public string MedsIcon { get; } = "meds_icon.png";
        public string WeightIcon { get; } = "weight_icon.png";
    }
}