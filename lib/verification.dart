import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/strings.dart';
import 'values/styles.dart';

// void main() => runApp(OtpVerification());

class OtpVerification extends StatefulWidget {
  final String sType, sMobile, sName;
  const OtpVerification(this.sType, this.sMobile, this.sName,
      {Key? key})
      : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  late BuildContext ctx;

  bool again = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'OTP Verification',
                style: TextStyle(
                    color: Clr().primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Code has sent to +91 ${widget.sMobile}',
                style: TextStyle(color: Clr().grey),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            PinCodeTextField(
              controller: otpCtrl,
              errorAnimationController: errorController,
              appContext: context,
              enableActiveFill: true,
              textStyle: Sty().largeText.copyWith(color: Clr().secondary),
              length: 4,
              obscureText: false,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              animationType: AnimationType.scale,
              cursorColor: Clr().grey,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                // borderRadius: BorderRadius.circular(Dim().d4),
                fieldWidth: Dim().d60,
                fieldHeight: Dim().d56,
                selectedFillColor: Clr().transparent,
                activeFillColor: Clr().transparent,
                inactiveFillColor: Clr().transparent,
                inactiveColor: Clr().black,
                activeColor: Clr().black,
                selectedColor: Clr().black,
              ),
              animationDuration: const Duration(milliseconds: 200),
              onChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty || !RegExp(r'(.{4,})').hasMatch(value)) {
                  return "";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Haven’t received the verification code?',
              style: Sty().smallText.copyWith(
                fontSize: 16,
                color: Clr().grey,
                fontWeight: FontWeight.w400,
                fontFamily: 'Outfit',
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Column(
              children: [
                Visibility(
                  visible: !again,
                  child: TweenAnimationBuilder<Duration>(
                      duration: const Duration(seconds: 60),
                      tween: Tween(
                          begin: const Duration(seconds: 60),
                          end: Duration.zero),
                      onEnd: () {
                        // ignore: avoid_print
                        // print('Timer ended');
                        setState(() {
                          again = true;
                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Re-send code in $minutes:$seconds",
                            textAlign: TextAlign.center,
                            style:
                            Sty().mediumText.copyWith(color: Clr().black),
                          ),
                        );
                      }),
                ),
                // Visibility(
                //   visible: !isResend,
                //   child: Text("I didn't receive a code! ${(  sTime  )}",
                //       style: Sty().mediumText),
                // ),
                Visibility(
                  visible: again,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        again = false;
                      });
                      resendOTP(widget.sMobile);
                      // STM.checkInternet().then((value) {
                      //   if (value) {
                      //     sendOTP();
                      //   } else {
                      //     STM.internetAlert(ctx, widget);
                      //   }
                      // });
                    },
                    child: Text(
                      'Resend OTP',
                      style: Sty().mediumText.copyWith(color: Clr().black),
                    ),
                  ),
                ),
              ],
            ),
            // Column(
            //   children: [
            //     Visibility(
            //       visible: !again,
            //       child: TweenAnimationBuilder<Duration>(
            //           duration: const Duration(seconds: 60),
            //           tween: Tween(
            //               begin: const Duration(seconds: 60),
            //               end: Duration.zero),
            //           onEnd: () {
            //             // ignore: avoid_print
            //             // print('Timer ended');
            //             setState(() {
            //               again = true;
            //             });
            //           },
            //           builder: (BuildContext context,
            //               Duration value, Widget? child) {
            //             final minutes = value.inMinutes;
            //             final seconds = value.inSeconds % 60;
            //             return Padding(
            //               padding: const EdgeInsets.symmetric(
            //                   vertical: 5),
            //               child: Text(
            //                 "$minutes:$seconds",
            //                 textAlign: TextAlign.center,
            //                 style: Sty().mediumText,
            //               ),
            //             );
            //           }),
            //     ),
            //     // Visibility(
            //     //   visible: !isResend,
            //     //   child: Text("I didn't receive a code! ${(  sTime  )}",
            //     //       style: Sty().mediumText),
            //     // ),
            //     Visibility(
            //       visible: again,
            //       child: GestureDetector(
            //         onTap: () {
            //           setState(() {
            //             again = false;
            //           });
            //           // STM.checkInternet().then((value) {
            //           //   if (value) {
            //           //     sendOTP();
            //           //   } else {
            //           //     STM.internetAlert(ctx, widget);
            //           //   }
            //           // });
            //         },
            //         child: Text(
            //           'OTP पुन्हा पाठवा',
            //           style: Sty().mediumBoldText,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 55,
              child: ElevatedButton(
                  onPressed: () {
                    if (otpCtrl.text.length == 4) {
                      widget.sType == 'login'? verifyOTP() : registerVerifyOTP();
                    } else {
                      STM().displayToast("Please Enter 4 digit OTP");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Verify',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void registerVerifyOTP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Input
    FormData body = FormData.fromMap({
      'type':'user',
      'page_type': 'register',
      'mobile': widget.sMobile,
      'name': widget.sName,
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().verifying, "verifyOTP", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      sp.setBool('is_login', true);
      sp.setString('user_id', result['user']['id'].toString());
      STM().finishAffinity(ctx, Home());
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
      // _showSuccessDialog(ctx,message);
    }
  }
  void resendOTP(smobile) async {
    //Input
    FormData body = FormData.fromMap({
      'mobile': smobile,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resendOTP", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
      // _showSuccessDialog(ctx,message);
    }
  }
  // Api Method
  void verifyOTP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Input
    FormData body = FormData.fromMap({
      'type':'user',
      'page_type': 'login',
      'mobile': widget.sMobile,
      'otp': otpCtrl.text,
    });
    //Output
    var result = await STM().post(ctx, Str().verifying, "verifyOTP", body);
    if (!mounted) return;
    var success = result['success'];
    if (success) {
      sp.setBool('is_login', true);
      sp.setString('user_id', result['user']['id'].toString());
      STM().finishAffinity(ctx, Home());
      STM().displayToast('Login Successfully');
    } else {
      var message = result['message'];
      STM().errorDialog(ctx, message);
      // _showSuccessDialog(ctx,message);
    }
  }
}
