using System;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MenuItemViewRow : BindableObject
    {
        private bool opening;

        public string ImageUrl { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public Color BackgroundColor { get; set; }
        public string DisclosureImagePath { get; set; }

        public bool Opening
        {
            get { return this.opening; }

            set
            {
                this.opening = value;
                this.OnPropertyChanged();
            }
        }

        public Func<Task> PageAction { get; set; }
    }
}
