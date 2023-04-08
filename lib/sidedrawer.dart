import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_room_services/aboutus.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/scrap_impact.dart';
import 'package:quick_room_services/sign_in.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bankdetails.dart';
import 'bn_my_profile.dart';
import 'bn_my_requests.dart';
import 'contact_us.dart';

Widget navbar(context, key) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (key.currentState.isDrawerOpen) {
          key.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: 300,
        backgroundColor: Clr().white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/homelogo.png',
                width: Dim().d240,
                height: Dim().d200,
                fit: BoxFit.cover,
              ),
              GestureDetector(
                onTap: () {
                  STM().finishAffinity(context, Home());
                  close(key);
                },
                child: Container(
                  margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                  // decoration: BoxDecoration(color: Color(0xffABE68C)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/home.svg'),
                    title: Text(
                      'Home',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  STM().redirect2page(context, MyProfile());
                  close(key);
                },
                child: Container(
                  margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                  // decoration: BoxDecoration(color: Color(0xffE683F0)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/my_profile.svg'),
                    title: Text(
                      'My Profile',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ), //
                  ),
                ), 
              ),
              SizedBox(
                height: Dim().d4,
              ),
              GestureDetector(
                onTap: () {
                  STM().redirect2page(context, BankDetails());
                  close(key);
                },
                child: Container(
                  margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                  // decoration: BoxDecoration(color: Color(0xffE683F0)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/bank.svg'),
                    title: Text(
                      'Bank Details',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ), //
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Container(
                margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                // decoration: BoxDecoration(color: Color(0xffF1B382)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/privacy_policy.svg'),
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    STM().openWeb('https://bhangarwalaa.com/privacy-policy');
                  },
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Container(
                margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                // decoration: BoxDecoration(color: Color(0xff828AEF)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/terms_conditions.svg'),
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    STM().openWeb('https://bhangarwalaa.com/terms-conditions');
                  },
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Container(
                margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                // decoration: BoxDecoration(color: Color(0xffFFB173)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/share.svg'),
                  title: Text(
                    'Share App',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    var message = 'Download The Bhangarwalaa App from below link\n\nhttps://play.google.com/store/apps/details?id=com.bhangar.walaa';
                    Share.share(message);
                  },
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Container(
                margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                // decoration: BoxDecoration(color: Color(0xff269BFD)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/about.svg'),
                  title: Text(
                    'About Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    STM().replacePage(context, AboutUs());
                    close(key);
                  },
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Container(
                margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                // decoration: BoxDecoration(color: Color(0xff269BFD)),
                child: ListTile(
                  leading: SvgPicture.asset('assets/contact.svg'),
                  title: Text(
                    'Contact Us',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    STM().replacePage(context, ContactUs());
                    close(key);
                  },
                ),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              InkWell(
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setBool('is_login', false);
                  sp.clear();
                  STM().finishAffinity(context, SignIn());
                  close(key);
                },
                child: Container(
                  margin: EdgeInsets.only(right: Dim().d20, left: Dim().d20),
                  // decoration: BoxDecoration(color: Color(0xff82BEF0)),
                  child: ListTile(
                    leading: SvgPicture.asset('assets/log_out.svg'),
                    title: Text(
                      'Log Out',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}
