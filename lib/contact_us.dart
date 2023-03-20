import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/values/styles.dart';

import 'values/colors.dart';
import 'values/dimens.dart';

void main() => runApp(ContactUs());

class ContactUs extends StatefulWidget {
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Clr().primaryColor,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, Home());
            },
            child: Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: SvgPicture.asset(
                'assets/back_arrow.svg',
                color: Clr().white,
              ),
            ),
          ),
          title: Text('Contact Us'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Card(
                child: Column(
                  children: [
                    Image.asset('assets/contact_banner.png'),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Contact Information',
                      style: Sty()
                          .largeText
                          .copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text('Have any query contact us',
                        style: Sty().microText.copyWith(
                              fontWeight: FontWeight.w400,
                            )),
                    SizedBox(height: 20),
                    SvgPicture.asset('assets/phone.svg'),
                    SizedBox(
                      height: 4,
                    ),
                    Text('+91 9222822212'),
                    SizedBox(height: 20),
                    SvgPicture.asset('assets/mail.svg'),
                    Text('contactus@bhangarwalaa.com'),
                    SizedBox(height: 20),
                    SvgPicture.asset('assets/location.svg'),
                    SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            'Wagle Industry Estate, Road no.34, Thane(W), 400604'),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
