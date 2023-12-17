import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color blue = Color(0xFF2371c0);

const Color amber = Color(0xFFFC9000);

const TextStyle commonTextStyle = TextStyle(
  fontFamily: 'Cairo',
  color: Colors.white,
  fontSize: 15,
  fontWeight: FontWeight.bold,
);

void showErrorBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      duration: Duration(seconds: 3),
      content: Text(
        'خطأ في الإتصال ...',
        textDirection: TextDirection.rtl,
      )));
}

void showMyBar(BuildContext context, String? content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(
        content!,
        textDirection: TextDirection.rtl,
      )));
}

void signOut() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString('user_id', 'null');
}
