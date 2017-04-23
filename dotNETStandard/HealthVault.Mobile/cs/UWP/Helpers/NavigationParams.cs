using Microsoft.HealthVault.Connection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HealthVaultMobileSample.UWP.Helpers
{
    public class NavigationParams
    {
        public IHealthVaultConnection Connection { get; set; }
        public object Context { get; set; }
    }
}
