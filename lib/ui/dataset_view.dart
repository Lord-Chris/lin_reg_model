import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lin_reg_proj/utils/csv_utils.dart';

class DataSetView extends StatefulWidget {
  const DataSetView({super.key});

  @override
  State<DataSetView> createState() => _DataSetViewState();
}

class _DataSetViewState extends State<DataSetView> {
  final csv = CsvUtils.instance;

  @override
  void initState() {
    super.initState();
    csv.fetchCsv(context).then((value) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entire Dataset"),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (_) => GraphPage(csv: csv.cgpasplot),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.next_plan),
        //   )
        // ],
      ),
      body: Builder(builder: (context) {
        if (csv.dataset.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          controller: ScrollController(),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(
                    label: Flexible(
                      child: Center(
                        child: Text(
                          "S/N",
                        ),
                      ),
                    ),
                  ),
                  ...csv.dataset[0].map(
                    (item) => DataColumn(
                      label: Flexible(
                        child: Center(
                          child: Text(
                            item.toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                rows: csv.dataset
                    .skip(1)
                    .map(
                      (csvrow) => DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: Text(
                                csv.dataset.indexOf(csvrow).toString(),
                              ),
                            ),
                          ),
                          ...csvrow.map(
                            (csvItem) => DataCell(
                              Center(
                                child: Text(
                                  csvItem.toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}
