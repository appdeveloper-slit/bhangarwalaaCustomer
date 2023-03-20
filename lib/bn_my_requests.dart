import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'request_details_cancelled.dart';
import 'request_details_completed.dart';
import 'request_details_processing.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class MyRequest extends StatefulWidget {
  final spage;

  const MyRequest({super.key, this.spage});

  @override
  State<MyRequest> createState() => _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
  late BuildContext ctx;
  String? sUserid;
  List<dynamic> requestList = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getMyRequest();
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
    return WillPopScope(
      onWillPop: () async {
        widget.spage == 'place request'
            ? STM().finishAffinity(ctx, Home())
            : Navigator.pop(ctx);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 1),
        appBar: AppBar(
          backgroundColor: Clr().primaryColor,
          leading: InkWell(
            onTap: () {
              widget.spage == 'place request'
                  ? STM().finishAffinity(ctx, Home())
                  : Navigator.pop(ctx);
            },
            child: Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: SvgPicture.asset(
                'assets/back_arrow.svg',
                color: Clr().white,
              ),
            ),
          ),
          title: Text('My Requests'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              requestList.length == 0
                  ? Container(
                      height: MediaQuery.of(ctx).size.height / 1.4,
                      child: Center(
                        child: Text(
                          'No Request Found',
                          style: Sty().mediumBoldText,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: requestList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            STM().redirect2page(
                                ctx,
                                RequestDetailsProcessing(
                                  id: requestList[index]['id'].toString(),
                                ));
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d20),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: Dim().d80,
                                    width: Dim().d80,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(Dim().d12),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(Dim().d12),
                                        child: requestList[index]['image_path'].toString().contains(".svg") ? SvgPicture.network(
                                          '${requestList[index]['image_path'].toString()}',
                                          fit: BoxFit.contain,
                                        ) : Image.network(
                                          '${requestList[index]['image_path'].toString()}',
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:Dim().d180,
                                        child: Text(
                                          '${requestList[index]['request_id'].toString()}',
                                          overflow: TextOverflow.fade,
                                          style: Sty().largeText.copyWith(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width:Dim().d180,
                                        child: Text(
                                          '${requestList[index]['pickup_date'].toString()}',
                                          overflow: TextOverflow.fade,
                                          style: Sty().mediumText.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Clr().grey),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width:Dim().d180,
                                        child: Text(
                                          '${requestList[index]['status_text'].toString()}',
                                          overflow: TextOverflow.fade,
                                          style: Sty().smallText.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: requestList[index]
                                                            ['status_text'] ==
                                                        'Requested'
                                                    ? Clr().blue
                                                    : requestList[index]
                                                                ['status_text'] ==
                                                            'Completed'
                                                        ? Clr().primaryColor
                                                        : requestList[index][
                                                                    'status_text'] ==
                                                                'Cancelled'
                                                            ? Clr().errorRed
                                                            : Clr().blue,
                                              ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    );
  }

  void getMyRequest() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'get_my_requests', body);
    var success = result['success'];
    if (success) {
      setState(() {
        requestList = result['requests'];
      });
    }
  }
}
