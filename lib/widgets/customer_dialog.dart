import 'package:flutter/material.dart';
import 'package:pixelone/providers/customer.dart';
import 'package:provider/provider.dart';

class CustomerDialog extends StatefulWidget {
  const CustomerDialog({Key? key}) : super(key: key);

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Customer Details'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            String firstName = _firstNameController.text;
            String lastName = _lastNameController.text;
            String address = _addressController.text;
            String phoneNumber = _phoneController.text;

            Provider.of<Customer>(context, listen: false)
                .addCustomer(firstName, lastName, address, phoneNumber);

            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
