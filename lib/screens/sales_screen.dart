import 'package:flutter/material.dart';
import 'package:pixelone/model/product_model.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:pixelone/providers/customer.dart';
import 'package:pixelone/providers/orders.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_orders.dart';
import 'package:pixelone/screens/addingtocart_screen.dart';
import 'package:pixelone/screens/order_screen.dart';
import 'package:pixelone/screens/print_screen.dart';
import 'package:pixelone/widgets/customer_dialog.dart';
import 'package:pixelone/widgets/sales_dialog.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  static const routeName = '/Sales';

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late Products productProvider;
  int? suspendedOrderId;
  OrderStatus status = OrderStatus.suspended;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<Customer>(context, listen: false).fetchingCustomerFromDB();
      productProvider = Provider.of<Products>(context, listen: false);
      productProvider.fetchingProductFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Product> cartItems = Provider.of<Cart>(context).cartItems;
    Cart cartProvider = Provider.of<Cart>(context, listen: false);

    double subtotal = cartProvider.calculateSubtotal();
    double discount = cartProvider.discount;
    double total = cartProvider.calculateTotal(subtotal);
    double paidAmount = cartProvider.paidAmount;
    double returnAmount = cartProvider.returnAmount(total);
    double dueAmount = cartProvider.dueAmount(total);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Sales'),
        actions: [
          ElevatedButton(
              onPressed: () async {
                final int? sid = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const OrderScreen())),
                );
                setState(() {
                  suspendedOrderId = sid;
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              child: const Text('Suspeded')),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrintScreen(
                        orderId: 8,
                        paidAmount: 10,
                      ),
                    ));
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              child: const Text('Print')),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewOders.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth >= 500) {
            return _buildWideLayout(context, cartItems, subtotal, discount,
                total, paidAmount, returnAmount, dueAmount);
          } else {
            return _buildNarrowLayout(context, cartItems, subtotal, discount,
                total, paidAmount, returnAmount, dueAmount);
          }
        },
      ),
    );
  }

  Widget _buildNarrowLayout(
      BuildContext context,
      List<Product> cartItems,
      double subtotal,
      double discount,
      double total,
      double paidAmount,
      double returnAmount,
      double dueAmount) {
    Cart cartProvider = Provider.of(context, listen: false);
    Orders orderProvider = Provider.of<Orders>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'Walk-in Customer',
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Warehouse',
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) =>
                        Provider.of<Products>(context).setSearchText(value),
                    decoration: const InputDecoration(
                      labelText: 'Search Product',
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.clearCart();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            if (cartItems.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  color: Colors.grey,
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Cart Items',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 70),
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.length,
              itemBuilder: (BuildContext context, int index) {
                Product product = cartItems[index];
                double subtotal = product.price * product.quantity;

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(
                    '${product.quantity} x ${product.price} = $subtotal',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          cartProvider.decreaseQuantity(product);
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(product.quantity.toString()),
                      IconButton(
                        onPressed: () {
                          cartProvider.addToCart(product);
                        },
                        icon: const Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {
                          cartProvider.removeFromCart(product);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddingToCartScreen(),
                  ),
                );
              },
              child: const Text('Add Items'),
            ),
            const SizedBox(height: 20.0),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  subtotal.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Discount:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    initialValue: discount.toStringAsFixed(0),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      cartProvider.setDiscount(double.tryParse(value) ?? 0.0);
                    },
                    decoration: const InputDecoration(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  total.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Paid Amount:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                SizedBox(
                  width: 50.0,
                  child: TextFormField(
                    initialValue: paidAmount.toStringAsFixed(0),
                    keyboardType: const TextInputType.numberWithOptions(),
                    onChanged: (value) {
                      cartProvider.setPaidAmount(double.tryParse(value) ?? 0.0);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Return Amount:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  returnAmount.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Due Amount:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  dueAmount.toStringAsFixed(2),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    int orderId;

                    orderId = await orderProvider.storeOrders(
                      null,
                      subtotal,
                      discount,
                      returnAmount,
                      dueAmount,
                      total,
                      paidAmount,
                      OrderStatus.completed,
                    );

                    for (Product product in cartItems) {
                      orderProvider.storeOderItems(
                        orderId,
                        product.id,
                        product.name,
                        product.price,
                        product.quantity,
                        discount,
                      );
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrintScreen(
                          orderId: orderId,
                          paidAmount: 500,
                        ),
                      ),
                    );
                  },
                  child: const Text('Suspended'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    int orderId;

                    orderId = await orderProvider.storeOrders(
                      null,
                      subtotal,
                      discount,
                      returnAmount,
                      dueAmount,
                      total,
                      paidAmount,
                      OrderStatus.completed,
                    );

                    for (Product product in cartItems) {
                      orderProvider.storeOderItems(
                        orderId,
                        product.id,
                        product.name,
                        product.price,
                        product.quantity,
                        discount,
                      );
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrintScreen(
                          orderId: orderId,
                          paidAmount: 500,
                        ),
                      ),
                    );
                  },
                  child: const Text('Save & Print'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWideLayout(
      BuildContext context,
      List<Product> cartItems,
      double subtotal,
      double discount,
      double total,
      double paidAmount,
      double returnAmount,
      double dueAmount) {
    Cart cartProvider = Provider.of<Cart>(context, listen: false);
    Orders orderProvider = Provider.of<Orders>(context, listen: false);
    Customer customerProvider = Provider.of<Customer>(context, listen: false);

    String getSelectedCustomerName() {
      final selectedCustomer =
          Provider.of<Customer>(context, listen: false).selectedCustomer;

      return selectedCustomer != null ? selectedCustomer.firstName : '';
    }

    final filteredList =
        Provider.of<Products>(context, listen: false).getFilteredProducts();
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            labelText: 'Walk-in Customer',
                          ),
                          onChanged: (value) =>
                              Provider.of<Customer>(context, listen: false)
                                  .setSearchText(value),
                          controller: TextEditingController(
                            text: getSelectedCustomerName(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const CustomerDialog();
                            },
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline_sharp),
                      ),
                      IconButton(
                        onPressed: () async {
                          customerProvider.selectedCustomer == null;
                        },
                        icon: const Icon(Icons.delete_forever_outlined),
                      ),
                    ],
                  ),
                  Consumer<Customer>(
                    builder: (context, customerProvider, child) {
                      final filteredCustomers =
                          customerProvider.getFilteredCustomers();

                      return customerProvider.searchText.isNotEmpty
                          ? SizedBox(
                              height: 150,
                              width: 300,
                              child: ListView.separated(
                                itemCount: filteredCustomers.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final customer = filteredCustomers[index];
                                  return ListTile(
                                    title: Text(customer.firstName),
                                    subtitle: Text(customer.address),
                                    onTap: () {
                                      customerProvider
                                          .setSelectedCustomer(customer);
                                    },
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Warehouse',
                    ),
                  ),
                  if (cartItems.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(border: Border.all(width: 2)),
                      child: FittedBox(
                        child: DataTable(
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
                            DataColumn(
                              label: Text(
                                'X',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          rows: cartItems
                              .map((product) => DataRow(
                                    cells: [
                                      DataCell(Text(product.name)),
                                      DataCell(Text(product.price.toString())),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              cartProvider
                                                  .decreaseQuantity(product);
                                            },
                                          ),
                                          Text(product.quantity.toString()),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              cartProvider.addToCart(product);
                                            },
                                          ),
                                        ],
                                      )),
                                      DataCell(Text(
                                          (product.price * product.quantity)
                                              .toString())),
                                      DataCell(IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          cartProvider.removeFromCart(product);
                                        },
                                      )),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Subtotal:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        subtotal.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Due Amount:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        dueAmount.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        total.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: cartItems.isEmpty
                            ? null
                            : () async {
                                if (suspendedOrderId != null) {
                                  await orderProvider.storeOrders(
                                    suspendedOrderId,
                                    subtotal,
                                    discount,
                                    returnAmount,
                                    dueAmount,
                                    total,
                                    paidAmount,
                                    OrderStatus.suspended,
                                  );

                                  for (Product product in cartItems) {
                                    orderProvider.storeOderItems(
                                      suspendedOrderId!,
                                      product.id,
                                      product.name,
                                      product.price,
                                      product.quantity,
                                      discount,
                                    );
                                  }
                                } else {
                                  final orderId =
                                      await orderProvider.storeOrders(
                                    null,
                                    subtotal,
                                    discount,
                                    returnAmount,
                                    dueAmount,
                                    total,
                                    paidAmount,
                                    OrderStatus.suspended,
                                  );

                                  for (Product product in cartItems) {
                                    orderProvider.storeOderItems(
                                      orderId,
                                      product.id,
                                      product.name,
                                      product.price,
                                      product.quantity,
                                      discount,
                                    );
                                  }
                                }

                                cartProvider.setPaidAmount(0);
                                cartProvider.clearCart();
                              },
                        child: const Text('Suspend'),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: cartItems.isEmpty
                            ? null
                            : () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomDialog(suspendedOrderId ?? 0);
                                  },
                                );
                              },
                        child: const Text('Pay'),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton(
                          onPressed: () {
                            cartProvider.clearCart();
                          },
                          child: const Text('Clear Cart'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) =>
                              Provider.of<Products>(context, listen: false)
                                  .setSearchText(value),
                          decoration: const InputDecoration(
                            labelText: 'Search Product',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                      'All Products (${Provider.of<Products>(context).items.length})'),
                  const SizedBox(height: 10.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (ctx, index) {
                      final product = filteredList[index];
                      return GestureDetector(
                        onTap: () {
                          cartProvider.addToCart(product);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Image.network(product.imageurl),
                          ),
                          title: Text(product.name),
                          subtitle: Text('Sale Price: ${product.saleprice} '),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
