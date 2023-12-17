// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/auth_api.dart';

import '../constants.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/login_button.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = 'change_password';
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _form = GlobalKey<FormState>();
  final AuthApi _api = AuthApi();
  String? newPassWord;
  String? oldPassWord;
  bool showPassWord = false;
  bool showOldPassWord = false;
  bool isLoading = false;

  void saveForm() {
    _form.currentState!.validate();
    bool valid = _form.currentState!.validate();
    if (valid) {
      _form.currentState!.save();
      setState(() {
        isLoading = true;
      });

      _api.changePassWord(context, oldPassWord!, newPassWord!).catchError((e) {
        print(e);
        showErrorBar(context);
        return;
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
        title: const Text('تغيير كلمة السر'),
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
                    Center(
                      child: Text(
                        'من فضلك أدخل كلمة سر جديدة لهذا الحساب',
                        style: commonTextStyle.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CustomFormField(
                        labelText: 'أدخل كلمة السر القديمة',
                        textInputAction: TextInputAction.done,
                        obscure: showOldPassWord == true ? false : true,
                        maxLines: 1,
                        suffixIconButton: IconButton(
                            onPressed: () {
                              setState(() {
                                showOldPassWord == false
                                    ? showOldPassWord = true
                                    : showOldPassWord = false;
                              });
                            },
                            icon: Icon(
                              showOldPassWord == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            )),
                        onChanged: (String? value) {
                          setState(() {
                            oldPassWord = value;
                          });
                        },
                        onSaved: (String? value) {
                          setState(() {
                            oldPassWord = value;
                          });
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك أدخل كلمة السر القديمة';
                          } else if (value.length < 3) {
                            return 'كلمة السر لا تقل عن 8 حروف';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: CustomFormField(
                        labelText: 'أدخل كلمة السر الجديدة',
                        textInputAction: TextInputAction.done,
                        obscure: showPassWord == true ? false : true,
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
                            )),
                        onChanged: (String? value) {
                          setState(() {
                            newPassWord = value;
                          });
                        },
                        onSaved: (String? value) {
                          setState(() {
                            newPassWord = value;
                          });
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'من فضلك أدخل كلمة السر القديمة';
                          } else if (value.length < 8) {
                            return 'كلمة السر لا تقل عن 8 حروف';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    LogInButton(
                      text: 'تغيير كلمة السر',
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
