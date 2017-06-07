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
using NodaTime.Extensions;
using Xamarin.Forms;

namespace HealthVault.Sample.Xamarin.Core.ViewModels
{
    public class ProfileViewModel : ViewModel
    {
        private readonly IHealthVaultConnection _connection;

        private BasicV2 _basicInformation;
        private Personal _personalInformation;
        private IThingClient _thingClient;
        private Guid _recordId;

        public ProfileViewModel(
            IHealthVaultConnection connection,
            INavigationService navigationService) : base(navigationService)
        {
            _connection = connection;

            SaveCommand = new Command(async () => await SaveProfileAsync());

            Genders = new List<string>
                {
                    StringResource.Gender_Male,
                    StringResource.Gender_Female,
                };

            LoadState = LoadState.Loading;
        }

        public ICommand SaveCommand { get; }

        private ImageSource _imageSource;

        public ImageSource ImageSource
        {
            get { return _imageSource; }

            set
            {
                _imageSource = value;
                OnPropertyChanged();
            }
        }

        private string _firstName;

        public string FirstName
        {
            get { return _firstName; }

            set
            {
                _firstName = value;
                OnPropertyChanged();
            }
        }

        private string _lastName;

        public string LastName
        {
            get { return _lastName; }

            set
            {
                _lastName = value;
                OnPropertyChanged();
            }
        }

        private DateTime _birthDate;

        public DateTime BirthDate
        {
            get { return _birthDate; }

            set
            {
                _birthDate = value;
                OnPropertyChanged();
            }
        }

        public List<string> Genders { get; }

        private int _genderIndex;

        public int GenderIndex
        {
            get { return _genderIndex; }

            set
            {
                _genderIndex = value;
                OnPropertyChanged();
            }
        }

        public override async Task OnNavigateToAsync()
        {
            await LoadAsync(async () =>
            {
                var person = await _connection.GetPersonInfoAsync();
                _thingClient = _connection.CreateThingClient();
                HealthRecordInfo record = person.SelectedRecord;
                _recordId = record.Id;
                _basicInformation = (await _thingClient.GetThingsAsync<BasicV2>(_recordId)).FirstOrDefault();
                _personalInformation = (await _thingClient.GetThingsAsync<Personal>(_recordId)).FirstOrDefault();

                ImageSource profileImageSource = await GetImageAsync();

                if (_personalInformation.BirthDate != null)
                {
                    BirthDate = _personalInformation.BirthDate.ToLocalDateTime().ToDateTimeUnspecified();
                }
                else
                {
                    BirthDate = DateTime.Now;
                }

                FirstName = _personalInformation.Name?.First ?? string.Empty;
                LastName = _personalInformation.Name?.Last ?? string.Empty;

                GenderIndex = _basicInformation.Gender != null && _basicInformation.Gender.Value == Gender.Female ? 1 : 0;
                ImageSource = profileImageSource;

                await base.OnNavigateToAsync();
            });
        }

        private async Task<ImageSource> GetImageAsync()
        {
            var query = new ThingQuery(PersonalImage.TypeId)
            {
                View = { Sections = ThingSections.Xml | ThingSections.BlobPayload | ThingSections.Signature }
            };

            var things = await _thingClient.GetThingsAsync(_recordId, query);
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
            LoadState = LoadState.Loading;

            try
            {
                // Name property could be null. Construct it if we need to.
                if (_personalInformation.Name == null && (!string.IsNullOrEmpty(FirstName) || !string.IsNullOrEmpty(LastName)))
                {
                    _personalInformation.Name = new Name();
                }

                if (_personalInformation.Name != null)
                {
                    // Only set first and last name if we have it
                    if (!string.IsNullOrEmpty(FirstName))
                    {
                        _personalInformation.Name.First = FirstName;
                    }

                    if (!string.IsNullOrEmpty(LastName))
                    {
                        _personalInformation.Name.Last = LastName;
                    }
                }

                _basicInformation.BirthYear = BirthDate.Year;
                _basicInformation.Gender = GenderIndex == 0 ? Gender.Male : Gender.Female;

                _personalInformation.BirthDate = new HealthServiceDateTime(BirthDate.ToLocalDateTime());

                await _thingClient.UpdateThingsAsync(_recordId, new List<IThing> { _basicInformation, _personalInformation });

                await NavigationService.NavigateBackAsync();
            }
            catch (Exception exception)
            {
                await DisplayAlertAsync(StringResource.ErrorDialogTitle, exception.ToString());
            }
            finally
            {
                LoadState = LoadState.Loaded;
            }
        }
    }
}