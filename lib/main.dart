import 'package:flutter/material.dart';

void main() {
  runApp(const TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  const TipCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tip Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TipCalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TipCalculatorPage extends StatefulWidget {
  const TipCalculatorPage({super.key});

  @override
  State<TipCalculatorPage> createState() => _TipCalculatorPageState();
}

class _TipCalculatorPageState extends State<TipCalculatorPage> {
  double billAmount = 0.0;
  double tipPercent = 10;
  int people = 1;

  final billController = TextEditingController();
  final customTipController = TextEditingController();

  @override
  void dispose() {
    billController.dispose();
    customTipController.dispose();
    super.dispose();
  }

  double get tipAmount => billAmount * (tipPercent / 100);
  double get totalAmount => billAmount + tipAmount;
  double get totalPerPerson => totalAmount / people;
  double get tipPerPerson => tipAmount / people;

  void updateBill(String value) {
    setState(() {
      billAmount = double.tryParse(value) ?? 0;
    });
  }

  void applyTip(double percent) {
    setState(() {
      tipPercent = percent;
      customTipController.clear();
    });
  }

  void applyCustomTip(String value) {
    setState(() {
      tipPercent = double.tryParse(value) ?? tipPercent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tip Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bill input
              const Text(
                "Bill Amount",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: billController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter bill amount",
                ),
                onChanged: updateBill,
              ),

              const SizedBox(height: 25),

              // Tip selection
              const Text(
                "Tip Percentage",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  for (final p in [5, 10, 15, 20])
                    ChoiceChip(
                      label: Text("$p%"),
                      selected: tipPercent == p,
                      onSelected: (_) => applyTip(p.toDouble()),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Custom tip
              TextField(
                controller: customTipController,
                keyboardType: const TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Custom Tip (%)",
                ),
                onChanged: applyCustomTip,
              ),

              const SizedBox(height: 25),

              // Split between people
              const Text(
                "Split",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: people > 1
                        ? () => setState(() => people--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text("$people person${people > 1 ? "s" : ""}",
                      style: const TextStyle(fontSize: 16)),
                  IconButton(
                    onPressed: () => setState(() => people++),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Results
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    resultRow("Tip:", "€${tipAmount.toStringAsFixed(2)}"),
                    resultRow("Total:", "€${totalAmount.toStringAsFixed(2)}"),
                    const SizedBox(height: 10),
                    resultRow("Tip / Person:", "€${tipPerPerson.toStringAsFixed(2)}"),
                    resultRow("Total / Person:", "€${totalPerPerson.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
