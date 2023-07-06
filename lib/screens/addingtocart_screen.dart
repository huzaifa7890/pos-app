import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pixelone/model/http_exception.dart';
import 'package:pixelone/providers/carts.dart';
import 'package:pixelone/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:pixelone/utils/constants.dart' as constant;

class AddingToCartScreen extends StatefulWidget {
  const AddingToCartScreen({super.key});

  @override
  State<AddingToCartScreen> createState() => _AddingToCartScreenState();
}

class _AddingToCartScreenState extends State<AddingToCartScreen> {
  late Products productProvider;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider = Provider.of<Products>(context, listen: false);
      productProvider.fetchingProductFromDB();
    });
  }

  String barcodeResult = '';
  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
      if (!mounted) return;
      setState(() {
        barcodeResult = barcode;
      });
      Provider.of<Carts>(context, listen: false).addToCartByBarcode(barcode);
      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        barcodeResult = 'Scan failed: No Product With This Barcode';
      });
    }
  }

  Future<void> _refreshProducts() async {
    await productProvider.fetchingProductFromDB();
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<Products>(context, listen: false);
    final filteredList = productProvider.getFilteredProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search Items',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    productProvider.setSearchText(value);
                  },
                ),
              ),
              ElevatedButton.icon(
                label: const Text('Scan Image'),
                onPressed: () async {
                  await _scanBarcode();
                },
                icon: const Icon(Icons.image),
              ),
            ],
          ),
          Text(
            barcodeResult,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: Consumer<Products>(
                builder: (context, productProvider, _) {
                  final isLoading = productProvider.isLoading;
                  if (isLoading || isRefreshing) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (productProvider.items.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(constant.T_ERROR),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              setState(() {
                                isRefreshing = true;
                              });
                              await productProvider.storingDataInDbFromAPI();
                              await productProvider.fetchingProductFromDB();
                              setState(() {
                                isRefreshing = false;
                              });
                            } on HttpException catch (error) {
                              var errorMessage = constant.HT_ERROR;
                              errorMessage = error.toString();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.black,
                              ));
                              setState(() {
                                isRefreshing = false;
                              });
                            } catch (error) {
                              var errorMessage = constant.HT_ERROR;

                              errorMessage = error.toString();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: Colors.black,
                              ));
                              setState(() {
                                isRefreshing = false;
                              });
                            }
                          },
                          child: const Text("Add Product"),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final product = filteredList[index];
                      return GestureDetector(
                        onTap: () {
                          Provider.of<Carts>(context, listen: false)
                              .addToCart(product);
                          Navigator.of(context).pop();
                        },
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                              'Sale Price: ${product.saleprice} Quantity:${product.quantity}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
