import 'package:charts_flutter_new/flutter.dart';
import 'package:flutter/material.dart';
import 'package:lin_reg_proj/ui/scatter_plot.dart';

class GraphPage extends StatelessWidget {
  final List<CourseGPAs> csv;
  const GraphPage({super.key, required this.csv});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Graph Page"),
      ),
      body: ScatterPlotComboLineChart(
        [
          Series<CourseGPAs, int>(
            id: 'CGPAs plot',
            // Providing a color function is optional.
            colorFn: (CourseGPAs cgpa, _) {
              return MaterialPalette.green.shadeDefault;
            },
            domainFn: (CourseGPAs cgpa, _) => cgpa.semester,
            measureFn: (CourseGPAs cgpa, _) => cgpa.cgpa,
            // Providing a radius function is optional.
            radiusPxFn: (CourseGPAs cgpa, _) => cgpa.radius,
            data: csv,
          ),
          Series<CourseGPAs, int>(
            id: 'Reg Line',
            colorFn: (_, __) => MaterialPalette.purple.shadeDefault,
            domainFn: (CourseGPAs cgpa, _) => cgpa.semester,
            measureFn: (CourseGPAs cgpa, _) => cgpa.cgpa,
            data: [csv.first, csv.last],
          )..setAttribute(rendererIdKey, 'customLine'),
        ],
      ),
    );
  }
}
