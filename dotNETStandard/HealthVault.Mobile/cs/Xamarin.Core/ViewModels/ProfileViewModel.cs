using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using HealthVault.Sample.Xamarin.Core.Models;
using HealthVault.Sample.Xamarin.Core.Services;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ProfileViewModel : ViewModel
    {
        private readonly IHealthVaultConnection connection;

        private BasicV2 basicInformation;
        private Personal personalInformation;
        private IThingClient thingClient;
        private Guid recordId;

        public ProfileViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            this.connection = connection;

            this.SaveCommand = new Command(async () => await this.SaveProfileAsync());

            this.Genders = new List<string>
                {
                    StringResource.Gender_Male,
                    StringResource.Gender_Female,
                };

            this.LoadState = LoadState.Loading;
        }

        public ICommand SaveCommand { get; }

        private ImageSource imageSource;

        public ImageSource ImageSource
        {
            get { return this.imageSource; }

            set
            {
                this.imageSource = value;
                this.OnPropertyChanged();
            }
        }

        private string firstName;

        public string FirstName
        {
            get { return this.firstName; }

            set
            {
                this.firstName = value;
                this.OnPropertyChanged();
            }
        }

        private string lastName;

        public string LastName
        {
            get { return this.lastName; }

            set
            {
                this.lastName = value;
                this.OnPropertyChanged();
            }
        }

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

        public override async Task OnNavigateToAsync()
        {
            await this.LoadAsync(async () =>
            {
                var person = await this.connection.GetPersonInfoAsync();
                thingClient = this.connection.CreateThingClient();
                HealthRecordInfo record = person.SelectedRecord;
                recordId = record.Id;
                this.basicInformation = (await thingClient.GetThingsAsync<BasicV2>(recordId)).FirstOrDefault();
                this.personalInformation = (await thingClient.GetThingsAsync<Personal>(recordId)).FirstOrDefault();

                ImageSource profileImageSource = await this.GetImageAsync();

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

                this.GenderIndex = basicInformation.Gender != null && basicInformation.Gender.Value == Gender.Female ? 1 : 0;
                this.ImageSource = profileImageSource;

                await base.OnNavigateToAsync();
            });
        }

        private async Task<ImageSource> GetImageAsync()
        {
            var query = new ThingQuery(PersonalImage.TypeId)
            {
                View = { Sections = ThingSections.Xml | ThingSections.BlobPayload | ThingSections.Signature }
            };

            var things = await thingClient.GetThingsAsync(recordId, query);
            IThing firstThing = things?.FirstOrDefault();
            if (firstThing == null)
            {
                return null;
            }
            PersonalImage image = (PersonalImage)firstThing;
            return ImageSource.FromStream(() => image.ReadImage());
        }

        private async Task SaveProfileAsync()
        {
            this.LoadState = LoadState.Loading;

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
            catch (Exception exception)
            {
                await this.DisplayAlertAsync(StringResource.ErrorDialogTitle, exception.ToString());
            }
            finally
            {
                this.LoadState = LoadState.Loaded;
            }
        }
    }
}