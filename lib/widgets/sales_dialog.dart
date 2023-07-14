import 'package:flutter/material.dart';
import 'package:pixelone/components/c_elevated_button.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog(this.totalAmount, {super.key});
  final double totalAmount;

  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  int selectedAmount = 0;

  @override
  Widget build(BuildContext context) {
    double remainingBalance = widget.totalAmount - selectedAmount;
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FINALIZE SALE',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Field 1',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: selectedAmount.toString(),
                          ),
                          onSubmitted: (value) {
                            selectedAmount = value as int;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Field 3',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Total Items',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                'Total Payable ${widget.totalAmount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total Paying $selectedAmount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                'Due Amount $remainingBalance',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 10;
                            });
                          },
                          child: const Text('10'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 20;
                            });
                          },
                          child: const Text('20'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 50;
                            });
                          },
                          child: const Text('50'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 100;
                            });
                          },
                          child: const Text('100'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 500;
                            });
                          },
                          child: const Text('500'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 1000;
                            });
                          },
                          child: const Text('1000'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 5000;
                            });
                          },
                          child: const Text('5000'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount = 0;
                            });
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CElevatedButton(
                    onPressed: () {
                      // Handle dialog actions or dismiss the dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8.0),
                  CElevatedButton(
                    onPressed: () {
                      // Perform necessary actions based on field values
                      // and dismiss the dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
