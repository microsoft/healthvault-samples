using HealthVault.Sample.Xamarin.Core.Services;

namespace HealthVaultSampleIos
{
    public class PlatformResourceProvider: IPlatformResourceProvider
    {
        public string ActionPlanIcon { get; } = "ap_icon.png";
        public string MedsIcon { get; } = "meds_icon.png";
        public string WeightIcon { get; } = "weight_icon.png";
        public string DisclosureIcon { get; } = "disclosure_icon.png";
        public string ProfileIcon { get; } = "profile_icon.png";
    }
}