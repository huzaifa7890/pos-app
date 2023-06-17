import 'package:flutter/material.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_products.dart';
import 'package:pixelone/utils/constants.dart' as constant;
import 'package:provider/provider.dart';
import '../model/http_exception.dart';
import 'product_detail_screen.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
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

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<Products>(context);
    final filteredList = productProvider.getFilteredProducts();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewProducts.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    enabled: filteredList.isNotEmpty,
                    onChanged: filteredList.isEmpty
                        ? null
                        : (value) {
                            productProvider.setSearchText(value);
                          },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      isRefreshing = true;
                    });
                    productProvider.fetchingProductFromDB().then((_) {
                      setState(() {
                        isRefreshing = false;
                      });
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Consumer<Products>(
                builder: (context, productProvider, _) {
                  final isLoading = productProvider.isLoading;
                  if (isLoading || isRefreshing) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (filteredList.isEmpty) {
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
                          Navigator.of(context).pushNamed(
                            ProductDetailScreen.routeName,
                            arguments: product.id,
                          );
                        },
                        child: ListTile(
                          title: Text(product.name),
                          subtitle: Text('Sale Price: ${product.saleprice}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
