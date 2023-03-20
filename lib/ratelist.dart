import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/bottom_navigation/bottom_navigation.dart';
import 'package:quick_room_services/values/colors.dart';
import 'package:quick_room_services/values/dimens.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manage/static_method.dart';

class RateList extends StatefulWidget {
  const RateList({Key? key}) : super(key: key);

  @override
  State<RateList> createState() => _RateListState();
}

class _RateListState extends State<RateList> {
  late BuildContext ctx;
  String? sUserid;
  List<dynamic> categoryList = [];

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        gethome();
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
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 2),
        appBar: AppBar(
          backgroundColor: Clr().primaryColor,
          leading: InkWell(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: Padding(
              padding: EdgeInsets.all(Dim().d16),
              child: SvgPicture.asset(
                'assets/back_arrow.svg',
                color: Clr().white,
              ),
            ),
          ),
          title: Text('Rate List'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Dim().d20,),
              ListView.builder(itemCount: categoryList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom:17.0,left: 17.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${categoryList[index]['name']}',
                            style: Sty().mediumBoldText.copyWith(
                                color: Clr().hintColor),),
                          SizedBox(height: Dim().d8,),
                          Container(
                            height: MediaQuery.of(ctx).size.height / 9.3,
                            child: ListView.builder(
                                itemCount: categoryList[index]['sub_categories']
                                    .length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index2) {
                                  return Padding(
                                    padding:  EdgeInsets.only(right:12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dim().d12),
                                        border: Border.all(
                                            color: Clr().lightGrey),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${categoryList[index]['sub_categories'][index2]['name'].toString()}',style: Sty().mediumText,),
                                            SizedBox(height: Dim().d12,),
                                            Text(
                                              '${categoryList[index]['sub_categories'][index2]['price'].toString()}',style: Sty().mediumText,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void gethome() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'get_home', body);
    var success = result['success'];
    if (success) {
      setState(() {
        categoryList = result['main_categories'];
      });
    }
  }
}
