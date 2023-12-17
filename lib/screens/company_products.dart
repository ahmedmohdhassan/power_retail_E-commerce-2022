// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/widgets/custom_gridtile.dart';
import 'package:http/http.dart' as http;

import '../classes/product.dart';

class CompanyProducts extends StatefulWidget {
  const CompanyProducts({
    Key? key,
    required this.companyId,
  }) : super(key: key);
  final String? companyId;

  @override
  State<CompanyProducts> createState() => _CompanyProductsState();
}

class _CompanyProductsState extends State<CompanyProducts> {
  List<Product> companyProds = [];

  Future<void> getCompProds(String? compId) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&manufacturer_id=$compId');

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
        companyProds = fetchedProducts;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getCompProds(widget.companyId),
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
                itemCount: companyProds.length,
                itemBuilder: (context, i) => CustomGridTile(
                  id: companyProds[i].id!,
                  imageUrl: companyProds[i].imageUrl!,
                  productName: companyProds[i].name!,
                  newPrice: companyProds[i].newPrice!,
                  packPrice: companyProds[i].packagePrice!,
                ),
              ),
            );
          }),
    );
  }
}
