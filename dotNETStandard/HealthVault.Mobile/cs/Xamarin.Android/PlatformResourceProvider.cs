using HealthVault.Sample.Xamarin.Core.Services;

namespace HealthVault.Sample.Xamarin.Android
{
    public class PlatformResourceProvider: IPlatformResourceProvider
    {
        public string MedsIcon { get; } = "meds_icon.png";
        public string WeightIcon { get; } = "weight_icon.png";
    }
}