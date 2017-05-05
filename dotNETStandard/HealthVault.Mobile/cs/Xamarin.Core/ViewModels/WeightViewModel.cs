using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class WeightViewModel: ViewModel
    {
        public double LastWeight { get; set; }
        public ICommand AddCommand { get; }

        public WeightViewModel(
            IEnumerable<Weight> weights,
            IThingClient thingClient,
            Guid recordId,
            INavigationService navigationService) : base(navigationService)
        {
            AddCommand = new Command(async () => await GoToAddWeightPageAsync(thingClient, recordId));

            LastWeight = weights.FirstOrDefault()?.Value.DisplayValue.Value ?? 0;
        }

        private async Task GoToAddWeightPageAsync(IThingClient thingClient, Guid recordId)
        {
            
        }
    }
}
