using HealthVault.Sample.Xamarin.Core.Services;

namespace HealthVault.Sample.Xamarin.UWP
{
    public class PlatformResourceProvider: IPlatformResourceProvider
    {
        public string MedsIcon { get; } = "/Assets/Health/meds_icon.png";
        public string WeightIcon { get; } = "/Assets/Health/weight_icon.png";
    }
}