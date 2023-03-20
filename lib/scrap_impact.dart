import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/values/styles.dart';

import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

void main() => runApp(ScrapImpact());

class ScrapImpact extends StatefulWidget {
  @override
  State<ScrapImpact> createState() => _ScrapImpactState();
}

class _ScrapImpactState extends State<ScrapImpact> {
  late BuildContext ctx;

  List<dynamic> itemList = [];

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
          title: Text('Scrap Impact'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Your contribution of 0 kg scrap has helped our environment.',
                  style: Sty().mediumText,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 4,
                  // padding: EdgeInsets.only(top: 2,bottom: 12),
                  itemBuilder: (ctx, index) {
                    return itemLayout(ctx, index, itemList);
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget itemLayout(ctx, index, itemList) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(Dim().d16),
        child: Row(
          children: [
            SvgPicture.asset('assets/scrapimpact5.svg'),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '0',
                  style: Sty()
                      .largeText
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 4,
                ),
                Text('Landspace saved')
              ],
            )
          ],
        ),
      ),
    );
  }
}
