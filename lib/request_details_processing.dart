import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'manage/static_method.dart';
import 'package:flutter_html/flutter_html.dart';
import 'bn_my_requests.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class RequestDetailsProcessing extends StatefulWidget {
  final String? id;

  const RequestDetailsProcessing({super.key, this.id});

  @override
  State<RequestDetailsProcessing> createState() =>
      _RequestDetailsProcessingState();
}

class _RequestDetailsProcessingState extends State<RequestDetailsProcessing> {
  late BuildContext ctx;
  List<dynamic> listItem = [];
  List<dynamic> requestStatus = [];
  dynamic resultItem;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getRequest();
      }
    });
  }

  String? sPayment, sImage;
  List<dynamic> paymentList = [
    "Donate the receive amount",
    "Receive payment in Cash"
  ];

  List namelist = [
    'wsdcj',
    'weqdfcej',
    'dqeqjhb',
  ];
  List namelist2 = [
    'fer',
    'erg',
    'erqg',
  ];

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Clr().primaryColor,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
          },
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: SvgPicture.asset(
              'assets/back_arrow.svg',
              color: Clr().white,
            ),
          ),
        ),
        title: Text('Request Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order Details',
                style: Sty().largeText.copyWith(
                    color: Clr().primaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xffDEDEDE))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dim().d12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/scrap.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Scrap items',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Color(0xffDEDEDE)),
                  ListView.builder(
                      itemCount: listItem.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding:
                              EdgeInsets.symmetric(horizontal: Dim().d12),
                              child: Text(
                                '${listItem[index]['name'].toString()}',
                                style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d12),
                                child: Html(
                                  data:
                                  '${listItem[index]['price'].toString()}',
                                )
                              // Text(
                              //   '₹${listItem[index]['price'].toString()}/kg',
                              //   style: Sty().mediumText,
                              // ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Divider(color: Color(0xffDEDEDE)),
                          ],
                        );
                      })
                ],
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/location2.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Address',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${resultItem['address'].toString()}',
                      style: Sty().mediumText,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/calender.svg'),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Pickup Details',
                          style: Sty().mediumBoldText.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking Date',
                              style: Sty().mediumText,
                            ),
                            SizedBox(
                              height: Dim().d4,
                            ),
                            Text('Status', style: Sty().mediumText),
                          ],
                        ),
                        Column(
                          children: [
                            Text(':', style: Sty().mediumText),
                            Text(':', style: Sty().mediumText),
                          ],
                        ),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Dim().d4,
                            ),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    '${resultItem['pickup_date'].toString()}',
                                    style: Sty().mediumText)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${resultItem['status_text'].toString()}',
                                style: Sty().mediumText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: resultItem['status_text'] ==
                                      'Requested'
                                      ? Clr().blue
                                      : resultItem['status_text'] ==
                                      'Completed'
                                      ? Clr().primaryColor
                                      : resultItem['status_text'] ==
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
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(Dim().d16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'OTP',
                        style: Sty().mediumBoldText.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(':',
                        style: Sty()
                            .mediumText
                            .copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('${resultItem['otp'].toString()}',
                                style: Sty()
                                    .mediumText
                                    .copyWith(fontWeight: FontWeight.w500))))
                  ],
                ),
              ),
            ),
            resultItem['instructions'] == null ? Container() : SizedBox(
              height: 16,
            ),
            resultItem['instructions'] == null ? Container() : Text(
              '${resultItem['instructions'].toString()}',
              style: Sty().smallText.copyWith(color: Color(0xff676767)),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              decoration:
              BoxDecoration(border: Border.all(color: Clr().lightGrey)),
              child: Padding(
                padding: EdgeInsets.only(top: Dim().d20, bottom: Dim().d20),
                child: FixedTimeline.tileBuilder(
                  theme: TimelineThemeData(
                    color: Clr().primaryColor,
                    connectorTheme:
                    ConnectorThemeData(color: Color(0xffDEDEDE)),
                    indicatorPosition: 0,
                  ),
                  builder: TimelineTileBuilder.connectedFromStyle(
                    contentsAlign: ContentsAlign.basic,
                    oppositeContentsBuilder: (context, index) => Padding(
                      padding: index != (requestStatus.length - 1)
                          ? EdgeInsets.only(
                          right: Dim().d28, bottom: Dim().d28)
                          : EdgeInsets.only(
                        right: Dim().d28,
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${requestStatus[index]['status_text']}',
                            style: Sty().mediumText.copyWith(
                              fontWeight: FontWeight.w500,
                              color: requestStatus[index]
                              ['status_text'] ==
                                  'Requested'
                                  ? Clr().blue
                                  : requestStatus[index]['status_text'] ==
                                  'Completed'
                                  ? Clr().primaryColor
                                  : requestStatus[index]
                              ['status_text'] ==
                                  'Cancelled'
                                  ? Clr().errorRed
                                  : Clr().blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    contentsBuilder: (context, index) => Padding(
                      padding: index != (requestStatus.length - 1)
                          ? EdgeInsets.only(
                        left: Dim().d28,
                      )
                          : EdgeInsets.only(left: Dim().d28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${requestStatus[index]['date']}'),
                          Text('${requestStatus[index]['time']}'),
                        ],
                      ),
                    ),
                    connectorStyleBuilder: (context, index) =>
                    ConnectorStyle.solidLine,
                    indicatorStyleBuilder: (context, index) =>
                    IndicatorStyle.dot,
                    itemCount: requestStatus.length,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                resultItem['status_text'] == 'Cancelled'
                    ? Container()
                    : resultItem['status_text'] == 'Completed'
                    ? Container()
                    : resultItem['status_text'] == 'In Progress'? Container() : SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () {
                        cancelRequest();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10))),
                      child: Text(
                        'Cancel Request',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void cancelRequest() async {
    FormData body = FormData.fromMap({
      'id': widget.id,
    });
    var result = await STM().post(ctx, Str().canceling, 'cancel_request', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(ctx, message, MyRequest( spage: 'place request',));
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getRequest() async {
    FormData body = FormData.fromMap({
      'id': widget.id,
    });
    var result = await STM().post(ctx, Str().loading, 'get_request', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        listItem = result['request']['items'];
        resultItem = result['request'];
        requestStatus = result['request']['request_statuses'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
