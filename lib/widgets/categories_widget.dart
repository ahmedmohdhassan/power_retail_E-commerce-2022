import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/providers/categoriesprovider.dart';
import 'package:gomla/screens/category_products.dart';
import 'package:provider/provider.dart';

import '../screens/categories_screen.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: blue,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CategoriesTab.routeName);
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'كل الأقسام',
                        style: commonTextStyle,
                      ),
                    ],
                  ),
                ),
                const Text(
                  'الأقسام',
                  style: commonTextStyle,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CategoriesProvider>(
              builder: (context, catData, _) => Padding(
                padding: const EdgeInsets.only(
                  top: 7,
                ),
                child: catData.catItems.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: catData.catItems.length,
                        itemBuilder: (context, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CategoryProducts(
                                                    categoryId: catData
                                                        .catItems[i].id)));
                                  },
                                  child: Image.network(
                                    catData.catItems[i].imageUrl!,
                                    fit: BoxFit.fill,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              ),
                              Text(
                                catData.catItems[i].name!,
                                style: commonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
