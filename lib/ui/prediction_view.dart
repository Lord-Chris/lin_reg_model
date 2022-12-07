import 'package:flutter/material.dart';
import 'package:lin_reg_proj/utils/csv_utils.dart';

class PredictionView extends StatefulWidget {
  const PredictionView({super.key});

  @override
  State<PredictionView> createState() => _PredictionViewState();
}

class _PredictionViewState extends State<PredictionView> {
  final csv = CsvUtils.instance;
  int? semester;
  bool? is10thStudent;
  double? result;

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
        title: const Text("Prediction Based on Model"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Select Semester: ",
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: DropdownButtonFormField(
                    items: [
                      for (int i = 0; i < 10; i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text((i + 1).toString()),
                        )
                    ],
                    onChanged: (int ?value) {
                      semester = value;
                    },
                    value: semester,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Select Student Model: ",
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: DropdownButtonFormField(
                    items: const [
                      DropdownMenuItem(
                        value: true,
                        child: Text("10th Student Model"),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text("20th Student Model"),
                      )
                    ],
                    onChanged: (bool? value) {
                      is10thStudent = value ?? false;
                    },
                    value: is10thStudent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () async {
                if (semester == null || is10thStudent == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fill In All Data")),
                  );
                  return;
                }
                await csv.fetchCsv(context);
                result = csv.predictCGPA(is10thStudent!, semester!);
                setState(() {});
              },
              child: const Center(
                child: Text("Predict Data"),
              ),
            ),
            const SizedBox(height: 40),
            result != null
                ? Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "The CGPA will be: \n"),
                          TextSpan(
                            text: result?.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
