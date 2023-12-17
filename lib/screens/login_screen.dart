// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/auth_api.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/screens/recover_password.dart';
import 'package:gomla/screens/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_form_field.dart';
import '../widgets/login_button.dart';
import '../screens/home_screen.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = 'log_in_screen';
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthApi _api = AuthApi();
  final phoneNode = FocusNode();
  final passwordNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String? phoneNo;
  String? password;
  bool showPassWord = false;
  bool? isLoading;

  void saveForm() {
    _form.currentState!.validate();
    bool valid = _form.currentState!.validate();
    if (valid) {
      setState(() {
        isLoading = true;
      });
      _form.currentState!.save();
      _api
          .loggingIn(
        context,
        phoneNo,
        password,
      )
          .catchError((_) {
        showErrorBar(context);
        return;
      }).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  void autoLogIn() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final String? userId = _prefs.getString('user_id');
    print(userId);
    if (userId != 'null') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomePage.routeName,
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    autoLogIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('images/backgroundblue.png'),
          ),
        ),
        child: isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Form(
                    key: _form,
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Image.asset(
                          'images/logo.png',
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: commonTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: CustomFormField(
                            focusNode: phoneNode,
                            labelText: 'رقم الهاتف',
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'أدخل رقم الهاتف';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String? value) {
                              setState(() {
                                phoneNo = value;
                              });
                            },
                            onSubmitted: (String? value) {
                              setState(() {
                                phoneNo = value;
                              });
                              FocusScope.of(context).requestFocus(passwordNode);
                            },
                            onSaved: (String? value) {
                              setState(() {
                                phoneNo = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                          child: CustomFormField(
                            focusNode: passwordNode,
                            labelText: 'كلمة المرور',
                            maxLines: 1,
                            obscure: showPassWord == true ? false : true,
                            suffixIconButton: IconButton(
                              icon: Icon(
                                showPassWord == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassWord == false
                                      ? showPassWord = true
                                      : showPassWord = false;
                                });
                              },
                            ),
                            textInputAction: TextInputAction.done,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'أدخل كلمة المرور';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String? value) {
                              setState(() {
                                password = value;
                              });
                            },
                            onSubmitted: (String? value) {
                              setState(() {
                                password = value;
                              });
                            },
                            onSaved: (String? value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        ),
                        LogInButton(
                          text: 'تسجيل الدخول',
                          onTap: () {
                            saveForm();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(PasswordRecvovery.routeName);
                              },
                              child: const Text(
                                'هل نسيت كلمة المرور؟  اضغط هنا',
                                style: commonTextStyle,
                              ),
                            ),
                          ),
                        ),
                        LogInButton(
                          text: 'إنشاء حساب جديد',
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(RegisterScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
