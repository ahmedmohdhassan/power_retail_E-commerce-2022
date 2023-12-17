// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gomla/classes/user.dart';
import 'package:gomla/screens/activation_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/home_screen.dart';

class AuthApi {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// Register Api Call
  Future<void> register({
    String? userName,
    String? mobileNo,
    String? passWord,
    String? eMail,
    String? fbToken,
  }) async {
    String url = 'https://eatdevelopers.com/market/api_cart/api.php?register=1';

    var body = {
      'c_username': userName,
      'c_mobile': mobileNo,
      'c_password': passWord,
      'c_email': eMail,
      'c_firebase_token': fbToken,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        body: body,
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == 'Success') {
          print('Success');
          SharedPreferences _pref = await SharedPreferences.getInstance();
          _pref.setString('user_id', jsonData['Clients_id'].toString());
        }
      }
    } catch (e) {
      print(e);
    }
  }

// LOG IN Api Call
  Future<void> loggingIn(
      BuildContext? context, String? mob, String? pass) async {
    String? fBToken;
    SharedPreferences pref = await SharedPreferences.getInstance();
    fBToken = pref.getString('firebase_token');
    print(fBToken);
    try {
      String url = 'https://eatdevelopers.com/market/api_cart/api.php?login=1';

      var body = {
        'clients_mobile': mob,
        'clients_password': pass,
        'clients_firebase': fBToken
      };
      if (fBToken != null) {
        var response = await http.post(Uri.parse(url), body: body);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData['result'] == 'Success') {
            var user = User(
              id: '${jsonData['Clients_id']}',
              groupId: '${jsonData['Clients_group_id']}',
              userName: '${jsonData['Clients_username']}',
              userMobile: '${jsonData['Clients_mobile']}',
              userEmail: '${jsonData['Clients_email']}',
              userToken: '${jsonData['Clients_token']}',
              userType: '${jsonData['Clients_type']}',
            );
            SharedPreferences _pref = await SharedPreferences.getInstance();
            _pref.setString('user_id', user.id!);
            _pref.setString('user_group_id', user.groupId!);
            _pref.setString('user_Token', user.userToken!);
            _pref.setString('user_type', user.userType!);

            firebaseMessaging.subscribeToTopic('full');
            Navigator.of(context!)
                .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
            print(user.id!);
          } else {
            showErrorBar(context!);
          }
        } else {
          showErrorBar(context!);
        }
      }
    } catch (e) {
      print(e);
    }
  }

//CHANGE PASSWORD API CALL:

  Future<void> changePassWord(
      BuildContext context, String oldPassWord, String newPassWord) async {
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php?changePassword=1';

    String? userId;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    userId = _pref.getString('user_id');
    print(userId);

    var body = {
      'Clients_id': userId,
      'Clients_old_password': oldPassWord,
      'Clients_new_password': newPassWord,
    };
    try {
      if (userId != null) {
        var response = await http.post(Uri.parse(url), body: body);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData == "Success") {
            showMyBar(context, 'تم تغيير كلمة السر بنجاح');
          }
        } else {
          showErrorBar(context);
        }
      }
    } catch (e) {
      showErrorBar(context);
      print(e);
    }
  }

// UPDATE PROFILE DATA:

  Future editProfile(
      {BuildContext? context,
      String? userName,
      String? mobile,
      String? eMail}) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String id = _pref.getString('user_id')!;

    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?changeProfile=1&Clients_id=$id&Clients_username=$userName&Clients_mobile=$mobile&Clients_id=$id&Clients_email=$eMail';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == "Success") {
          showMyBar(context!, 'تم التعديل بنجاح');
        } else {
          showErrorBar(context!);
        }
      }
    } catch (e) {
      print(e);
    }
  }

//FORGET MY PASSWORD API CALL:

  Future<void> forgotPassWord(BuildContext context, String? mobileNo) async {
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php?forgotPasswordask=1&mobile=$mobileNo';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == "Success") {
          Navigator.of(context).pushNamed(ActivationScreen.routeName);
        } else {
          showErrorBar(context);
        }
      } else {
        showErrorBar(context);
      }
    } catch (e) {
      print(e);
    }
  }

// UPDATE STORE PROFILE:

  Future<void> updateStoreProfile(
      BuildContext context,
      String storeName,
      double lat,
      double long,
      String mobile,
      String address,
      String location) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String id = _pref.getString('user_id')!;

    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?changeProfilestore=1&Clients_id=$id&Clients_store_name=$storeName&Clients_store_latitude=$lat&Clients_store_longitude=$long&Clients_store_mobile=$mobile&Clients_store_address=$address&Clients_store_location=$location';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == "Success") {
          showMyBar(context, 'تم التعديل بنجاح');
        } else {
          showErrorBar(context);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkOTP(String? otp) async {
    String? userId;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    userId = _pref.getString('user_id');

    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php?chkotpupdate=1');

    if (userId != null) {
      try {
        var body = {'Clients_id': userId, 'chk_otp': otp};

        var response = await http.post(url, body: body);
        print(response.body);
      } catch (e) {
        print(e);
      }
    }
  }
}
