/// Example of a combo scatter plot chart with a second series rendered as a
/// line.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ScatterPlotComboLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  const ScatterPlotComboLineChart(
    this.seriesList, {
    this.animate = true,
    super.key,
  });

  /// Creates a [ScatterPlotChart] with sample data and no transition.
  factory ScatterPlotComboLineChart.withSampleData() {
    return ScatterPlotComboLineChart(
      _createSampleData(),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.ScatterPlotChart(
      seriesList,
      animate: animate,
      defaultRenderer: charts.PointRendererConfig(),
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 1),
        viewport: charts.NumericExtents(0, 5),
      ),
      customSeriesRenderers: [
        charts.LineRendererConfig(
          customRendererId: 'customLine',
          layoutPaintOrder: charts.LayoutViewPaintOrder.point + 1,
        )
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final desktopSalesData = [
      LinearSales(0, 5, 3.0),
      LinearSales(10, 25, 5.0),
      LinearSales(12, 75, 4.0),
      LinearSales(13, 225, 5.0),
      LinearSales(16, 50, 4.0),
      LinearSales(24, 75, 3.0),
      LinearSales(25, 100, 3.0),
      LinearSales(34, 150, 5.0),
      LinearSales(37, 10, 4.5),
      LinearSales(45, 300, 8.0),
      LinearSales(52, 15, 4.0),
      LinearSales(56, 200, 7.0),
    ];

    var myRegressionData = [
      LinearSales(0, 5, 3.5),
      LinearSales(56, 240, 3.5),
    ];

    const maxMeasure = 300;

    return [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        // Providing a color function is optional.
        colorFn: (LinearSales sales, _) {
          // Bucket the measure column value into 3 distinct colors.
          final bucket = sales.sales / maxMeasure;

          if (bucket < 1 / 3) {
            return charts.MaterialPalette.blue.shadeDefault;
          } else if (bucket < 2 / 3) {
            return charts.MaterialPalette.red.shadeDefault;
          } else {
            return charts.MaterialPalette.green.shadeDefault;
          }
        },
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        // Providing a radius function is optional.
        radiusPxFn: (LinearSales sales, _) => sales.radius,
        data: desktopSalesData,
      ),
      charts.Series<LinearSales, int>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: myRegressionData,
      )
        // Configure our custom line renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;
  final double radius;

  LinearSales(this.year, this.sales, this.radius);
}

class CourseGPAs {
  final int semester;
  final double cgpa;
  final double radius = 10;

  CourseGPAs(this.semester, this.cgpa);
}
