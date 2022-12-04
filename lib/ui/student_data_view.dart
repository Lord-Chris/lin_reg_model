import 'package:flutter/material.dart';
import 'package:lin_reg_proj/graph_page.dart';
import 'package:lin_reg_proj/utils/csv_utils.dart';

class StudentDataView extends StatefulWidget {
  final bool is10thStudent;
  const StudentDataView({super.key, required this.is10thStudent});

  @override
  State<StudentDataView> createState() => _StudentDataViewState();
}

class _StudentDataViewState extends State<StudentDataView> {
  final csv = CsvUtils.instance;

  @override
  void initState() {
    super.initState();
    csv.fetchCsv(context).then((value) async {
      csv.processCsv(widget.is10thStudent);
      csv.getLinRegModel();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.is10thStudent ? "10th" : "20th"} Student's Data"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GraphPage(csv: csv.cgpasplot),
                ),
              );
            },
            icon: const Icon(Icons.next_plan),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: csv.csv.isEmpty
              ? const CircularProgressIndicator()
              : DataTable(
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
                    ...csv.csv[0].map(
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
                  rows: csv.csv
                      .skip(1)
                      .map(
                        (csvrow) => DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Text(
                                  csv.csv.indexOf(csvrow).toString(),
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
  }
}
