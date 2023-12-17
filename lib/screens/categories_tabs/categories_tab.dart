// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:http/http.dart' as http;

import '../../classes/category.dart';
import '../../classes/product.dart';
import '../../widgets/custom_gridtile.dart';

class CatTab extends StatefulWidget {
  const CatTab({Key? key}) : super(key: key);

  @override
  State<CatTab> createState() => _CatTabState();
}

class _CatTabState extends State<CatTab> {
  List<Category> categories = [];
  List<Category> subCategories = [];
  List<Product> categoryProds = [];
  int catIndex = 0;
  int subCatIndex = 0;

  bool? isLoading;
  bool? subCatLoading;

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
            ),
          );
        }
        categories = fetchedCategories;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSubCats(String? catId) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_subCategory=all&subCategory_id=$catId');

    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Category> fetchedSubCats = [];
        for (Map i in jsonData) {
          fetchedSubCats.add(
            Category(
              id: '${i['Category_id']}',
              name: i['Category_name'],
            ),
          );
        }
        subCategories = fetchedSubCats;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSubCatProds(String? subCatId) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&category_id=$subCatId');

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
              newPrice: i['product_price'],
              details: i['product_description'],
              packagePrice: double.parse(i['product_price_Package']),
              packageunits: double.parse(i['product_units_pack']),
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
  void initState() {
    isLoading = true;
    getCategories().then((_) {
      getSubCats(categories[catIndex].id).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Center(
                    child: categories.isEmpty
                        ? const Center()
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, i) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  catIndex = i;
                                  subCatLoading = true;
                                });
                                getSubCats(categories[catIndex].id).then((_) {
                                  setState(() {
                                    subCatLoading = false;
                                  });
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  categories[i].name!,
                                  style: commonTextStyle.copyWith(
                                      color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Center(
                    child: subCatLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: subCategories.length,
                            itemBuilder: (context, i) => subCategories.isEmpty
                                ? const Center()
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        subCatIndex = i;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        subCategories[i].name!,
                                        style: commonTextStyle.copyWith(
                                            color: Colors.blue),
                                      ),
                                    ),
                                  ),
                          ),
                  ),
                ),
                Expanded(
                  child: subCategories.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : FutureBuilder(
                          future: getSubCatProds(subCategories[subCatIndex].id),
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
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
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
                            }
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
