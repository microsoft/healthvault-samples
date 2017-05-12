using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.Services
{
    public interface INavigationService
    {
        Task NavigateAsync(Page page);

        Task NavigateBackAsync();
    }
}