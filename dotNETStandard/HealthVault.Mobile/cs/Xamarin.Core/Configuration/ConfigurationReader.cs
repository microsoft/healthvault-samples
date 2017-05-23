using System;
using System.IO;
using System.Reflection;
using Microsoft.HealthVault.Configuration;
using Newtonsoft.Json;

namespace HealthVault.Sample.Xamarin.Core.Configuration
{
    public static class ConfigurationReader
    {
        public static HealthVaultConfiguration ReadConfiguration()
        {
            Assembly assembly = typeof(ConfigurationReader).GetTypeInfo().Assembly;

            using (var stream = assembly.GetManifestResourceStream("HealthVault.Sample.Xamarin.Core.Config.json"))
            using (var streamReader = new StreamReader(stream))
            using (var jsonTextReader = new JsonTextReader(streamReader))
            {
                var serializer = new JsonSerializer();
                return serializer.Deserialize<HealthVaultConfiguration>(jsonTextReader);
            }
        }
    }
}