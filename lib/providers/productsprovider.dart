// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../classes/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> items = [];
  List<Product> get prodItems => [...items];

  List<Product> allProditems = [];
  List<Product> get allprods => [...allProditems];

  List<Product> wishListed = [];
  List<Product> get favorites => [...wishListed];

// fetch last 100 products
  Future getNewProducts() async {
    const String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&product_id=last100';

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
            packagePrice: double.parse(i['product_price_Package']),
            packageunits: double.parse(i['product_units_pack']),
            imageUrl: i['product_image'],
            details: i['product_description'],
          ),
        );
      }
      items = fetchedProducts;
      notifyListeners();
    } else {
      print('error');
    }
  }

// fetch all products
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
            packagePrice: double.parse(i['product_price_Package']),
            packageunits: double.parse(i['product_units_pack']),
            imageUrl: i['product_image'],
            details: i['product_description'],
          ),
        );
      }
      items = fetchedProducts;
      notifyListeners();
    } else {
      print('error');
    }
  }
}




//  Product(
//       id: '1',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '2',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '3',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '4',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '5',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '6',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '7',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),
//     Product(
//       id: '8',
//       name: 'معلبات',
//       imageUrl:
//           'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
//       newPrice: 10,
//     ),