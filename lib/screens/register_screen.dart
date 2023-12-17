// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/auth_api.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/screens/activation_screen.dart';
import 'package:gomla/widgets/custom_form_field.dart';
import 'package:gomla/widgets/login_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register_screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthApi _api = AuthApi();
  final _form = GlobalKey<FormState>();
  final phoneNode = FocusNode();
  final passwordNode = FocusNode();
  final nameNode = FocusNode();
  final eMailNode = FocusNode();

  String? phoneNo;
  String? password;
  String? userName;
  String? eMail;
  String? fbToken;
  bool isLoading = false;
  bool showPassWord = false;
  void getFBToken() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      fbToken = _pref.getString('firebase_token');
    });
    print(fbToken);
  }

  @override
  void initState() {
    getFBToken();
    super.initState();
  }

  @override
  void dispose() {
    phoneNode.dispose();
    passwordNode.dispose();
    nameNode.dispose();
    eMailNode.dispose();
    super.dispose();
  }

  void saveForm() {
    _form.currentState!.validate();
    bool valid = _form.currentState!.validate();
    if (valid == true) {
      setState(() {
        isLoading = true;
      });
      _form.currentState!.save();
      _api
          .register(
              userName: userName,
              mobileNo: phoneNo,
              passWord: password,
              eMail: eMail,
              fbToken: fbToken)
          .catchError((e) {
        setState(() {
          isLoading = false;
        });
        print(e);
        showErrorBar(context);
        return;
      }).then((_) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushNamed(ActivationScreen.routeName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(
              'images/backgroundblue.png',
            ),
          ),
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Form(
              key: _form,
              child: isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              'إنشاء حساب جديد',
                              style: commonTextStyle.copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: CustomFormField(
                            focusNode: passwordNode,
                            labelText: 'كلمة المرور',
                            textInputAction: TextInputAction.next,
                            obscure: showPassWord == false ? true : false,
                            maxLines: 1,
                            suffixIconButton: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassWord == false
                                      ? showPassWord = true
                                      : showPassWord = false;
                                });
                              },
                              icon: Icon(
                                showPassWord == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'أدخل كلمة المرور';
                              } else if (value.length < 8) {
                                return 'كلمة المرور لا تقل عن 8 حروف';
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
                              FocusScope.of(context).requestFocus(nameNode);
                            },
                            onSaved: (String? value) {
                              setState(() {
                                password = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: CustomFormField(
                            focusNode: nameNode,
                            labelText: 'اسم المستخدم',
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'أدخل اسم المستخدم';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String? value) {
                              setState(() {
                                userName = value;
                              });
                            },
                            onSubmitted: (String? value) {
                              setState(() {
                                userName = value;
                              });
                              FocusScope.of(context).requestFocus(eMailNode);
                            },
                            onSaved: (String? value) {
                              setState(() {
                                userName = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: CustomFormField(
                            focusNode: eMailNode,
                            labelText: 'البريد الالكتروني',
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'أدخل البريد الالكتروني';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (String? value) {
                              setState(() {
                                eMail = value;
                              });
                            },
                            onSubmitted: (String? value) {
                              setState(() {
                                eMail = value;
                              });
                            },
                            onSaved: (String? value) {
                              setState(() {
                                eMail = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: LogInButton(
                            text: 'إنشاء الحساب',
                            onTap: () {
                              saveForm();
                              // Navigator.of(context)
                              //     .pushNamed(ActivationScreen.routeName);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'الرجوع لتسجيل الدخول',
                                style: commonTextStyle.copyWith(fontSize: 20),
                              ),
                            ),
                          ),
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
