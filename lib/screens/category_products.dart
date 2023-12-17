// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/widgets/custom_gridtile.dart';
import 'package:http/http.dart' as http;

import '../classes/product.dart';

class CategoryProducts extends StatefulWidget {
  const CategoryProducts({
    Key? key,
    required this.categoryId,
  }) : super(key: key);
  final String? categoryId;

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  List<Product> categoryProds = [];

  Future<void> getCatProds(String? catId) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&category_id=$catId');

    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Product> fetchedProducts = [];
        for (Map i in jsonData) {
          fetchedProducts.add(
            Product(
              id: i['product_id'],
              name: i['product_name'],
              imageUrl: i['product_image'],
              newPrice: double.parse(i['product_price']),
              packageunits: double.parse(i['product_units_pack']),
              details: i['product_description'],
              packagePrice: double.parse(i['product_price_Package']),
            ),
          );
        }
        categoryProds = fetchedProducts;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getCatProds(widget.categoryId),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapShot.hasError) {
              return const Center(
                child: Text('خطأ في الاتصال'),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: categoryProds.length,
                itemBuilder: (context, i) => CustomGridTile(
                  id: categoryProds[i].id!,
                  imageUrl: categoryProds[i].imageUrl!,
                  productName: categoryProds[i].name!,
                  newPrice: categoryProds[i].newPrice!,
                  packPrice: categoryProds[i].packagePrice!,
                ),
              ),
            );
          }),
    );
  }
}
