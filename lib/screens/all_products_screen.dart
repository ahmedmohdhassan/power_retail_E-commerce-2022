import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../classes/product.dart';
import '../constants.dart';
import '../widgets/custom_gridtile.dart';

class AllProdsScreen extends StatefulWidget {
  static const routeName = 'all_prods';
  const AllProdsScreen({Key? key}) : super(key: key);

  @override
  State<AllProdsScreen> createState() => _AllProdsScreenState();
}

class _AllProdsScreenState extends State<AllProdsScreen> {
  List<Product> items = [];

  Future getAllProducts() async {
    const String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&product_id=all';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List<Product> fetchedProducts = [];
      var jsonData = jsonDecode(response.body);
      for (Map i in jsonData) {
        fetchedProducts.add(
          Product(
            id: i['product_id'],
            name: i['product_name'],
            newPrice: double.parse(i['product_price']),
            imageUrl: i['product_image'],
            details: i['product_description'],
            packagePrice: double.parse(i['product_price_Package']),
            packageunits: double.parse(i['product_units_pack']),
          ),
        );
      }
      items = fetchedProducts;
    } else {
      // ignore: avoid_print
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوسيط التجاري'),
      ),
      body: FutureBuilder(
        future: getAllProducts(),
        builder: (context, snapShot) {
          Widget result;
          if (snapShot.connectionState == ConnectionState.waiting) {
            result = const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapShot.hasError) {
            result = Center(
              child: Text(
                'خطأ في الاتصال',
                style: commonTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            result = items.isEmpty
                ? const Center(
                    child: Text('لا يوجد منتجات للعرض'),
                  )
                : GridView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, i) => CustomGridTile(
                      id: items[i].id,
                      productName: items[i].name,
                      imageUrl: items[i].imageUrl,
                      newPrice: items[i].newPrice,
                      oldPrice: items[i].oldPrice,
                      packPrice: items[i].packagePrice,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                  );
          }
          return result;
        },
      ),
    );
  }
}
