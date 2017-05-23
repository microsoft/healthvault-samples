using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using HealthVaultMobileSample.UWP.Helpers;
using Microsoft.HealthVault.Clients;
using Microsoft.HealthVault.Connection;
using Microsoft.HealthVault.ItemTypes;
using Microsoft.HealthVault.Record;
using Microsoft.HealthVault.Thing;
using Windows.UI.Xaml.Controls;

// The Blank Page item template is documented at https://go.microsoft.com/fwlink/?LinkId=234238

namespace HealthVaultMobileSample.UWP.Views.Profile
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    ///
    /// TODO: Fix Profile image retrieval.
    /// </summary>
    public sealed partial class ProfilePage : HealthVaultBasePage
    {
        private IHealthVaultConnection _connection;
        public string ImageSource { get; private set; }
        public BasicV2 BasicInformation { get; set; }
        public HealthRecordInfo RecordInfo { get; private set; }

        /// <summary>
        /// Retrieves the data model for this page.
        /// </summary>
        /// <returns></returns>
        public override async Task Initialize(NavigationParams navParams)
        {
            //Save the connection so we can make updates later.
            _connection = navParams.Connection;

            HealthRecordInfo recordInfo = (await _connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = _connection.CreateThingClient();

            GetProfileAsync(recordInfo, thingClient);

            GetPersonalImageAsync(recordInfo, thingClient);

            return;
        }

        /// <summary>
        /// Gets the latest BasicV2 object for this user.
        /// </summary>
        /// <param name="recordInfo"></param>
        /// <param name="thingClient"></param>
        /// <returns></returns>
        private async Task GetProfileAsync(HealthRecordInfo recordInfo, IThingClient thingClient)
        {
            BasicInformation = (await thingClient.GetThingsAsync<BasicV2>(recordInfo.Id)).FirstOrDefault<BasicV2>();

            RecordInfo = recordInfo;

            //Binding against an enum from XAML isn't straightforward, so use this workaround instead.
            Gender.ItemsSource = System.Enum.GetValues(typeof(Gender));

            OnPropertyChanged("RecordInfo");
            OnPropertyChanged("BasicInformation");
        }

        /// <summary>
        /// Gets the user's PersonalImage Things and then calls GetAndSavePersonalImage to extract the blob,
        /// save to disk, then adds that path to the ImageSource property so the UX can find it.
        /// </summary>
        /// <param name="recordInfo"></param>
        /// <param name="thingClient"></param>
        /// <returns></returns>
        private async Task GetPersonalImageAsync(HealthRecordInfo recordInfo, IThingClient thingClient)
        {
            //Build query
            var query = new ThingQuery(new Guid[] { PersonalImage.TypeId });
            query.View.Sections = ThingSections.Xml | ThingSections.BlobPayload | ThingSections.Signature;

            var things = await thingClient.GetThingsAsync(recordInfo.Id, query);

            if (things.Count > 0)
            {
                Windows.Storage.StorageFile file = await GetAndSavePersonalImage(recordInfo, things);
                ImageSource = file.Path;
                OnPropertyChanged("ImageSource");
            }
        }

        /// <summary>
        /// Gets the user's PersonalImage from HealthVault and stores in a local file.
        /// </summary>
        /// <param name="recordInfo"></param>
        /// <param name="things"></param>
        /// <returns></returns>
        private static async Task<Windows.Storage.StorageFile> GetAndSavePersonalImage(HealthRecordInfo recordInfo, ThingCollection things)
        {
            var fileName = recordInfo.DisplayName + ".jpg";
            var file = await Windows.Storage.ApplicationData.Current.LocalCacheFolder.CreateFileAsync(fileName, Windows.Storage.CreationCollisionOption.OpenIfExists);

            if (things.Count > 0)
            {
                var personalImage = (PersonalImage)things.First();

                using (Stream currentImage = personalImage.ReadImage())
                {
                    if (currentImage != null)
                    {
                        byte[] imageBytes = new byte[currentImage.Length];
                        await currentImage.ReadAsync(imageBytes, 0, (int)currentImage.Length);

                        using (var writeStream = await file.OpenStreamForWriteAsync())
                        {
                            await writeStream.WriteAsync(imageBytes, 0, (int)currentImage.Length);
                        }
                    }
                }
            }

            return file;
        }

        /// <summary>
        /// Updates the BasicV2 thing with the content from the BasicInformation property.
        /// </summary>
        private async void UpdateThing()
        {
            HealthRecordInfo recordInfo = (await _connection.GetPersonInfoAsync()).SelectedRecord;
            IThingClient thingClient = _connection.CreateThingClient();

            List<ThingBase> things = new List<ThingBase>();
            things.Add(BasicInformation);

            await thingClient.UpdateThingsAsync(recordInfo.Id, things);
        }

        public ProfilePage()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Calls UpdateThing() to update the BasicV2 object.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TextBox_TextChanged(object sender, TextChangedEventArgs e)
        {
            UpdateThing();
        }

        //TODO
        private void Name_TextChanged(object sender, TextChangedEventArgs e)
        {
        }

        /// <summary>
        /// Calls UpdateThing() to update the BasicV2 object.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateThing();
        }
    }
}
