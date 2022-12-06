import 'package:flutter/material.dart';
import 'package:lin_reg_proj/ui/home_view.dart';

///
///1. Find actual regression line
///2. Remove cpe courses
///3. Build windows app
///4. Increasing cgpa for 20th student.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
// class _MyHomePageState extends State<MyHomePage> {
//   final csv = CsvUtils.instance;
//   @override
//   void initState() {
//     super.initState();
//     csv.fetchCsv(context).then((value) {
//       if (mounted) setState(() {});
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => GraphPage(csv: csv.cgpasplot),
//                 ),
//               );
//             },
//             icon: const Icon(Icons.next_plan),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: csv.csv.isEmpty
//               ? const CircularProgressIndicator()
//               : DataTable(
//                   columns: [
//                     const DataColumn(
//                       label: Flexible(
//                         child: Center(
//                           child: Text(
//                             "S/N",
//                           ),
//                         ),
//                       ),
//                     ),
//                     ...csv.csv[0].map(
//                       (item) => DataColumn(
//                         label: Flexible(
//                           child: Center(
//                             child: Text(
//                               item.toString(),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                   rows: csv.csv
//                       .skip(1)
//                       .map(
//                         (csvrow) => DataRow(
//                           cells: [
//                             DataCell(
//                               Center(
//                                 child: Text(
//                                   csv.csv.indexOf(csvrow).toString(),
//                                 ),
//                               ),
//                             ),
//                             ...csvrow.map(
//                               (csvItem) => DataCell(
//                                 Center(
//                                   child: Text(
//                                     csvItem.toString(),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                 ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           csv.processCsv(true);
//           setState(() {});
//           await Future.delayed(const Duration(seconds: 2));
//           csv.getLinRegModel();
//           setState(() {});
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
