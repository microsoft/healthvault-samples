using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.HealthVault.ItemTypes;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class WeightViewRow
    {
        public WeightViewRow(Weight weight)
        {
            DateTimeOffset date = new DateTimeOffset(weight.When.Date.Year, weight.When.Date.Month, weight.When.Date.Day, 0, 0, 0, TimeSpan.Zero);
            this.Day = date.ToString("ddd M/d");

            double pounds = weight.Value.Kilograms * WeightViewModel.KgToLbsFactor;
            this.Weight = pounds.ToString("N0") + " lbs";
        }

        public string Day { get; }

        public string Weight { get; }
    }
}
