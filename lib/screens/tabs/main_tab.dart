import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/widgets/companies_widget.dart';
import '../../screens/all_products_screen.dart';
import '../../widgets/ads_banner.dart';
import '../../widgets/categories_widget.dart';
import '../../widgets/new_products_widget.dart';
import '../../widgets/search_bar.dart';

class MainTab extends StatelessWidget {
  const MainTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            const SearchBar(),
            const AdsBanner(),
            const CategoriesWidget(),
            const CompaniesWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      AllProdsScreen.routeName,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        const SizedBox(width: 10),
                        Text(
                          'كل المنتجات',
                          style: commonTextStyle.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'أحدث المنتجات',
                    style: commonTextStyle.copyWith(color: Colors.black),
                  ),
                ],
              ),
            )
          ]),
        ),
        const NewProdWidget()
      ],
    );
  }
}
