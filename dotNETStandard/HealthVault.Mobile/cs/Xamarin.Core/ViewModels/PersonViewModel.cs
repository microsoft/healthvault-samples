namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    class PersonViewModel
    {
        public string FirstNameLabel { get; set; } = "First name";
        public string LastNameLabel { get; set; } = "Last name";
        public string BirthMonthLabel { get; set; } = "Birth month";
        public string BirthYearLabel { get; set; } = "Birth year";
        public string GenderLabel { get; set; } = "Gender";
        public string WeightLabel { get; set; } = "Weight";

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string BirthMonth { get; set; }
        public string BirthYear { get; set; }
        public string Gender { get; set; }
        public string Weight { get; set; }
    }
}