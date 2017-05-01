using System;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MenuItemViewRow: ExtendedBindableObject
    {
        private bool openning;
        public string ImageUrl { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public Color BackgroundColor { get; set; }
        public string DisclosureImagePath { get; set; }

        public bool Openning
        {
            get => openning;
            set
            {
                openning = value;
                RaisePropertyChanged(() => Openning);
            }
        }

        public Func<Task> PageAction { get; set; }
    }
}
