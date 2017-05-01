using HealthVault.Sample.Xamarin.Core.Services;

namespace HealthVault.Sample.Xamarin.UWP
{
    public class PlatformResourceProvider: IPlatformResourceProvider
    {
        public string ActionPlanIcon { get; } = "Assets/Health/ap_icon.png";
        public string MedsIcon { get; } = "Assets/Health/meds_icon.png";
        public string WeightIcon { get; } = "Assets/Health/weight_icon.png";
        public string DisclosureIcon { get; } = "Assets/Health/disclosure_icon.png";
        public string ProfileIcon { get; } = "Assets/Health/profile_icon.png";

    }
}