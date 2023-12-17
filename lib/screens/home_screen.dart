// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/cart_api.dart';
import 'package:gomla/providers/adslider_provider.dart';
import 'package:gomla/providers/categoriesprovider.dart';
import 'package:gomla/providers/company_provider.dart';
import 'package:gomla/providers/user_provider.dart';
import 'package:gomla/screens/complaints.dart';
import 'package:gomla/screens/login_screen.dart';
import 'package:gomla/screens/notifications_screen.dart';
import 'package:gomla/screens/settings.dart';
import 'package:gomla/screens/tabs/account_tab.dart';
import 'package:gomla/screens/tabs/cart_tab.dart';
import 'package:gomla/screens/tabs/favorites_tab.dart';
import 'package:gomla/screens/tabs/main_tab.dart';
import 'package:gomla/screens/tabs/offers_tab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/badge.dart';
import '../widgets/drawer.dart';
import '../widgets/nav_bar_item.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home_page';
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  int _currentIndex = 0;
  String text1 = 'في انتظار تفعيل الحساب من الادارة';
  String userType = '';
  List<Widget> screens = [
    const MainTab(),
    const AccountTab(),
    const OffersTab(),
    const FavoritesTab(),
    const CartTab(),
  ];

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getUserType();
    Future.wait([
      Provider.of<UserProvider>(context, listen: false).getProfileInfo(context),
      Provider.of<CategoriesProvider>(context, listen: false).getCategories(),
      Provider.of<CompaniesProvider>(context, listen: false).getCompanies(),
      Provider.of<CartApi>(context, listen: false).fetchDiscountList(),
      Provider.of<CartApi>(context, listen: false).fetchClientReward(),
      Provider.of<CartApi>(context, listen: false).getCartItems(),
      Provider.of<AdSliderProvider>(context, listen: false).getSliderItems()
    ]).catchError((e) {
      print(e);
      showErrorBar(context);
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void getUserType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      userType = pref.getString('user_type')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading == true
          ? const PreferredSize(child: Text(''), preferredSize: Size(0, 0))
          : AppBar(
              title: const Text(
                'الوسيط التجاري',
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              bottom: PreferredSize(
                  child: userType != '2'
                      ? const Text('')
                      : Container(
                          color: Colors.amber,
                          child: Text(text1),
                        ),
                  preferredSize: userType != '2'
                      ? const Size.fromHeight(0)
                      : const Size.fromHeight(50)),
              actions: [
                _currentIndex == 4
                    ? IconButton(
                        onPressed: () {
                          Provider.of<CartApi>(context, listen: false)
                              .clearCart(context);
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : const Text(''),
                IconButton(
                  icon: const Icon(
                    Icons.notifications_outlined,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(NotificationsScreen.routeName);
                  },
                ),
              ],
            ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : screens[_currentIndex],
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xff2473c1),
          child: ListView(
            children: [
              Consumer<UserProvider>(builder: (context, user, _) {
                return Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Color(0xff2473c1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff2473c1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.white,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    user.user.imageUrl ??
                                        'https://z.mahgoubtech.com/logo.png',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            user.user.storeName ?? '',
                            softWrap: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.user.userAddress ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              DrawerItem(
                title: 'الصفحة الرئيسية',
                icon: Icons.home_filled,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              DrawerItem(
                title: 'حسابي',
                icon: Icons.person,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              DrawerItem(
                title: 'المفضلة',
                icon: Icons.favorite_border,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentIndex = 3;
                  });
                },
              ),
              DrawerItem(
                title: 'الرصيد',
                icon: Icons.account_balance_wallet_sharp,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              DrawerItem(
                title: 'الاعدادات',
                icon: Icons.settings,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(SettingsScreen.routeName);
                },
              ),
              DrawerItem(
                title: 'الاشعارات',
                icon: Icons.notifications,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamed(NotificationsScreen.routeName);
                },
              ),
              DrawerItem(
                title: 'الشكاوى و المقترحات',
                icon: Icons.report_problem,
                color: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(Complaints.routeName);
                },
              ),
              DrawerItem(
                title: 'تسجيل الخروج',
                icon: Icons.exit_to_app,
                color: Colors.red,
                onTap: () {
                  Navigator.of(context).pop();
                  signOut();
                  Navigator.of(context).pushNamed(LogInScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavBarItem(
                    icon: Icons.home_outlined,
                    text: 'الرئيسية',
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                  ),
                  NavBarItem(
                    icon: Icons.person_outline,
                    text: 'حسابي',
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                  ),
                  NavBarItem(
                    icon: Icons.local_offer_outlined,
                    text: 'العروض',
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  ),
                  NavBarItem(
                    icon: Icons.favorite_border_outlined,
                    text: 'المفضلة',
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  child: FutureBuilder(
                      future: Provider.of<CartApi>(context, listen: false)
                          .getCartItems(),
                      builder: (context, snapshot) {
                        return Consumer<CartApi>(
                          builder: (context, cartData, _) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Badge(
                                color: Colors.red,
                                value: '${cartData.itemCount}',
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        '${cartData.totalCost} ج.م',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          child: Text(
                                            'خصم ${cartData.clientDiscount} ج.م',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
