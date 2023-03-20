import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:magic/manage/static_method.dart';
// import 'add_product.dart';
// import 'bn_my_listing.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

void main() => runApp(Notifications());

class Notifications extends StatefulWidget {
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late BuildContext ctx;
  String? sUserid;
  List<dynamic> notificationlist = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id') ?? "";
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getnotification();
      }
    });
  }

  @override
  void initState() {
    getSession();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(onWillPop: () async {
      STM().finishAffinity(ctx,Home());
      return false;
    },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().primaryColor,
          leading: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: InkWell(
                onTap: () {
                  STM().finishAffinity(ctx,Home());
                },
                child: SvgPicture.asset(
                  'assets/back_arrow.svg',
                  color: Clr().white,
                )),
          ),
          centerTitle: true,
          title: Text(
            'Notification',
            style: Sty().largeText.copyWith(
                color: Clr().white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child:Column(
            children: [
              notificationlist.length == 0 ? Container(
                height: MediaQuery
                    .of(ctx)
                    .size
                    .height / 1.5,
                child: Center(
                  child: Text('No Notifications', style: Sty().mediumBoldText,),
                ),
              ) : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notificationlist.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0.1,
                          blurRadius: 6,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dim().d0, vertical: Dim().d8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dim().d12),
                        side: BorderSide(color: Clr().transparent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 12, left: 20, right: 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment
                            .start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${notificationlist[index]['title'].toString()}',
                                overflow: TextOverflow.fade,
                                style: Sty().largeText.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              '${notificationlist[index]['description']
                                  .toString()}',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Color(0xff747688),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${notificationlist[index]['date'].toString()}',
                                  style: TextStyle(
                                    color: Color(0xff979797),
                                  ),
                                ))
                          ],
                        ),)
                      ,
                    )
                    ,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void getnotification() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(
        ctx, Str().loading, 'get_notifications', body);
    var success = result['success'];
    if (success) {
      setState(() {
        notificationlist = result['notifications'];
        sp.setString('date', DateTime.now().toString());
      });
    }
  }
}
