// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/classes/company.dart';
import 'package:http/http.dart' as http;

class CompaniesProvider with ChangeNotifier {
  List<Company> _items = [];
  List<Company> get compItems => [..._items];

  Future<void> getCompanies() async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_manufactory=all');

    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Company> fetchedCompanies = [];
        for (Map i in jsonData) {
          fetchedCompanies.add(
            Company(
              id: '${i['manufactory_id']}',
              name: i['manufactory_name'],
              imageUrl: i['manufactory_img'],
            ),
          );
        }
        _items = fetchedCompanies;
      }
    } catch (e) {
      print(e);
    }
  }
}
