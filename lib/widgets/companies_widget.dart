import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/providers/company_provider.dart';
import 'package:provider/provider.dart';
import '../screens/categories_screen.dart';
import '../screens/company_products.dart';

class CompaniesWidget extends StatelessWidget {
  const CompaniesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
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
                    children: [
                      const Icon(
                        Icons.list,
                        color: Colors.blue,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'كل الشركات',
                        style: commonTextStyle.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'الشركات',
                  style: commonTextStyle.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CompaniesProvider>(
              builder: (context, compData, _) => Padding(
                padding: const EdgeInsets.only(
                  top: 7,
                ),
                child: compData.compItems.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: compData.compItems.length,
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
                                                CompanyProducts(
                                                    companyId: compData
                                                        .compItems[i].id)));
                                  },
                                  child: Image.network(
                                    compData.compItems[i].imageUrl!,
                                    fit: BoxFit.fill,
                                    height: 100,
                                    width: 100,
                                  ),
                                ),
                              ),
                              Text(
                                compData.compItems[i].name!,
                                style: commonTextStyle.copyWith(
                                  color: Colors.blue,
                                ),
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
