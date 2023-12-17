// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../classes/category.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _items = [];
  List<Category> get catItems => [..._items];

  Future<void> getCategories() async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_category=all');

    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Category> fetchedCategories = [];
        for (Map i in jsonData) {
          fetchedCategories.add(
            Category(
              id: '${i['Category_id']}',
              name: i['Category_name'],
              imageUrl: i['Category_img'],
            ),
          );
        }
        _items = fetchedCategories;
      }
    } catch (e) {
      print(e);
    }
  }
}
