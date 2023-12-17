import 'package:flutter/material.dart';
import 'package:gomla/screens/change_password.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = 'settings_screen';
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: [
            ListTile(
              textColor: Colors.grey[500],
              leading: const Icon(
                Icons.settings,
              ),
              title: const Text('تغيير كلمة السر'),
              onTap: () {
                Navigator.of(context).pushNamed(ChangePassword.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
