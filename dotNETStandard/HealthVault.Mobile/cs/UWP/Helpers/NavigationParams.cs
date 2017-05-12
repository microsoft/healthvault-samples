using Microsoft.HealthVault.Connection;

namespace HealthVaultMobileSample.UWP.Helpers
{
    public class NavigationParams
    {
        public IHealthVaultConnection Connection { get; set; }
        public object Context { get; set; }
    }
}
