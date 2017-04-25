namespace HealthVault.Sample.Xamarin.Core.Services
{
    public interface IPlatformResourceProvider
    {
        string ActionPlanIcon { get; }
        string MedsIcon { get; }
        string WeightIcon { get; }
        string DisclosureIcon { get; }
    }
}