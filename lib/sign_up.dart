import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'manage/static_method.dart';

import 'sign_in.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';
import 'verification.dart';

void main() => runApp(SignUp());

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return  Scaffold(
      backgroundColor: Clr().white,
      appBar: AppBar(
        backgroundColor: Clr().white,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              STM().back2Previous(ctx);
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SvgPicture.asset('assets/back_arrow.svg'),
            )),
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
                child: Text('Create account',
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
                  'Fill the detail to create account',
                  style: TextStyle(color: Clr().black),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: EdgeInsets.only(right: Dim().d12, left: Dim().d12),
                child: TextFormField(
                  controller: nameCtrl,
                  cursorColor: Clr().grey,
                  cursorWidth: 2,
                  cursorHeight: 28,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                    counterText: "",
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0xff787882),
                      fontFamily: 'Outfit',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(right: Dim().d12, left: Dim().d12),
                child: TextFormField(
                  controller: mobileCtrl,
                  maxLength: 10,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (value.length != 10) {
                      return 'Digits must be 10';
                    }
                  },
                  keyboardType: TextInputType.number,
                  cursorColor: Clr().grey,
                  cursorWidth: 2,
                  cursorHeight: 28,
                  decoration: Sty().TextFormFieldUnderlineStyle.copyWith(
                    counterText: "",
                    hintText: 'Mobile Number',
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Color(0xff787882),
                      fontFamily: 'Outfit',
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
                      if (formKey.currentState!.validate()) {
                        STM().checkInternet(context, widget).then((value) {
                          if (value) {
                            signup();
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Sign Up',
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
                  STM().redirect2page(ctx, SignIn());
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: Sty().smallText.copyWith(
                      fontSize: 16,
                      color: Clr().grey,
                      fontWeight: FontWeight.w400,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign In',
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

  //Api Method
  void signup() async {
    //Input
    FormData body = FormData.fromMap({
      'type':'user',
      'page_type': "register",
      'mobile': mobileCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "sendOTP", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      STM().redirect2page(
        ctx,
        OtpVerification("register", mobileCtrl.text, nameCtrl.text),
      );
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
    }
  }
}
