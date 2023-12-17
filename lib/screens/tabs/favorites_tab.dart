// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../classes/product.dart';
import '../../widgets/custom_gridtile.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({Key? key}) : super(key: key);

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  List<Product> favorites = [];

  Future<void> getFavorites() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getString('user_id');
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?getwishlist=show&Clients_id=$userId');

    try {
      var response = await http.get(url);
      print(response.statusCode);
      var jsonData = jsonDecode(response.body);
      List<Product> fetchedFavs = [];
      if (response.statusCode == 200) {
        for (Map i in jsonData) {
          fetchedFavs.add(Product(
            id: i['product_id'],
            name: i['product_name'],
            newPrice: double.parse(i['product_price']),
            imageUrl: i['product_image'],
            details: i['product_description'],
            packagePrice: double.parse(i['product_price_Package']),
            packageunits: double.parse(i['product_units_pack']),
          ));
        }
        favorites = fetchedFavs;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFavorites(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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
              itemCount: favorites.length,
              itemBuilder: (context, i) => CustomGridTile(
                id: favorites[i].id!,
                imageUrl: favorites[i].imageUrl!,
                productName: favorites[i].name!,
                newPrice: favorites[i].newPrice!,
                packPrice: favorites[i].packagePrice!,
              ),
            ),
          );
        }
      },
    );
  }
}
