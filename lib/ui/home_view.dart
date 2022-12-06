import 'package:flutter/material.dart';
import 'package:lin_reg_proj/ui/dataset_view.dart';
import 'package:lin_reg_proj/ui/student_data_view.dart';

import 'prediction_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EEE 415 - Group 4 project"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataSetView()),
            ),
            child: const Center(
              child: Text("View Entire DataSet"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentDataView(is10thStudent: true),
              ),
            ),
            child: const Center(
              child: Text("View 10th Student's Data"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const StudentDataView(is10thStudent: false),
              ),
            ),
            child: const Center(
              child: Text("View 20th Student's Data"),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PredictionView()),
            ),
            child: const Center(
              child: Text("Predict Data"),
            ),
          ),
        ],
      ),
    );
  }
}
