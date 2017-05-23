using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels.ViewRows
{
    public class MenuItemViewRow : BindableObject
    {
        private bool _opening;

        public MenuItemViewRow()
        {
            OpenCommand = new Command(async o => await PageAction());
        }

        public ICommand OpenCommand { get; }

        public ImageSource Image { get; set; }

        public string Title { get; set; }
        public string Description { get; set; }
        public Color BackgroundColor { get; set; }

        public bool Opening
        {
            get { return _opening; }

            set
            {
                _opening = value;
                OnPropertyChanged();
            }
        }

        public Func<Task> PageAction { get; set; }
    }
}
