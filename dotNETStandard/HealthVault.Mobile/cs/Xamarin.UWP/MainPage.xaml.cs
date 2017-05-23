namespace HealthVault.Sample.Xamarin.UWP
{
    public sealed partial class MainPage
    {
        public MainPage()
        {
            InitializeComponent();

            LoadApplication(new Core.App());
        }
    }
}
