import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/widgets/custom_form_field.dart';
import 'package:gomla/widgets/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Complaints extends StatefulWidget {
  static const routeName = 'compalaints_suggestions';
  const Complaints({Key? key}) : super(key: key);

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  Future<void> send(String? message, String? priority) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('user_id')!;

    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?mt_ticket=all&ticket_msg=$message&ticket_case=$priority&ticket_client_id=$userId');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['result'] == '1') {
        showMyBar(context, 'تم ارسال الرسالة الخاصة بك');
      } else {
        showErrorBar(context);
      }
    }
  }

  DropdownButton dropDown() {
    List<DropdownMenuItem> priorityItems = [];
    for (String i in priorityList) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Center(child: Text(i)),
        value: i,
      );
      priorityItems.add(item);
    }
    return DropdownButton(
      items: priorityItems,
      value: priority,
      onChanged: (val) {
        setState(() {
          priority = val;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.blue,
      ),
      isExpanded: true,
      hint: Text(
        'اختر درجة الاهمية',
        style: commonTextStyle.copyWith(
          color: Colors.blueGrey,
        ),
      ),
      underline: const SizedBox(),
      style: commonTextStyle.copyWith(
        color: Colors.blueGrey,
      ),
      itemHeight: 50,
    );
  }

  List<String> priorityList = ['عادي', 'هام', 'هام للغاية'];
  String? messageText;
  String? priority;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشكاوى و المقترحات'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: CustomFormField(
                labelText: 'اكتب رسالتك هنا',
                textInputAction: TextInputAction.done,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'من فضلك ادخل رسالتك اولا';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: dropDown(),
            ),
            LogInButton(
                text: 'ارسال',
                onTap: () {
                  send(messageText, priority);
                }),
          ],
        ),
      ),
    );
  }
}
