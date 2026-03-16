import 'package:flutter/material.dart';
import '../widgets/table_component.dart';

class SharedScreen extends StatelessWidget {
  const SharedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final headers = ["Item", "Qty", "Price"];
    final rows = [
      ["Sugar", "2", "150.00"],
      ["Rice", "1", "230.00"],
      ["Tea", "3", "120.00"],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Shared Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:  AppTable(
          headers: headers,
          rows: rows,
          columnWidths: const [160, 80, 120],
          rowHeight: 52,
          headerColor: Colors.blueGrey,
          bodyColor: Colors.white,
          zebra: true,
          zebraColor: const Color(0xFFF6F7FB),
          headerTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
