import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:ml_algo/ml_algo.dart';
import 'package:ml_dataframe/ml_dataframe.dart';

import '../ui/scatter_plot.dart';

class CsvUtils {
  CsvUtils._();
  static CsvUtils instance = CsvUtils._();

  List<List<dynamic>> dataset = [];
  List<List<dynamic>> csv = [];
  List<List<dynamic>> cleanCsv = [];

  List courses = [];
  List grades = [];
  List<int> units = [];
  List semester = [];
  List points = [];
  List pointsXUnits = [];

  //
  List unitsPerSem = [];
  List pxuPerSem = [];
  List gpas = [];
  List cgpas = [];

  Future<void> fetchCsv(BuildContext context) async {
    var result = await DefaultAssetBundle.of(context).loadString(
      "assets/EEE 415 Database - sheet1.csv",
    );
    dataset = const CsvToListConverter().convert(result, eol: "\n");
    courses = dataset[0];
    grades = dataset[10];

    csv = [courses, grades];
  }

  List<List<dynamic>> cleanUpDataSet(List<List<dynamic>> data) {
    for (int i = 0; i < data[0].length; i++) {
      if (data[1][i].toString().isEmpty) {
        data[0].removeAt(i);
        data[1].removeAt(i);
      }
    }
    for (int i = 0; i < data[1].length; i++) {
      if (data[1][i] is! int || int.tryParse((data[1][i]).toString()) == null) {
        data[0].removeAt(i);
        data[1].removeAt(i);
      }
    }

    data[0].removeLast();
    data[1].removeLast();

    return data;
  }

  List<List<dynamic>> cleanUpData(List<List<dynamic>> data) {
    for (int i = 0; i < data[1].length; i++) {
      if (int.tryParse((data[1][i]).toString()) == null) {
        data[0].removeAt(i);
        data[1].removeAt(i);
      }
    }
    for (int i = 0; i < data[1].length; i++) {
      if (data[1][i] is! int || int.tryParse((data[1][i]).toString()) == null) {
        data[0].removeAt(i);
        data[1].removeAt(i);
      }
    }

    data[0].removeLast();
    data[1].removeLast();

    return data;
  }

  List<List<dynamic>> removeUnwantedCourses(
      List<List<dynamic>> data, bool is10th) {
    final index10 = [23, 35, 36, 46, 55, 64].reversed.toList();
    final index20 = [19, 20, 22, 31, 32, 40, 49, 54].reversed.toList();
    final courses = is10th ? index10 : index20;
    for (int i = 0; i < courses.length; i++) {
      data[0].removeAt(courses[i]);
      data[1].removeAt(courses[i]);
    }
    return data;
  }

  List<int> getCourseUnits(List courses) {
    final units = courses.map(
      (e) {
        if (!e.toString().contains("(")) {
          return e;
        }
        final val = e.toString().substring(
              e.toString().indexOf("(") + 1,
              e.toString().indexOf(")"),
            );
        return val;
      },
    ).toList();
    return units.map((e) => int.parse(e.toString())).toList();
  }

  List<int> getSemesters(bool is10th) {
    if (is10th) {
      return [
        for (int i = 0; i < 11; i++) 1,
        for (int i = 0; i < 11; i++) 2,
        for (int i = 0; i < 11; i++) 3,
        for (int i = 0; i < 9; i++) 4,
        for (int i = 0; i < 9; i++) 5,
        for (int i = 0; i < 10; i++) 6,
      ].toList();
    } else {
      return [
        for (int i = 0; i < 10; i++) 1,
        for (int i = 0; i < 9; i++) 2,
        for (int i = 0; i < 8; i++) 3,
        for (int i = 0; i < 7; i++) 4,
        for (int i = 0; i < 9; i++) 5,
        for (int i = 0; i < 6; i++) 6,
      ].take(59).toList();
    }
  }

  List<int> getPoints(List grades) {
    return [
      for (var i in grades)
        if (i is String)
          0
        else if (i < 45)
          0
        else if (i >= 45 && i < 50)
          2
        else if (i >= 50 && i < 60)
          3
        else if (i >= 60 && i < 70)
          4
        else if (i >= 70)
          5,
    ];
  }

  void processCsv(bool is10th) {
    final tempData = removeUnwantedCourses(
      cleanUpData(is10th ? data10 : data20),
      is10th,
    );

    // Set courses and grades to the list
    courses = tempData[0];
    grades = tempData[1];

    // Get the units from the courses
    units = getCourseUnits(courses);

    // Get the semester
    semester = getSemesters(is10th);

    // Get the points
    points = getPoints(grades);

    // Calculate gpa

    // 1. Get Points x units
    pointsXUnits.clear();
    for (int i = 0; i < units.length; i++) {
      pointsXUnits.add(units[i] * points[i]);
    }

    // 2. Loop through, create a new table and get the total units, total pxu and semester
    unitsPerSem.clear();
    pxuPerSem.clear();
    for (int i = 1; i < 7; i++) {
      num sumOfUnits = 0;
      num sumOfPXUs = 0;
      for (int u = 0; u < units.length; u++) {
        if (semester[u] == i) {
          // print(courses[u]);
          sumOfUnits = sumOfUnits + units[u];
          sumOfPXUs = sumOfPXUs + pointsXUnits[u];
        }
      }
      unitsPerSem.add(sumOfUnits);
      pxuPerSem.add(sumOfPXUs);
    }

    // 3. Get the gpa for each semester
    gpas.clear();
    for (int i = 0; i < unitsPerSem.length; i++) {
      gpas.add(pxuPerSem[i] / unitsPerSem[i]);
    }

    // Calculate CGPA
    cgpas.clear();
    for (int i = 0; i < gpas.length; i++) {
      if (i == 0) {
        cgpas.add(gpas[0]);
      } else {
        cgpas.add(
          (gpas.take(i + 1).fold(0.0, (p, c) => (p) + (c as double))) / (i + 1),
        );
      }
    }

    // Compile Result
    csv = [
      // ["Index", ...courses.map((e) => courses.indexOf(e)).toList()],
      ["Courses", ...courses],
      ["Grades", ...grades],
      ["Units", ...units],
      ["Semester", ...semester],
      ["Points", ...points],
      ["Points X Units", ...pointsXUnits]
    ];
  }

  double predictCGPA(bool is10th, int semester) {
    processCsv(is10th);

    if (semester < 6) {
      return cgpas[semester];
    }
    final tempCGPA = [...cgpas];

    for (int i = 0; i < semester - cgpas.length + 1; i++) {
      List cols = ["Semester", "CGPA"];
      List<List> data = [
        cols,
        for (int i = 0; i < tempCGPA.length; i++) [i, tempCGPA[i]],
      ];

      //
      final model = LinearRegressor(
        DataFrame(data, headerExists: true),
        cols.last,
      );

      //
      final dataframe = model.predict(
        DataFrame(
          [
            [...cols]..removeAt(0),
            [0],
            [tempCGPA.last],
          ],
          headerExists: true,
        ),
      );

      final stringRes = dataframe.rows.first.first.toString();

      tempCGPA.add(double.parse(stringRes));
    }
    // print("object");
    // print(tempCGPA);
    return tempCGPA.last;
  }

  Future<void> getLinRegModel() async {
    List cols = [
      "Units per Semester",
      "Points_x_units per semester",
      "GPA",
      "CGPA"
    ];
    List<List> data = [
      cols,
      for (int i = 0; i < cgpas.length; i++)
        [
          unitsPerSem[i],
          pxuPerSem[i],
          gpas
              .map((e) => double.parse(e.toString()).toStringAsFixed(2))
              .toList()[i],
          cgpas
              .map((e) => double.parse(e.toString()).toStringAsFixed(2))
              .toList()[i],
        ],
    ];
    cleanCsv = data;

    // miu.DataFrame
    // final model = LinearRegressor(
    //   DataFrame(
    //     data,
    //     headerExists: true,
    //   ),
    //   "CGPA",
    // );
    // Can't work because there is no test data
    // final error = model.assess(
    //   DataFrame(
    //     [
    //       cols,
    //       for (int i = 0; i < 1; i++)
    //         [
    //           unitsPerSem[i],
    //           pxuPerSem[i],
    //           gpas[i],
    //           cgpas[i],
    //         ],
    //     ],
    //     headerExists: true,
    //   ),
    //   MetricType.mape,
    // );
    // print("Error from model: $error");
    // await model.saveAsJson('housing_model.json');
    // print(DataFrame(
    //   [
    //     [...cols]..removeAt(0),
    //     for (int i = 0; i < 1; i++)
    //       [
    //         unitsPerSem[i],
    //         pxuPerSem[i],
    //         gpas[i],
    //         cgpas[i],
    //       ]
    //   ],
    //   headerExists: true,
    // ).toJson());
    // final dataframe = model.predict(
    //   DataFrame(
    //     [
    //       [...cols]..removeAt(0),
    //       for (int i = 0; i < 1; i++)
    //         [
    //           unitsPerSem[i],
    //           pxuPerSem[i],
    //           gpas[i],
    //           cgpas[i],
    //         ]
    //     ],
    //     headerExists: true,
    //     // header: cols.map((e) => e.toString()),
    //     // columnNames: cols.map((e) => e.toString()),
    //   ),
    // );
    // print(dataframe.header);
    // print(dataframe.rows);
  }

  List<List<dynamic>> get data10 => cleanUpData([dataset[0], dataset[10]]);
  List<List<dynamic>> get data20 => cleanUpData([dataset[0], dataset[20]]);
  List<CourseGPAs> get cgpasplot => [
        for (int i = 0; i < cgpas.length; i++) CourseGPAs(i + 1, cgpas[i]),
      ];
}
