// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/auth_api.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/widgets/login_button.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class ActivationScreen extends StatefulWidget {
  static const routeName = 'activation_screen';

  const ActivationScreen({Key? key}) : super(key: key);

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String? userOTP;
  bool? isLoading;
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
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'images/logo.png',
                      height: 200,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'تفعيل الحساب',
                        style: commonTextStyle.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        'ادخل كود التفعيل الذي وصل اليك في رساله نصية',
                        style: commonTextStyle.copyWith(
                          color: const Color(0xFFF6AFAF),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width - 40,
                        fieldWidth: 50,
                        outlineBorderRadius: 20,
                        otpFieldStyle: OtpFieldStyle(
                          backgroundColor: Colors.white,
                          borderColor: Colors.white,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldStyle: FieldStyle.box,
                        onCompleted: (pin) {
                          setState(() {
                            userOTP = pin;
                          });
                        },
                      ),
                    ),
                    LogInButton(
                      text: 'تفعيل الحساب',
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        AuthApi().checkOTP(userOTP).catchError((e) {
                          print(e);
                          setState(() {
                            isLoading = false;
                          });
                          showErrorBar(context);
                          return;
                        }).then((_) {
                          setState(() {
                            isLoading = false;
                          });
                          showMyBar(context, 'تمت العملية بنجاح');
                        });
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     LogInScreen.routeName, (route) => false);
                      },
                    ),
                    Center(
                      child: Text(
                        'إعادة إرسال كود التفعيل',
                        style: commonTextStyle.copyWith(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
//  Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   SizedBox(
//                     height: 100,
//                     width: 50,
//                     child: TextFormField(
//                       decoration: const InputDecoration(
//                         enabled: true,
//                         filled: true,
//                         fillColor: Colors.white,
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.white,
//                           ),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(20),
//                           ),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.red,
//                           ),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(20),
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.white,
//                           ),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(20),
//                           ),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.red,
//                           ),
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(20),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),