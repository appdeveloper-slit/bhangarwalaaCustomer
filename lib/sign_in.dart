import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'manage/static_method.dart';
import 'sign_up.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'verification.dart';
void main() => runApp(SignIn());

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late BuildContext ctx;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        backgroundColor: Clr().white,
        elevation: 0,

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Sign In',
                    style: TextStyle(
                        fontSize: 24,
                        color: Clr().primaryColor,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 12,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fill the detail to sign in account',
                  style: TextStyle(color: Clr().black),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.only(right: Dim().d12, left: Dim().d12),
                child: TextFormField(
                  controller: mobileCtrl,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(value)) {
                      return Str().invalidMobile;
                    } else {
                      return null;
                    }
                  },
                  cursorColor: Clr().grey,
                  cursorWidth: 2,
                  cursorHeight: 28,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0xff787882),
                      fontFamily: 'Outfit',
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dim().d0,
                      vertical: Dim().d2,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Clr().grey,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Clr().grey,
                      ),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Clr().errorRed,
                      ),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Clr().errorRed,
                      ),
                    ),
                    errorStyle: TextStyle(
                      fontFamily: 'outfit',
                      letterSpacing: 0.5,
                      color: Clr().errorRed,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 300,
                height: 55,
                child: ElevatedButton(
                    onPressed: () {
                      // STM().redirect2page(ctx, OtpVerification());
                      if (formKey.currentState!.validate()) {
                        STM().checkInternet(context, widget).then((value) {
                          if (value) {
                            sendOTP();
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Send OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  STM().redirect2page(ctx, SignUp());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don’t have an account? ',
                    style: Sty().smallText.copyWith(
                      fontSize: 16,
                      color: Clr().grey,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style: Sty().smallText.copyWith(
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: 'Outfit',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Api Method
  void sendOTP() async {
    //Input
    FormData body = FormData.fromMap({
      'type':'user',
      'page_type': "login",
      'mobile': mobileCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "sendOTP", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      STM().redirect2page(
        ctx,
        OtpVerification("login", mobileCtrl.text,''),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
}
