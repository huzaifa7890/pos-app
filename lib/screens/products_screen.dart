import 'package:flutter/material.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_products.dart';
import 'package:provider/provider.dart';
import 'package:pixelone/widgets/app_drawer.dart';
import 'product_detail_screen.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';

  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Products productProvider;

  @override
  void initState() {
    super.initState();
    // Delay the execution of fetchingProductFromDB using addPostFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider = Provider.of<Products>(context, listen: false);
      productProvider.fetchingProductFromDB();
    });
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<Products>(context);

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
      drawer: const AppDrawer(),
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
                    onChanged: (value) {
                      productProvider.setSearchText(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    productProvider.fetchingProductFromDB();
                  },
                ),
              ],
            ),
            Expanded(
              child: Consumer<Products>(
                builder: (context, productProvider, _) {
                  final filteredList = productProvider.getFilteredProducts();

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
