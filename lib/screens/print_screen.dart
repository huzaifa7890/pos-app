// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintScreen extends StatelessWidget {
  const PrintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Screen'),
      ),
      body: Consumer<Cart>(
        builder: (context, cartProvider, _) {
          final cartItems = cartProvider.cartItems;
          final discount = cartProvider.discount;
          final subtotal = cartProvider.calculateSubtotal();
          final total = cartProvider.calculateTotal(subtotal);
          final now = DateTime.now();
          final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');

          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'PixelOne',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Save money. Live Better.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pakistan SGD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Cart Items:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Product',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: cartItems
                        .map(
                          (product) => DataRow(
                            cells: [
                              DataCell(Text(product.name)),
                              DataCell(Text(product.price.toString())),
                              DataCell(Row(
                                children: [
                                  Text(product.quantity.toString()),
                                ],
                              )),
                              DataCell(Text((product.price * product.quantity)
                                  .toString())),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Subtotal:     $subtotal',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Discount:    $discount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Total:           $total',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '# ITEMS SOLD ${cartItems.length.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formatter.format(now),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final pdfFile = await generatePdf(context);
                      if (pdfFile != null) {
                        await Printing.layoutPdf(
                          onLayout: (_) async => pdfFile.readAsBytes(),
                        );
                      }
                    },
                    child: const Text('Print'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<File?> generatePdf(BuildContext context) async {
  final cartProvider = Provider.of<Cart>(context, listen: false);
  final cartItems = cartProvider.cartItems;
  final discount = cartProvider.discount;
  final subtotal = cartProvider.calculateSubtotal();
  final total = cartProvider.calculateTotal(subtotal);
  final now = DateTime.now();
  final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Container(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  'PixelOne',
                  style: pw.TextStyle(
                    fontSize: 54,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Save money. Live Better.',
                  style: const pw.TextStyle(
                    fontSize: 38,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Pakistan SGD',
                  style: const pw.TextStyle(
                    fontSize: 38,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Cart Items:',
                  style: const pw.TextStyle(
                    fontSize: 30,
                  ),
                ),
                pw.Table(
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Text(
                          'Product',
                          style: const pw.TextStyle(
                            fontSize: 28.0,
                          ),
                        ),
                        pw.Text(
                          'Price',
                          style: const pw.TextStyle(
                            fontSize: 28.0,
                          ),
                        ),
                        pw.Text(
                          'Quantity',
                          style: const pw.TextStyle(
                            fontSize: 28.0,
                          ),
                        ),
                        pw.Text(
                          'Subtotal',
                          style: const pw.TextStyle(
                            fontSize: 28.0,
                          ),
                        ),
                      ],
                    ),
                    for (final product in cartItems)
                      pw.TableRow(
                        children: [
                          pw.Text(
                            product.name,
                            style: const pw.TextStyle(
                              fontSize: 28.0,
                            ),
                          ),
                          pw.Text(
                            product.price.toString(),
                            style: const pw.TextStyle(
                              fontSize: 28.0,
                            ),
                          ),
                          pw.Text(
                            product.quantity.toString(),
                            style: const pw.TextStyle(
                              fontSize: 28.0,
                            ),
                          ),
                          pw.Text(
                            (product.price * product.quantity).toString(),
                            style: const pw.TextStyle(
                              fontSize: 28.0,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Subtotal:     $subtotal',
                  style: pw.TextStyle(
                    fontSize: 48,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Discount:    $discount',
                  style: pw.TextStyle(
                    fontSize: 48,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  'Total:           $total',
                  style: pw.TextStyle(
                    fontSize: 48,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  '# ITEMS SOLD ${cartItems.length.toString()}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 50),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  formatter.format(now),
                  style: pw.TextStyle(
                    fontSize: 38,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  final tempDir = await getTemporaryDirectory();
  final tempPath = tempDir.path;
  final file = File('$tempPath/print_screen.pdf');
  await file.writeAsBytes(await pdf.save());

  return file;
}
