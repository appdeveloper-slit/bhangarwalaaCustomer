import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/bn_my_profile.dart';
import 'package:quick_room_services/bn_my_requests.dart';
import 'package:quick_room_services/select_item.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

var controller = StreamController<String?>.broadcast();
String? sLocation, sLatitude, sLongitude;
String? sLocation1, sLatitude1, sLongitude1;
bool? click;

class RequestDetails extends StatefulWidget {
  final List<dynamic> alldata;
  final List<dynamic> allids;
  final String? date;
  final List<String> allimages;

  const RequestDetails(this.alldata, this.allids, this.date, this.allimages,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RequestDetailsPage();
  }
}

class RequestDetailsPage extends State<RequestDetails> {
  late BuildContext ctx;
  static StreamController<String?> controller =
      StreamController<String?>.broadcast();

  static StreamController<String?> controller1 =
  StreamController<String?>.broadcast();

  String? sPayment, sImage;
  List<dynamic> paymentList = [
    "Donate the receive amount",
    "Receive payment in Cash"
  ];
  String? sDate;
  String? sUserid,apikey,longitude,latitude;
  dynamic address,pickupaddress;
  TextEditingController _controller = TextEditingController();

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
      apikey = sp.getString('apikey');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getMYProfile();
      }
    });
  }

  @override
  void initState() {
    getSession();
    sDate = widget.date;
    controller.stream.listen(
      (event) {
        setState(() {
          address = event.toString();

        });
      },
    );
    controller1.stream.listen(
          (event) {
        setState(() {
          pickupaddress = event.toString();
        });
      },
    );
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
        title: Text('Requests Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
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
                  side: BorderSide(color: Clr().lightGrey)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dim().d8),
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
                        InkWell(
                          onTap: () {
                            STM().back2Previous(ctx);
                          },
                          child: Text(
                            'Edit',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Clr().lightGrey),
                  ListView.builder(
                      itemCount: widget.alldata.length,
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
                                '${widget.alldata[index]['name'].toString()}',
                                style: Sty().mediumText.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d12),
                              child: Text(
                                '₹${widget.alldata[index]['price'].toString()}',
                                style: Sty().mediumText,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Divider(color: Clr().lightGrey),
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
                            ),

                          ],
                        ),
                        InkWell(
                          onTap: () {
                            STM().redirect2page(
                                ctx,
                                MyProfile(
                                  isEdit: true,
                                ));
                          },
                          child: Text(
                            'Edit',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      address,
                      style: Sty().smallText,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset('assets/calender.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Pickup Date',
                              style: Sty().mediumBoldText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            )
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            datePicker();
                          },
                          child: Text(
                            'Edit',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().primaryColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${sDate}',
                      style: Sty().mediumText,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '10 AM - 6 PM',
                      style: Sty().mediumText.copyWith(color: Clr().grey),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Any instructions (optional)',
                style: Sty().mediumText,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _controller,
              decoration: Sty()
                  .TextFormFieldOutlineStyle
                  .copyWith(fillColor: Clr().white, filled: true),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
            ),
            SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose payment option',
                style: Sty()
                    .largeText
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              color: Clr().white,
              child: Column(
                children: [
                  RadioListTile<dynamic>(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dim().d4,
                    ),
                    activeColor: Clr().primaryColor,
                    value: paymentList[0],
                    groupValue: sPayment,
                    onChanged: (value) {
                      setState(() {
                        sPayment = value!;
                      });
                    },
                    title: Text(
                      paymentList[0],
                      style: Sty().mediumText,
                    ),
                  ),
                  RadioListTile<dynamic>(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dim().d4,
                    ),
                    activeColor: Clr().primaryColor,
                    value: paymentList[1],
                    groupValue: sPayment,
                    onChanged: (value) {
                      setState(() {
                        sPayment = value!;
                      });
                    },
                    title: Text(
                      paymentList[1],
                      style: Sty().mediumText,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 300,
              height: 55,
              child: ElevatedButton(
                  onPressed: () {
                    addRequest();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Submit',
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

  void getMYProfile() async {
    FormData body = FormData.fromMap({
      'id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'my_profile', body);
    var success = result['success'];
    if (success) {
      setState(() {
        pickupaddress = result['pickupaddress'];
        longitude = result['longitude'];
        latitude = result['latitude'];
        address = result['address1'] +
            ' ' +
            result['address2'] +
            ' ' +
            result['city'] +
            ' ' +
            result['state'] +
            ' ' +
            result['pincode'];
      });
    }
  }

  Future datePicker() async {
    DateTime? picked = await showDatePicker(
      context: ctx,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(primary: Clr().primaryColor),
          ),
          child: child!,
        );
      },
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      //Disabled past date
      //firstDate: DateTime.now().subtract(Duration(days: 1)),
      //Disabled future date
      //lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        sDate = s;
      });
    }
  }

  void addRequest() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'pickup_date': sDate,
      'address': pickupaddress == '' ? address : pickupaddress,
      'instructions': _controller.text,
      'payment_option': sPayment,
      'sub_category_ids': widget.allids.toString(),
      "images": json.encode(widget.allimages),
      "latitude":latitude,
      "longitude":longitude,
    });
    var result = await STM().post(ctx, Str().processing, 'add_request', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(
          ctx,
          message,
          MyRequest(
            spage: 'place request',
          ));
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}


