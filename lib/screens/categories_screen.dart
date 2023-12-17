// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../screens/categories_tabs/categories_tab.dart';
import '../screens/categories_tabs/companies.dart';

class CategoriesTab extends StatefulWidget {
  static const routeName = 'categories_screen';
  const CategoriesTab({Key? key}) : super(key: key);

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List<Widget> categoriesTabs = [
    CatTab(),
    CompaniesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأقسام'),
          bottom: TabBar(tabs: [
            Tab(text: 'الأقسام'),
            Tab(text: 'الشركات'),
          ]),
        ),
        body: TabBarView(
          children: categoriesTabs,
        ),
      ),
    );
  }
}
