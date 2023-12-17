// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import '../classes/product.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_form_field.dart';
import '../widgets/custom_gridtile.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? keyWord;
  bool isLoading = false;
  List<Product> suggestedProducts = [];
  List<Product> searchResults = [];
  Future<void> search(String? keyWord) async {
    if (keyWord != null) {
      var url = Uri.parse(
          'https://eatdevelopers.com/market/api_cart/api.php/?search=all&keyword=$keyWord');

      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          List<Product> fetchedResults = [];
          var jsonData = jsonDecode(response.body);

          for (Map i in jsonData) {
            fetchedResults.add(
              Product(
                id: i['product_id'],
                name: i['product_name'],
                imageUrl: i['product_image'],
                details: i['product_description'],
                newPrice: double.parse(i['product_price']),
                packagePrice: double.parse(i['product_price_Package']),
                packageunits: double.parse(i['product_units_pack']),
              ),
            );
          }
          searchResults = fetchedResults;
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getSuggestedProducts() async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?search=all');
    try {
      var response = await http.get(url);
      print(response.statusCode);
      List<Product> fetchedProducts = [];
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (Map i in jsonData) {
          fetchedProducts.add(Product(
            id: i['product_id'],
            name: i['product_name'],
            imageUrl: i['product_image'],
            details: i['product_description'],
            newPrice: double.parse(i['product_price']),
            packagePrice: double.parse(i['product_price_Package']),
            packageunits: double.parse(i['product_units_pack']),
          ));
        }
        suggestedProducts = fetchedProducts;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('البحث'),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: CustomFormField(
                  labelText: 'ابحث باسم المنتج...',
                  textInputAction: TextInputAction.done,
                  suffixIconButton: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      keyWord = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: keyWord == null
                    ? FutureBuilder(
                        future: getSuggestedProducts(),
                        builder: (context, snapShot) {
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapShot.hasError) {
                            return const Center(
                              child: Text('خطأ في الإتصال'),
                            );
                          } else {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3 / 4,
                              ),
                              itemCount: suggestedProducts.length,
                              itemBuilder: (context, i) => CustomGridTile(
                                id: suggestedProducts[i].id!,
                                imageUrl: suggestedProducts[i].imageUrl!,
                                productName: suggestedProducts[i].name!,
                                newPrice: suggestedProducts[i].newPrice!,
                              ),
                            );
                          }
                        })
                    : FutureBuilder(
                        future: search(keyWord),
                        builder: (context, snapShot) {
                          if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapShot.hasError) {
                            return const Center(
                              child: Text('خطأ في الإتصال'),
                            );
                          } else {
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 3 / 4,
                              ),
                              itemCount: searchResults.length,
                              itemBuilder: (context, i) => CustomGridTile(
                                id: searchResults[i].id!,
                                imageUrl: searchResults[i].imageUrl!,
                                productName: searchResults[i].name!,
                                newPrice: searchResults[i].newPrice!,
                              ),
                            );
                          }
                        }),
              ),
            ],
          ),
        ));
  }
}
