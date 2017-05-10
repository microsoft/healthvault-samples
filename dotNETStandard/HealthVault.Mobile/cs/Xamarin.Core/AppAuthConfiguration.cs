using System;

namespace HealthVault.Sample.Xamarin
{
    public class AppAuthConfiguration
    {
        public Uri HealthVaultUrl { get; set; }
        public Uri HealthVaultShellUrl { get; set; }
        public Guid MasterApplicationId { get; set; }

    }
}