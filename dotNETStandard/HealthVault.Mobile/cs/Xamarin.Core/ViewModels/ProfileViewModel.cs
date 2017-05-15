using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Thing;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ProfileViewModel : ViewModel
    {
        private readonly Guid recordId;
        private readonly BasicV2 basicInformation;
        private readonly Personal personalInformation;
        private readonly IThingClient thingClient;

        public ProfileViewModel(
            Guid recordId,
            BasicV2 basicInformation,
            Personal personalInformation,
            ImageSource profileImage,
            IThingClient thingClient,
            INavigationService navigationService) : base(navigationService)
        {
            this.recordId = recordId;
            this.basicInformation = basicInformation;
            this.personalInformation = personalInformation;
            this.thingClient = thingClient;

            this.SaveCommand = new Command(async () => await this.SaveProfileAsync());

            if (personalInformation.BirthDate != null)
            {
                this.BirthDate = personalInformation.BirthDate.ToDateTime();
            }
            else
            {
                this.BirthDate = DateTime.Now;
            }

            this.FirstName = personalInformation.Name?.First ?? string.Empty;
            this.LastName = personalInformation.Name?.Last ?? string.Empty;

            this.Genders = new List<string>
            {
                StringResource.Gender_Male,
                StringResource.Gender_Female,
            };

            this.GenderIndex = basicInformation.Gender != null && basicInformation.Gender.Value == Gender.Female ? 1 : 0;
            this.ImageSource = profileImage;
        }

        public ICommand SaveCommand { get; }

        public ImageSource ImageSource { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        private DateTime birthDate;

        public DateTime BirthDate
        {
            get { return this.birthDate; }

            set
            {
                this.birthDate = value;
                this.OnPropertyChanged();
            }
        }

        public List<string> Genders { get; }

        private int genderIndex;

        public int GenderIndex
        {
            get { return this.genderIndex; }

            set
            {
                this.genderIndex = value;
                this.OnPropertyChanged();
            }
        }

        private async Task SaveProfileAsync()
        {
            this.IsBusy = true;

            try
            {
                // Name property could be null. Construct it if we need to.
                if (this.personalInformation.Name == null && (!string.IsNullOrEmpty(this.FirstName) || !string.IsNullOrEmpty(this.LastName)))
                {
                    this.personalInformation.Name = new Name();
                }

                if (this.personalInformation.Name != null)
                {
                    // Only set first and last name if we have it
                    if (!string.IsNullOrEmpty(this.FirstName))
                    {
                        this.personalInformation.Name.First = this.FirstName;
                    }

                    if (!string.IsNullOrEmpty(this.LastName))
                    {
                        this.personalInformation.Name.Last = this.LastName;
                    }
                }

                this.basicInformation.BirthYear = this.BirthDate.Year;
                this.basicInformation.Gender = this.GenderIndex == 0 ? Gender.Male : Gender.Female;

                this.personalInformation.BirthDate = new HealthServiceDateTime(this.BirthDate);

                await this.thingClient.UpdateThingsAsync(this.recordId, new List<IThing> { this.basicInformation, this.personalInformation });

                await this.NavigationService.NavigateBackAsync();
            }
            finally
            {
                this.IsBusy = false;
            }
        }
    }
}