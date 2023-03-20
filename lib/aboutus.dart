import 'package:flutter/material.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/manage/static_method.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/styles.dart';

import 'values/dimens.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(onWillPop: () async{
      STM().finishAffinity(ctx, Home());
      return false;
    },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          backgroundColor: Clr().primaryColor,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, Home());
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Clr().white,
            ),
          ),
          centerTitle: true,
          title: Text(
            'About Us',
            style: Sty().largeText.copyWith(
                color: Clr().white, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dim().d20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dim().d60,
                ),
                Text(
                  'About Us',
                  style: Sty().mediumBoldText,
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                Text(
                  "Bhangarwalaa is a secured online platform which allows a user to book sale pick up call of any type of scrap, hassle free. You have the convenience of booking a pick up call through our website or mobile App (android and ios) at your convenient date and time slot. Our Scrap Hero (duly verified) will come on assigned date at your doorstep free of cost and buy all scrap available (conditions apply) at a pre-defined rate list available on our website as well as our mobile App. All weighment will be done through digital weighing scale. Payments will be made to you through mobile wallet. You have the option to donate the scrap as well which will contribute to various social activities that we will conduct from time to time. Our promotions will be visible in various online modes online. So, you can sell all your scrap, tension free.\n\nIt is intended to recycle, reuse, reduce up-cycle and resell the scrap.it is a platform for the residents to participate in responsible waste management and is best in class technology, logistics to process the scrap.\n\n\nFounders Message\n\nDo you know who are the co-founders of Bhangarwalaa?\n\n\nNadim Shaikh , 32 years old &\nSameer Shaikh, 30 years old\nentrepreneur working in the field of scrap management since 2009.\n\n What next, in order to bring professionalism & transperancy in this field and to complete the supply chain in legitimate way, Sameer Shaikh joined hands with his Brother’s Nadim Shaikh, who are also experts in same field of waste management from last decade who decided to make “Bhangarwalaa”which can provide an online platform for community to give any type of scrap material for recycling so that the whole transaction giving scrap which is today cumbersome can become an easy and ejoyable experience. This is their contribution towards Swatch Bharat Abhiyaan.\n\nBHANGAR BECHO, SHAAN SE.",
                  style: Sty().mediumBoldText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
