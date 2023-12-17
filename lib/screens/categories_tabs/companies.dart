// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:http/http.dart' as http;
import '../../classes/company.dart';
import '../../classes/product.dart';
import '../../widgets/custom_gridtile.dart';

class CompaniesTab extends StatefulWidget {
  const CompaniesTab({Key? key}) : super(key: key);

  @override
  State<CompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends State<CompaniesTab> {
  List<Company> companies = [];
  List<Product> companyProds = [];

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
            ),
          );
        }
        companies = fetchedCompanies;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCompanyProds(String? companyId) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&manufacturer_id=$companyId');

    try {
      var response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Product> fetchedprods = [];
        for (Map i in jsonData) {
          fetchedprods.add(
            Product(
              id: i['product_id'],
              name: i['product_name'],
              newPrice: double.parse(i['product_price']),
              imageUrl: i['product_image'],
              details: i['product_description'],
              packagePrice: double.parse(i['product_price_Package']),
              packageunits: double.parse(i['product_units_pack']),
            ),
          );
        }
        companyProds = fetchedprods;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    isLoading = true;
    getCompanies().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  bool? isLoading;
  bool? isBold;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: companies.length,
                    itemBuilder: (context, i) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              currentIndex = i;
                            });
                          },
                          child: Text(
                            companies[i].name!,
                            style: commonTextStyle.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: companies[currentIndex].id == null
                        ? const Center(child: CircularProgressIndicator())
                        : FutureBuilder(
                            future: getCompanyProds(companies[currentIndex].id),
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
                              }
                            },
                          )),
              ],
            ),
          );
  }
}
