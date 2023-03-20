import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'manage/static_method.dart';
import 'bn_my_requests.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

void main() => runApp(RequestDetailsCancelled());

class RequestDetailsCancelled extends StatefulWidget {
  @override
  State<RequestDetailsCancelled> createState() =>
      _RequestDetailsCancelledState();
}

class _RequestDetailsCancelledState extends State<RequestDetailsCancelled> {
  late BuildContext ctx;

  String? sPayment, sImage;
  List<dynamic> paymentList = [
    "Donate the receive amount",
    "Receive payment in Cash"
  ];

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
                            SvgPicture.asset('assets/scrap.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Scrap items',
                              style: Sty().largeText.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 18),
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
                      'Newspaper',
                      style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '₹14/kg',
                      style: Sty().mediumText,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    const Divider(),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Carton',
                      style: Sty().mediumText.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '₹12/kg',
                      style: Sty().mediumText,
                    ),
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
                              style: Sty().largeText.copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 18),
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
                      '633R+J54, P & T Colony Service Rd, Nandivali Panchanand, P & T Colony, Dombivli, Maharashtra 421201',
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
                          style: Sty().largeText.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        )
                      ],
                    ),
                    const Divider(),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Booking Date',
                          style: Sty().mediumText,)),
                        SizedBox(
                          width: 4,
                        ),
                        Text(':',
                            style: Sty().mediumText),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('31-10-2022',
                                    style: Sty().mediumText)))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(child: Text('Status',
                            style: Sty().mediumText)),
                        SizedBox(
                          width: 4,
                        ),
                        Text(':',
                            style: Sty().mediumText),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('Cancelled',
                                    style: Sty().mediumText.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Clr().red,
                                    ))))
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Card(
                child: Padding(
                  padding:  EdgeInsets.all(Dim().d16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('Lorem\nIpsum',
                            style: Sty().mediumText,)),
                          SizedBox(
                            width: 4,
                          ),
                          SvgPicture.asset('assets/green_dot.svg'),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('18/07/2022\n 02:23 PM',
                                    style: Sty().mediumText,)))
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(child: Text('Cancelled',
                              style: Sty().mediumText.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Clr().red,
                              ))),
                          SizedBox(
                            width: 4,
                          ),
                          SvgPicture.asset('assets/green_dot.svg'),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('18/07/2022\n 02:25 PM',
                                    style: Sty().mediumText,)))
                        ],
                      ),
                      SizedBox(height: 8,),

                    ],
                  ),
                )

            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
