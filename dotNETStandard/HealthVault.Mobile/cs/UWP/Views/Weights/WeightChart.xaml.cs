using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using LiveCharts;
using LiveCharts.Configurations;
using LiveCharts.Uwp;
using Microsoft.HealthVault.ItemTypes;
using Windows.ApplicationModel.Resources;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Media;

// The User Control item template is documented at https://go.microsoft.com/fwlink/?LinkId=234236

namespace HealthVaultMobileSample.UWP.Views.Weights
{
    public sealed partial class WeightChart : UserControl, INotifyPropertyChanged
    {
        public SeriesCollection SeriesCollection { get; set; }
        public string[] Labels { get; set; }
        public Func<double, string> YFormatter { get; set; }
        public Func<double, string> XFormatter { get; set; }
        public IReadOnlyCollection<Weight> Weights
        {
            get { return (IReadOnlyCollection<Weight>)GetValue(WeightsProperty); }
            set { SetValue(WeightsProperty, value); }
        }

        // Using a DependencyProperty as the backing store for Weights.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty WeightsProperty =
            DependencyProperty.Register("Weights", typeof(IReadOnlyCollection<Weight>), typeof(WeightChart), new PropertyMetadata(null, OnWeightPropertyChanged));

        private static void OnWeightPropertyChanged(DependencyObject sender, DependencyPropertyChangedEventArgs e)
        {
            ((WeightChart)sender).InitializeChart();
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        /// <summary>
        /// Updates the Chart control using the latest data available.
        /// </summary>
        private void InitializeChart()
        {
            if (Weights != null)
            {
                //Configure groups
                Labels = new string[Weights.Count];
                List<double> values = new List<double>();

                //Sort weight by date
                var weightsSorted = from weight in Weights
                                    orderby weight.EffectiveDate
                                    select weight;

                //Get a weight converter to get the right units for culture
                var converter = new Converters.WeightConverter();

                //Add a custom type mapping for the Weight class so the charting library knows how to draw it
                var weightConfiguration = Mappers.Xy<Weight>()
                   .X(dayModel => (double)dayModel.EffectiveDate.Value.ToDateTimeUnspecified().Ticks / TimeSpan.FromHours(1).Ticks)
                   .Y(dayModel => (double)converter.Convert(dayModel.Value.Kilograms, typeof(double), null, null));

                //Create the Series and add data
                SeriesCollection = new SeriesCollection(weightConfiguration)
                {
                    new LineSeries
                    {
                        Title = new ResourceLoader().GetString("WeightTitle"),
                        Values = new ChartValues<Weight>(weightsSorted),
                        PointGeometry = DefaultGeometries.Circle,
                        LineSmoothness = .7,
                        PointGeometrySize = 15,
                        Foreground = Resources["HighlightColor"] as SolidColorBrush,
                        Fill = (Resources["HighlightColorLight"] as SolidColorBrush),
                        Stroke = Resources["HighlightColor"] as SolidColorBrush
                    }
                };

                //Configure axis formatters
                YFormatter = value => value.ToString() + Helpers.WeightHelper.GetUnitDisplayString();
                XFormatter = value => new System.DateTime((long)(value * TimeSpan.FromHours(1).Ticks)).ToString("d");

                //Send PropertyChanged events to update UX, then show chart in UX
                OnPropertyChanged("YFormatter");
                OnPropertyChanged("XFormatter");
                OnPropertyChanged("SeriesCollection");
                OnPropertyChanged("Labels");

                ShowChart();
            }
        }

        /// <summary>
        /// Sets visibility on the Progress and Chart controls.
        /// </summary>
        private void ShowChart()
        {
            Progress.Visibility = Visibility.Collapsed;
            Chart.Visibility = Visibility.Visible;
        }

        public WeightChart()
        {
            InitializeComponent();
        }
    }
}
