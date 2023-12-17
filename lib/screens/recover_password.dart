import 'package:flutter/material.dart';
import 'package:gomla/classes/auth_api.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/screens/change_password.dart';
import 'package:gomla/widgets/custom_form_field.dart';
import 'package:gomla/widgets/login_button.dart';

class PasswordRecvovery extends StatefulWidget {
  static const routeName = 'recover_password';
  const PasswordRecvovery({Key? key}) : super(key: key);

  @override
  State<PasswordRecvovery> createState() => _PasswordRecvoveryState();
}

class _PasswordRecvoveryState extends State<PasswordRecvovery> {
  String? phoneNo;
  final AuthApi _api = AuthApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('استرجاع كلمة السر')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: [
            Center(
              child: Text(
                'من فضلك أدخل رقم الهاتف المسجل لهذا الحساب',
                style: commonTextStyle.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CustomFormField(
                labelText: 'أدخل رقم الهاتف',
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onChanged: (String? value) {
                  setState(() {
                    phoneNo = value;
                  });
                },
                onSaved: (String? value) {
                  setState(() {
                    phoneNo = value;
                  });
                },
              ),
            ),
            LogInButton(
              text: 'ارسال',
              onTap: () {
                _api.forgotPassWord(context, phoneNo).catchError((e) {
                  showErrorBar(context);
                  return;
                }).then((_) =>
                    Navigator.of(context).pushNamed(ChangePassword.routeName));
              },
            ),
          ],
        ),
      ),
    );
  }
}
