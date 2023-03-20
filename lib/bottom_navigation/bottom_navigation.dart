import 'package:flutter/material.dart';
import 'package:quick_room_services/bn_my_profile.dart';
import 'package:quick_room_services/bn_my_requests.dart';
import '../bn_home.dart';
import '../manage/static_method.dart';
import '../ratelist.dart';
import '../values/colors.dart';

Widget bottomBarLayout(ctx, index) {
  return BottomNavigationBar(
    elevation: 2,
    backgroundColor: Clr().primaryColor,
    selectedItemColor: Clr().white,
    unselectedItemColor: Color(0xff25015D),
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    onTap: (i) async {
      switch (i) {
        case 0:
          STM().finishAffinity(ctx, Home());
          break;
        case 1:
         index == 1 ?  STM().replacePage(ctx, MyRequest()): STM().redirect2page(ctx, MyRequest());
          break;
        case 2:
         index == 2 ?  STM().replacePage(ctx,  RateList()) : STM().redirect2page(ctx,  RateList());
          break;
        case 3:
         index == 3 ? STM().replacePage(ctx,  MyProfile()) : STM().redirect2page(ctx,  MyProfile());
          break;
      }
    },
    items: STM().getBottomList(index),
  );
}