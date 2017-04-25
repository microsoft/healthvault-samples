using System;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MenuItemViewRow
    {
        public string ImageUrl { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public Color BackgroundColor { get; set; }
        public string DisclosureImagePath { get; set; }
        public Func<Task> PageAction { get; set; }
    }
}
