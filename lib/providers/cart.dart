import 'package:flutter/foundation.dart';
import 'package:pixelone/model/product_model.dart';

class Cart with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => [..._cartItems];

  double _discount = 0;
  double _paidAmount = 0;

  double get discount => _discount;
  double get paidAmount => _paidAmount;

  void setDiscount(double value) {
    _discount = value;
    notifyListeners();
  }

  void setPaidAmount(double value) {
    _paidAmount = value;
    notifyListeners();
  }

  double returnAmount(total) {
    if (paidAmount <= total) {
      return 0;
    } else {
      return paidAmount - total;
    }
  }

  double dueAmount(total) {
    if (paidAmount >= total) {
      return 0;
    } else {
      return total - paidAmount;
    }
  }

  void addToCart(Product product) {
    final existingProductIndex =
        _cartItems.indexWhere((item) => item.id == product.id);

    if (existingProductIndex != -1) {
      _cartItems[existingProductIndex].quantity++;
    } else {
      _cartItems.add(product);
    }

    notifyListeners();
  }

  void addToCartByBarcode(String barcode) {
    final product =
        // ignore: unrelated_type_equality_checks
        _cartItems.firstWhere((product) => product.barcode == barcode);

    // ignore: unnecessary_null_comparison
    if (product != null) {
      _cartItems.add(product);
      notifyListeners();
    }
  }

  void decreaseQuantity(Product product) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.id == product.id);

    if (existingIndex >= 0) {
      if (_cartItems[existingIndex].quantity <= 1) {
        removeFromCart(product);
      } else {
        _cartItems[existingIndex].quantity--;
      }
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.id == product.id);

    if (existingIndex >= 0) {
      _cartItems.removeAt(existingIndex);
      product.quantity = 1;
    }

    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double calculateSubtotal() {
    double subtotal = 0.0;
    for (Product product in _cartItems) {
      subtotal += (product.price * product.quantity);
    }
    return subtotal;
  }
}
