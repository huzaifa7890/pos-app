import 'package:flutter/material.dart';
import 'package:pixelone/db_helper/product_db.dart';
import 'package:pixelone/model/customer_model.dart';

class Customer extends ChangeNotifier {
  List<CustomerModel> _items = [];
  String searchText = '';
  CustomerModel? _selectedCustomer;
  CustomerModel? get selectedCustomer => _selectedCustomer;

  List<CustomerModel> get items {
    return [..._items];
  }

  void setSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  void setSelectedCustomer(CustomerModel customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  Future<void> addCustomer(
    String firstName,
    String lastName,
    String address,
    String phoneNo,
  ) async {
    final addNewCustomer = CustomerModel(
        id: 1,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNo,
        address: address);
    _items.add(addNewCustomer);
    notifyListeners();
    DBHelper.insert('customer', {
      'firstname': firstName,
      'lastname': lastName,
      'address': address,
      'phoneno': phoneNo,
    });
  }

  List<CustomerModel> getFilteredCustomers() {
    final filteredCustomers = _items.where((customer) {
      // Filter customers whose name or address contains the search text
      return customer.firstName
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          customer.address.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return filteredCustomers;
  }

  Future<void> fetchingCustomerFromDB() async {
    final dataList = await DBHelper.getData('customer');
    _items = dataList
        .map(
          (e) => CustomerModel(
              id: e['id'],
              firstName: e['firstname'],
              lastName: e['lastname'],
              phoneNumber: e['phoneno'],
              address: e['address']),
        )
        .toList();
    notifyListeners();
  }
}
