// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gomla/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get user => _user!;

  Future<void> getProfileInfo(BuildContext context) async {
    String? userId;

    SharedPreferences _pref = await SharedPreferences.getInstance();
    userId = _pref.getString('user_id');
    if (userId != null) {
      String url =
          'https://eatdevelopers.com/market/api_cart/api.php?getclientsinfo=1&Clients_id=$userId';

      //var body = {'Clients_id': userId};
      try {
        var response = await http.get(Uri.parse(url));
        print(response.statusCode);
        print(response.body);

        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData['result'] != "Error") {
            _user = User(
                id: '${jsonData['Clients_id']}',
                groupId: '${jsonData['Clients_group_id']}',
                userName: jsonData['Clients_username'],
                userMobile: jsonData['Clients_mobile'],
                userEmail: jsonData['Clients_email'],
                userType: '${jsonData['Clients_type']}',
                userAddress: jsonData['Clients_store_address'],
                storeName: jsonData['Clients_store_name'],
                imageUrl: jsonData['Clients_store_photo']);
          } else {
            showErrorBar(context);
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
