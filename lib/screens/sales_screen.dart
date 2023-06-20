import 'package:flutter/material.dart';
import 'package:pixelone/screens/add_new_orders.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewOders.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Walk-in Customer',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Warehouse',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search Product',
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(width: 1),
                  columns: const [
                    DataColumn(label: Text('Product Name')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Subtotal')),
                    DataColumn(label: Icon(Icons.delete_outline)),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Product 1')),
                      const DataCell(Text('10.00')),
                      const DataCell(Text('2')),
                      const DataCell(Text('20.00')),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                      )),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Product 2')),
                      const DataCell(Text('15.00')),
                      const DataCell(Text('1')),
                      const DataCell(Text('15.00')),
                      DataCell(IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {},
                      )),
                    ]),
                    // Add more rows as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
