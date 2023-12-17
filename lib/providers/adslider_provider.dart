import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gomla/classes/ad_slider_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdSliderProvider with ChangeNotifier {
  List<AdSliderItem> adSliderItems = [];

  List<AdSliderItem> get sliderItems => [...adSliderItems];

  Future<void> getSliderItems() async {
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php?get_slider=all';
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<AdSliderItem> fetcheditems = [];
        for (Map i in jsonData) {
          fetcheditems.insert(
              0,
              AdSliderItem(
                id: '${i['slider_id']}',
                title: i['slider_title'],
                imageUrl: i['slider_link'],
                adCase: '${i['slider_case']}',
                type: i['slider_type'],
              ));
        }
        adSliderItems = fetcheditems;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
