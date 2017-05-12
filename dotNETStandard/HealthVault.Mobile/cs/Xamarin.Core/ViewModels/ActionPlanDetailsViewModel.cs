using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows;
using Microsoft.HealthVault.RestApi.Generated.Models;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ActionPlanDetailsViewModel : ViewModel
    {
        public ActionPlanDetailsViewModel(ActionPlanInstance actionPlanInstance, INavigationService navigationService)
            : base(navigationService)
        {
            this.Plan = actionPlanInstance;

        }

        public ActionPlanInstance Plan { get; }

        public override Task OnNavigateToAsync()
        {
            

            return base.OnNavigateToAsync();
        }
    }
}
