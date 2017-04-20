using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.Services
{
    public interface INavigationService
    {
        Task NavigateBackAsync();
        void Navigate(Page page);
    }
}