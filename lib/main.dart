import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gomla/classes/cart_api.dart';
import 'package:gomla/providers/company_provider.dart';
import 'package:gomla/screens/complaints.dart';
import 'package:gomla/screens/edit_store_screen.dart';
import 'package:gomla/screens/my_invoices.dart';
import 'package:gomla/screens/search_screen.dart';
import 'package:gomla/screens/settings.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/edit_profile_screen.dart';
import '../providers/adslider_provider.dart';
import '../screens/change_password.dart';
import '../screens/all_products_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/recover_password.dart';
import '../providers/categoriesprovider.dart';
import '../providers/productsProvider.dart';
import '../screens/activation_screen.dart';
import '../screens/map_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/register_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../notifications/push_nofitications.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  pushNotification.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();
final PushNotificationManager pushNotification = PushNotificationManager();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => AdSliderProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartApi()),
        ChangeNotifierProvider(create: (context) => CompaniesProvider()),
      ],
      child: MaterialApp(
        navigatorKey: mainNavigatorKey,
        theme: ThemeData(
          fontFamily: 'Cairo',
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: blue,
            elevation: 0.0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Cairo',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          scaffoldBackgroundColor: Colors.grey[200],
        ),
        home: const LogInScreen(),
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          LogInScreen.routeName: (context) => const LogInScreen(),
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          MapScreen.routeName: (context) => const MapScreen(),
          ActivationScreen.routeName: (context) => const ActivationScreen(),
          NotificationsScreen.routeName: (context) =>
              const NotificationsScreen(),
          PasswordRecvovery.routeName: (context) => const PasswordRecvovery(),
          ChangePassword.routeName: (context) => const ChangePassword(),
          CategoriesTab.routeName: (context) => const CategoriesTab(),
          AllProdsScreen.routeName: (context) => const AllProdsScreen(),
          EditProfileScreen.routeName: (context) => const EditProfileScreen(),
          EditStoreScreen.routeName: (context) => const EditStoreScreen(),
          SearchScreen.routeName: (context) => const SearchScreen(),
          MyInvoices.routeName: (context) => const MyInvoices(),
          Complaints.routeName: (context) => const Complaints(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
