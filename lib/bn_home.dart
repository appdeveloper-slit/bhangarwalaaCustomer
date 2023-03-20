import 'package:dio/dio.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quick_room_services/sidedrawer.dart';
import 'package:quick_room_services/sign_in.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'notification.dart';
import 'select_item.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  String? sUserid;
  int? selected;
  List<dynamic> categoryList = [];
  TextEditingController _searchCtrl = TextEditingController();
  bool? notificationCount;

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
    return DoubleBack(
      message: 'please press back once again',
      child: Scaffold(
        key: scaffoldState,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        // backgroundColor: Color(0xfff4f4f4),
        appBar: AppBar(
          backgroundColor: Clr().primaryColor,
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: EdgeInsets.all(Dim().d16),
                child: SvgPicture.asset('assets/menu.svg'),
              ),
            );
          }),
          title: Image.asset(
            'assets/newlogo.png',
            height: Dim().d40,
          ),
          centerTitle: true,
          actions: [
            // Stack(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.all(Dim().d16),
            //       child: InkWell(
            //           onTap: () {
            //             STM().redirect2page(ctx, Notifications());
            //           },
            //           child: SvgPicture.asset('assets/bell.svg')),
            //     ),
            //     notificationCount == true
            //         ? Positioned(
            //             top: 22,
            //             right: 15,
            //             child: Container(
            //               height: Dim().d12,
            //               width: Dim().d8,
            //               decoration: BoxDecoration(
            //                   shape: BoxShape.circle, color: Colors.red),
            //             ),
            //           )
            //         : Container()
            //   ],
            // )
          ],
          // bottom: PreferredSize(
          //   preferredSize: Size.fromHeight(40.0),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       border: Border(
          //         bottom: BorderSide(color: Clr().grey),
          //       ),
          //     ),
          //
          // ),
          // ),
        ),
        drawer: navbar(ctx, scaffoldState),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              TextFormField(
                controller: _searchCtrl,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  value == null ? null : getSearchResult(_searchCtrl.text);
                },
                decoration: Sty().TextFormFieldOutlineStyle.copyWith(
                      fillColor: const Color(0xffF2F2F2),
                      filled: true,
                      hoverColor: Clr().primaryColor,
                      prefixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: SvgPicture.asset('assets/search.svg'),
                      ),
                      hintText: "Search any scrap item like ...",
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              categoryList.isEmpty
                  ? Container()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 177
                      ),
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(
                            Dim().d4,
                          ),
                          decoration: BoxDecoration(
                              color: Clr().transparent,
                              borderRadius: BorderRadius.circular(Dim().d4)),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  STM().redirect2page(
                                    ctx,
                                    SelectItem(
                                      initialindex: index,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: Dim().d120,
                                  width: Dim().d140,
                                  decoration: BoxDecoration(
                                      color: Clr().white,
                                      borderRadius:
                                          BorderRadius.circular(Dim().d8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Clr().lightGrey,
                                          // offset: Offset(0.0, -5.0), //(x,y)
                                          blurRadius: 3,
                                          offset: Offset(0.0, 6.0),
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.network(
                                        '${categoryList[index]['image_path'].toString()}',
                                        height: Dim().d60,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Container(
                                height:Dim().d40,
                                child: Text(
                                  '${categoryList[index]['name'].toString()}',
                                  style: Sty().mediumText.copyWith(
                                      color: Clr().black,
                                      fontWeight: FontWeight.w400),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  // categoryList[index]['name'].toString(),
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(
                height: 30,
              ),
              // SizedBox(
              //   width: 300,
              //   height: 55,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         STM().redirect2page(ctx, SelectItem());
              //       },
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Clr().primaryColor,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10))),
              //       child: Text(
              //         'Continue',
              //         style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           fontSize: 18,
              //         ),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void getSearchResult(text) async {
    FormData body = FormData.fromMap({
      'keyword': text,
    });
    var result = await STM().postWithoutDialog(ctx, 'search', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      int position = categoryList
          .indexWhere((element) => element['name'] == result['name']);
      STM().redirect2page(
        ctx,
        SelectItem(initialindex: position),
      );
    } else {
      STM().displayToast(message);
    }
  }

  void gethome() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final status = await OneSignal.shared.getDeviceState();
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'player_id': status?.userId,
      'time': sp.getString('date') ?? "0000-00-00 00:00:00",
    });
    var result = await STM().post(ctx, Str().loading, 'get_home', body);
    var success = result['success'];
    if (success) {
      setState(() {
        notificationCount = result['notification_count'];
        categoryList = result['main_categories'];
        sp.setString('apikey', result['api_key']);
        if (result['user_status'] == 0) {
          sp.clear();
          STM().finishAffinity(ctx, SignIn());
        }
      });
    }
  }
}
// Expanded(
// flex: 4,
// child: InfiniteScrollTabView(
// contentLength: categoryList.length,
// onTabTap: (index) {
// setState(() {
// getSubCategories(categoryList[index]['id']);
// });
// },
// tabBuilder: (index, isSelected) => Text(
// categoryList[index]['name'].toString(),
// style: TextStyle(
// color: isSelected ? Clr().primaryColor : Colors.transparent,
// fontWeight: FontWeight.bold,
// fontSize: 18,
// ),
// ),
// separator: BorderSide(color: Colors.black12, width: 1.0),
// onPageChanged: (index) => print('page changed to $index.'),
// indicatorColor: Colors.pink,
// pageBuilder: (context, index, _) {
// return SizedBox.expand(
// child: InkWell(
// onTap: () {
// setState(() {
// addSubIds.add(itemList[index]['id'].toString());
// });
// },
// child: Card(
// child: Padding(
// padding: EdgeInsets.all(Dim().d12),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('${itemList[index]['name'].toString()}'),
// SizedBox(
// height: 4,
// ),
// Text('₹ ${itemList[index]['price'].toString()}/kg')
// ],
// ),
// addSubIds.contains(itemList[index]['id'].toString())
// ? SvgPicture.asset('assets/tick.svg')
//     : Container(),
// ],
// ),
// ),
// ),
// ),
// );
// },
// ),
// ),
