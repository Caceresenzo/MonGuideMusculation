/// Example of a line chart with null measure values.
///
/// Null values will be visible as gaps in lines and area skirts. Any data
/// points that exist between two nulls in a line will be rendered as an
/// isolated point, as seen in the green series.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

class ChartsText extends StatelessWidget {
  Widget _buildGraph(BuildContext context, SportProgramEvolutionType evolutionType) {
    return Card(
      elevation: 0.0,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 2.0,
              ),
              child: Text(
                Texts.evolutionTypeTranslations[evolutionType],
                style: Theme.of(context).textTheme.title,
              ),
            ),
            CommonDivider(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: TimeSeriesRangeAnnotationChart.withSampleData(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: SportProgramEvolutionType.values.length,
      itemBuilder: (context, position) {
        return _buildGraph(context, SportProgramEvolutionType.values[position]);
      },
    );
  }
}

class SimpleNullsLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleNullsLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleNullsLineChart.withSampleData() {
    return new SimpleNullsLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          desiredMaxTickCount: 20,
        ),
      ),
      defaultInteractions: false,
      behaviors: [
        charts.PanAndZoomBehavior(),
      ],
      /*behaviors: [
        new charts.SeriesLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.inside,
          // For a legend that is positioned on the left or right of the chart,
          // setting the justification for [endDrawArea] is aligned to the
          // bottom of the chart draw area.
          insideJustification: charts.InsideJustification.topEnd,
          outsideJustification: charts.OutsideJustification.endDrawArea,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // By setting this value to 2, the legend entries will grow up to two
          // rows before adding a new column.
          desiredMaxRows: 3,
          showMeasures: true,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, top: 4.0),
          // Render the legend entry text with custom styles.
          entryTextStyle: charts.TextStyleSpec(color: charts.MaterialPalette.purple.shadeDefault, fontFamily: 'Georgia', fontSize: 11),
        ),
      ],*/
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, String>> _createSampleData() {
    int i = 0;

    final myFakeDesktopData = [
      new LinearSales(i++, 5),
      new LinearSales(i++, 15),
      new LinearSales(i++, null),
      new LinearSales(i++, 75),
      new LinearSales(i++, 100),
      new LinearSales(i++, 90),
      new LinearSales(i++, 75),
      new LinearSales(i++, 75),
    ];

    return [
      new charts.Series<LinearSales, String>(
        id: 'Desktop',
        // colorFn: (_, __) => charts.Color.fromHex(code: "727272"),
        // colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
        colorFn: (_, __) => charts.Color(r: 0x00, g: 0xE6, b: 0x76),
        domainFn: (LinearSales sales, _) => sales.year.toString(),
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myFakeDesktopData,
      ),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

class a extends DateTimeTickFormatterSpec {
  @override
  charts.TickFormatter<DateTime> createTickFormatter(charts.ChartContext context) {
    // TODO: implement createTickFormatter
    return null;
  }
}

class TimeSeriesRangeAnnotationChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesRangeAnnotationChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesRangeAnnotationChart.withSampleData() {
    return new TimeSeriesRangeAnnotationChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: new charts.NumericAxisSpec(
        tickProviderSpec: new charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          desiredMaxTickCount: 20,
        ),
        tickFormatterSpec: charts.BasicNumericTickFormatterSpec((num year) {
          return year.toString();
        }),
      ),
      behaviors: [
        charts.PanAndZoomBehavior(
          panningCompletedCallback: () {
            print("->");
          }
        ),
        new charts.RangeAnnotation(
          [
            new charts.RangeAnnotationSegment(
              new DateTime(2017, 10, 4),
              new DateTime(2017, 10, 5),
              charts.RangeAnnotationAxisType.domain,
            ),
          ],
        ),
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final List<TimeSeriesSales> data = [];

    for (int i = 0; i < 52; i++) {
      print("${(i * 7 ~/ 30)  + 1} // ${((i * 7) % 30) + 1}");

      data.add(new TimeSeriesSales(new DateTime(2017, i * 7 ~/ 30, (i * 7) % 30), i));
    }

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
