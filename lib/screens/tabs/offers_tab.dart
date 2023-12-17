// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../classes/product.dart';
import '../../widgets/custom_gridtile.dart';

class OffersTab extends StatefulWidget {
  const OffersTab({Key? key}) : super(key: key);

  @override
  State<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends State<OffersTab> {
  List<Product> discounts = [];

  Future<void> getdiscounts() async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_offers_list=all');

    try {
      var response = await http.get(url);

      print(response.statusCode);
      var jsonData = jsonDecode(response.body);
      List<Product> fetcheddiscounts = [];
      if (response.statusCode == 200) {
        for (Map i in jsonData) {
          fetcheddiscounts.add(Product(
            id: i['product_id'],
            name: i['product_name'],
            newPrice: double.parse(i['product_price']),
            imageUrl: i['product_image'],
            details: i['product_description'],
            packagePrice: double.parse(i['product_price_Package']),
            packageunits: double.parse(i['product_units_pack']),
          ));
        }
        discounts = fetcheddiscounts;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdiscounts(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapShot.hasError) {
          return const Center(
            child: Text('خطأ في الإتصال'),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 4,
              ),
              itemCount: discounts.length,
              itemBuilder: (context, i) => CustomGridTile(
                id: discounts[i].id,
                imageUrl: discounts[i].imageUrl!,
                productName: discounts[i].name!,
                newPrice: discounts[i].newPrice!,
                packPrice: discounts[i].packagePrice!,
              ),
            ),
          );
        }
      },
    );
  }
}
