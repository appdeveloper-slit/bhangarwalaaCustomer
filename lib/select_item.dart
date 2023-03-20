import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage/static_method.dart';
import 'select_date.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class SelectItem extends StatefulWidget {
  final int initialindex;
  const SelectItem({super.key,required this.initialindex});

  @override
  State<SelectItem> createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> with TickerProviderStateMixin {
  late BuildContext ctx;
  String? sUserid;
  List<dynamic> addSubIds = [];
  List<dynamic> addSubAllData = [];
  List<File> imagelist = [];
  List<dynamic> categoryList = [];
  int? selectindex;
  TabController? _cardController;
  List<String> base64List = [];
  List<String> camimglist = [];
  var SImage;
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
    _cardController = TabController(
      length: categoryList.length,
      vsync: this,
      initialIndex: widget.initialindex,
    );
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
        title: Text('Select Item'),
        centerTitle: true,
        // bottom: TabBar(
        //   controller: _controller,
        //   isScrollable: true,
        //   tabs: [
        //     Tab(text: 'sgsgff',)
        //   ]
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dim().d16),
        child: StatefulBuilder(builder: (BuildContext context, setState){
          return Column(
            children: [
              Container(
                height: Dim().d40,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Clr().lightGrey))),
                child: TabBar(
                  controller: _cardController,
                  isScrollable: true,
                  padding: EdgeInsets.symmetric(horizontal: Dim().d20),
                  labelColor: Clr().primaryColor,
                  indicatorColor: Clr().primaryColor,
                  automaticIndicatorColorAdjustment: true,
                  unselectedLabelColor: Colors.black,
                  tabs: categoryList.map((e) {
                    return Tab(
                      text: e['name'].toString(),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: Dim().d12,
              ),
              Expanded(
                flex: 4,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _cardController,
                    children: categoryList.map((e) {
                      return Container(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: e['sub_categories'].length,
                            // padding: EdgeInsets.only(top: 2,bottom: 12),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: InkWell(
                                  onTap: () {
                                    if (addSubIds.contains(e['sub_categories']
                                    [index]['id']
                                        .toString())) {
                                      setState(() {
                                        addSubIds.remove(e['sub_categories']
                                        [index]['id']
                                            .toString());
                                        addSubAllData
                                            .remove(e['sub_categories'][index]);
                                      });
                                    } else {
                                      setState(() {
                                        addSubIds.add(e['sub_categories'][index]['id'].toString());
                                        addSubAllData.add(e['sub_categories'][index]);
                                      });
                                    }
                                    print(addSubIds);
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(Dim().d12),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${e['sub_categories'][index]['name'].toString()}'),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                  '₹ ${e['sub_categories'][index]['price'].toString()}')
                                            ],
                                          ),
                                          addSubIds.contains(e['sub_categories']
                                          [index]['id']
                                              .toString())
                                              ? SvgPicture.asset(
                                              'assets/tick.svg')
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 4,
              ),
              Padding(
                padding: EdgeInsets.all(Dim().d16),
                child: Row(
                  children: [
                    InkWell(onTap: (){
                      pickimage();
                    },child: Icon(Icons.camera_alt,color: Clr().primaryColor,size: Dim().d32,)),
                    SizedBox(width: Dim().d12,),
                    InkWell(onTap: (){
                      base64List.clear();
                      multiplefilepicker();
                    },child: SvgPicture.asset('assets/upload.svg')),
                    SizedBox(
                      width: Dim().d20,
                    ),
                    Container(
                      width: Dim().d220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SImage != null ? Text(
                            '${camimglist.length} Images Selected',
                            style: Sty().mediumText,
                          ) : base64List.length > 0
                              ? Text(
                            '${base64List.length} Images Selected',
                            style: Sty().mediumText,
                          )
                              : Text(
                            'Upload scrap items pictures',
                            overflow: TextOverflow.fade,
                            style: Sty().mediumText,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'This will help us identify your scrap item better.',
                            overflow: TextOverflow.fade,
                            style: Sty().smallText.copyWith(color: Clr().grey),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: Dim().d300,
                height: Dim().d56,
                child: ElevatedButton(
                    onPressed: () {
                      addSubAllData.length == 0 ? STM().displayToast('please select item') : STM().redirect2page(
                          ctx,
                          SelectDate(
                            alldata: addSubAllData,
                            allimages: base64List == null ? camimglist : base64List,
                            allids: addSubIds,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Clr().primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total item : ${addSubIds.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'CHECKOUT',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 12,
              )
            ],
          );
        }),
      ),
    );
  }

  void multiplefilepicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      imagelist = result.paths.map((path) => File(path!)).toList();
      var image;
      for (var a = 0; a < imagelist.length; a++) {
        setState(() {
          image = imagelist[a].readAsBytesSync();
          base64List.add(base64Encode(image).toString());
        });
      }
      print(base64List.length);
    }
  }

  void pickimage() async {
    final ImagePicker _picker = ImagePicker();
    final photo = await _picker.pickImage(source: ImageSource.camera);
    File image = File(photo!.path.toString());
    var img;
    setState(() {
      img = image.readAsBytesSync();
      SImage = base64Encode(img);
      camimglist.add(SImage);
    });
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
