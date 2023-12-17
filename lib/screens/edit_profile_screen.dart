// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/auth_api.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/widgets/login_button.dart';

import '../widgets/custom_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = 'edit_profile_screen';
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  String? userName;
  String? mobileNo;
  String? eMail;
  final mobileNode = FocusNode();
  final nameNode = FocusNode();
  final mailNode = FocusNode();
  bool isLoading = false;
  void saveForm() {
    _form.currentState!.validate();
    bool valid = _form.currentState!.validate();
    if (valid) {
      _form.currentState!.save();
      setState(() {
        isLoading = true;
      });
      AuthApi()
          .editProfile(
        context: context,
        userName: userName,
        mobile: mobileNo,
        eMail: eMail,
      )
          .catchError((e) {
        print(e);
        showErrorBar(context);
      }).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل بيانات الحساب'),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: _form,
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CustomFormField(
                        focusNode: mobileNode,
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
                            mobileNo = value;
                          });
                        },
                        onSubmitted: (String? value) {
                          setState(() {
                            mobileNo = value;
                          });
                          FocusScope.of(context).requestFocus(nameNode);
                        },
                        onSaved: (String? value) {
                          setState(() {
                            mobileNo = value;
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
                            return 'أدخل إسم المستخدم';
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
                          FocusScope.of(context).requestFocus(mailNode);
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
                        focusNode: mailNode,
                        labelText: 'البريد الإلكتروني',
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'أدخل البريد الإلكتروني';
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
                    LogInButton(
                      text: 'تعديل',
                      onTap: () {
                        saveForm();
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
