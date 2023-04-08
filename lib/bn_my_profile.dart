import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:quick_room_services/bn_home.dart';
import 'package:quick_room_services/request_details.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:quick_room_services/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bottom_navigation/bottom_navigation.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';


var controller = StreamController<String?>.broadcast();
String? sLocation, sLatitude, sLongitude;
String? sLocation1, sLatitude1, sLongitude1;
bool? click;
class MyProfile extends StatefulWidget {
  final bool isEdit;

  const MyProfile({Key? key, this.isEdit = false}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late BuildContext ctx;
  String? sUserid,apikey;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController nearbyCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController stateCtrl = TextEditingController();
  String? pincodevalue;
  List<dynamic> pincodelist = [];
  final _formKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  bool again = false;

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
      apikey = sp.getString('apikey');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getMYProfile();
        getpincode();
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
        widget.isEdit ? Navigator.pop(ctx) : STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: bottomBarLayout(ctx, 3),
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
          title: Text('My Profile'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: Sty().largeText.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter Name',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().lightGrey,
                    )),
                    filled: true,
                    fillColor: Clr().white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().transparent,
                    )),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('नाव',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Mobile Number',
                  style: Sty().largeText.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: mobileCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile No.',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().lightGrey,
                    )),
                    suffixIcon: InkWell(
                      onTap: () {
                        updateMobileNumber();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Dim().d12),
                        child: SvgPicture.asset('assets/edit.svg'),
                      ),
                    ),
                    filled: true,
                    fillColor: Clr().white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().transparent,
                    )),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('नाव',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Address',
                        style: Sty()
                            .largeText
                            .copyWith(fontWeight: FontWeight.w400),
                        children: [
                      TextSpan(
                          text: '*',
                          style: Sty().mediumText.copyWith(color: Clr().red))
                    ])),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: addressCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter Address',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().lightGrey,
                    )),
                    filled: true,
                    fillColor: Clr().white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().transparent,
                    )),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('नाव',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: nearbyCtrl,
                  decoration: InputDecoration(
                    hintText: 'Add Nearby Famous Shop/Mall/Landmark',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().lightGrey,
                    )),
                    filled: true,
                    fillColor: Clr().white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().transparent,
                    )),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('नाव',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: cityCtrl,
                  decoration: InputDecoration(
                    hintText: 'City',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().lightGrey,
                    )),
                    filled: true,
                    fillColor: Clr().white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().transparent,
                    )),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('नाव',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: stateCtrl,
                  decoration: InputDecoration(
                    hintText: 'State',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().lightGrey,
                    )),
                    filled: true,
                    fillColor: Clr().white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Clr().primaryColor, width: 1.0),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Clr().transparent,
                    )),
                    contentPadding: EdgeInsets.all(18),
                    // label: Text('नाव',
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    STM().redirect2page(
                        ctx,
                        CustomSearchScaffold(apikey!));
                    setState(() {
                      click = true;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(ctx).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Clr().grey,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d12, horizontal: Dim().d12),
                      child: Text(
                        sLocation!.isEmpty ? "Select Map location" : sLocation!,
                        style: Sty().mediumText.copyWith(color: Clr().black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField(
                  decoration: Sty().TextFormFieldOutlineStyle,
                  isExpanded: true,
                  hint: pincodevalue == "" ? Text(
                    "pincode",
                    style: Sty().mediumText.copyWith(
                      color: Clr().hintColor,
                    ),
                  ) :Text(
                    "$pincodevalue",
                    style: Sty().mediumText
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  style: TextStyle(color: Color(0xff000000)),
                  items: pincodelist.map((string) {
                    return DropdownMenuItem(
                      value: string['pin_code'].toString(),
                      child: Text(string['pin_code'].toString(),
                          style: Sty()
                              .mediumText
                              .copyWith(color: Clr().black)),
                    );
                  }).toList(),
                  onChanged: (v) {
                    // STM().redirect2page(ctx, Home());
                    setState(() {
                      pincodevalue = v as String?;
                    });
                  },
                ),
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   maxLength: 6,
                //   controller: pincodeCtrl,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'This field is required';
                //     }
                //     if (value.length != 6) {
                //       return 'Otp digits must be 6';
                //     }
                //   },
                //   decoration: InputDecoration(
                //     counterText: "",
                //     hintText: 'Pincode',
                //     enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //       color: Clr().lightGrey,
                //     )),
                //     filled: true,
                //     fillColor: Clr().white,
                //     focusedBorder: OutlineInputBorder(
                //       borderSide:
                //           BorderSide(color: Clr().primaryColor, width: 1.0),
                //     ),
                //     border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //       color: Clr().transparent,
                //     )),
                //     contentPadding: EdgeInsets.all(18),
                //     // label: Text('नाव',
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 55,
                    child: ElevatedButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            updateprofile();
                          }
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
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateMobileNumber() {
    bool otpsend = false;
    // var updateUserMobileNumberController;
    // updateUserMobileNumberController.text = "";
    // updateUserOtpController.text = "";
    showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          TextEditingController updateUserMobileNumberController =
          TextEditingController();
          TextEditingController updateUserOtpController =
          TextEditingController();
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text("Change Mobile Number",
                  style:
                  Sty().mediumBoldText.copyWith(color: Color(0xff2C2C2C))),
              content: SizedBox(
                height: 120,
                width: MediaQuery.of(ctx).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "New Mobile Number",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: formKey,
                                  child: TextFormField(
                                    controller:
                                    updateUserMobileNumberController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile filed is required';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile digits must be 10';
                                      }
                                    },
                                    maxLength: 10,
                                    decoration: Sty()
                                        .TextFormFieldOutlineStyle
                                        .copyWith(
                                      counterText: "",
                                      hintText: "Enter Mobile Number",
                                      prefixIconConstraints: BoxConstraints(
                                          minWidth: 50, minHeight: 0),
                                      suffixIconConstraints: BoxConstraints(
                                          minWidth: 10, minHeight: 2),
                                      border: InputBorder.none,
                                      // prefixIcon: Icon(
                                      //   Icons.phone,
                                      //   size: iconSizeNormal(),
                                      //   color: primary(),
                                      // ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text(
                                  "One Time Password",
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextFormField(
                                    controller: updateUserOtpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Enter OTP",
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 50, minHeight: 0),
                                      suffixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 10, minHeight: 2),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xff2C2C2C),
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Visibility(
                                          visible: !again,
                                          child: TweenAnimationBuilder<
                                              Duration>(
                                              duration:
                                              const Duration(seconds: 60),
                                              tween: Tween(
                                                  begin: const Duration(
                                                      seconds: 60),
                                                  end: Duration.zero),
                                              onEnd: () {
                                                // ignore: avoid_print
                                                // print('Timer ended');
                                                setState(() {
                                                  again = true;
                                                });
                                              },
                                              builder: (BuildContext context,
                                                  Duration value,
                                                  Widget? child) {
                                                final minutes = value.inMinutes;
                                                final seconds =
                                                    value.inSeconds % 60;
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    "Re-send code in $minutes:$seconds",
                                                    textAlign: TextAlign.center,
                                                    style: Sty().mediumText,
                                                  ),
                                                );
                                              }),
                                        ),
                                        // Visibility(
                                        //   visible: !isResend,
                                        //   child: Text("I didn't receive a code! ${(  sTime  )}",
                                        //       style: Sty().mediumText),
                                        // ),
                                        Visibility(
                                          visible: again,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                again = false;
                                              });
                                              resendOTP(updateUserMobileNumberController.text);
                                              // STM.checkInternet().then((value) {
                                              //   if (value) {
                                              //     sendOTP();
                                              //   } else {
                                              //     STM.internetAlert(ctx, widget);
                                              //   }
                                              // });
                                            },
                                            child: Text(
                                              'Resend OTP',
                                              style: Sty().mediumText,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ]),
                ),
              ),
              elevation: 0,
              actions: [
                Row(
                  children: [
                    Visibility(
                      visible: !otpsend,
                      child: Expanded(
                        child: InkWell(
                          onTap: () async {
                            // API UPDATE START
                            if (formKey.currentState!.validate()) {
                              SharedPreferences sp =
                              await SharedPreferences.getInstance();
                              FormData body = FormData.fromMap({
                                'type': 'user',
                                'page_type': 'change_mobile',
                                'mobile': updateUserMobileNumberController.text,
                              });
                              var result = await STM()
                                  .post(ctx, Str().sendingOtp, 'sendOTP', body);
                              var success = result['success'];
                              var message = result['message'];
                              if (success) {
                                setState(() {
                                  otpsend = true;
                                });
                              } else {
                                STM().errorDialog(context, message);
                              }
                            }
                            // API UPDATE END
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Clr().primaryColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Send OTP",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: otpsend,
                      child: Expanded(
                        child: InkWell(
                            onTap: () {
                              // API UPDATE START
                              setState(() async {
                                otpsend = true;
                                SharedPreferences sp =
                                await SharedPreferences.getInstance();
                                FormData body = FormData.fromMap({
                                  'otp': updateUserOtpController.text,
                                  'mobile':
                                  updateUserMobileNumberController.text,
                                  'id': sUserid,
                                  'page_type': 'change_mobile',
                                  'type': 'user',
                                });
                                var result = await STM().post(
                                  ctx,
                                  Str().updating,
                                  'verifyOTP',
                                  body,
                                );
                                var success = result['success'];
                                var message = result['message'];
                                if (success) {
                                  Navigator.pop(ctx);
                                } else {
                                  STM().errorDialog(context, message);
                                }
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Clr().primaryColor,
                                ),
                                child: const Center(
                                    child: Text(
                                      "Update",
                                      style: TextStyle(color: Colors.white),
                                    )))),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Clr().primaryColor,
                              ),
                              child: const Center(
                                  child: Text("Cancel",
                                      style: TextStyle(color: Colors.white))))),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        });
  }

  void resendOTP(smobile) async {
    //Input
    FormData body = FormData.fromMap({
      'mobile': smobile,
    });
    //Output
    var result = await STM().post(ctx, Str().sendingOtp, "resendOTP", body);
    SharedPreferences sp = await SharedPreferences.getInstance();
    if (!mounted) return;
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
    } else {
      STM().errorDialog(ctx, message);
      // _showSuccessDialog(ctx,message);
    }
  }

  void updateprofile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'id': sUserid,
      'name': nameCtrl.text,
      'address1': addressCtrl.text,
      'address2': nearbyCtrl.text,
      'city': cityCtrl.text,
      'state': stateCtrl.text,
      'pincode': pincodevalue,
      'pickupaddress':sLocation,
      'latitude':sLatitude,
      'longitude':sLongitude,
    });
    var result = await STM().post(
      ctx,
      Str().updating,
      'update_profile',
      body,
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().displayToast(message);
      if (widget.isEdit) {
        STM().back2Previous(ctx);
        var v = "${addressCtrl.text.trim()} ${nearbyCtrl.text.trim()} ${cityCtrl.text.trim()} ${stateCtrl.text.trim()} - ${pincodevalue}";
        RequestDetailsPage.controller.sink.add(v);
        RequestDetailsPage.controller1.sink.add(sLocation);
      }
    } else {
      STM().errorDialog(context, message);
    }
  }

  void getpincode() async {
    var result = await STM().get(ctx, Str().loading, 'get_pin_codes');
    var success = result['success'];
    if(success){
      setState(() {
        pincodelist = result['pin_codes'];
      });
    }
  }

  void getMYProfile() async {
    FormData body = FormData.fromMap({
      'id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'my_profile', body);
    var success = result['success'];
    if (success) {
      setState(() {
        nameCtrl = TextEditingController(text: result['name']);
        mobileCtrl = TextEditingController(text: result['mobile'].toString());
        addressCtrl = TextEditingController(text: result['address1']);
        nearbyCtrl = TextEditingController(text: result['address2']);
        cityCtrl = TextEditingController(text: result['city']);
        stateCtrl = TextEditingController(text: result['state']);
        pincodevalue =  result['pincode'];
        sLocation = result['pickupaddress'];
        sLatitude = result['latitude'];
        sLongitude = result['longitude'];
      });
    }
  }
}
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  final String sMapKey;

  CustomSearchScaffold(this.sMapKey, {Key? key})
      : super(
    key: key,
    apiKey: sMapKey,
    sessionToken: const Uuid().v4(),
    language: 'en',
    components: [Component(Component.country, 'in')],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Clr().primaryColor,
        title: AppBarPlacesAutoCompleteTextField(
          cursorColor: Clr().primaryColor,
          textStyle: Sty().mediumText,
          textDecoration: null,
        ),
      ),
      body: PlacesAutocompleteResult(
        onTap: (p) async {
          if (p == null) {
            return;
          }
          final _places = GoogleMapsPlaces(
            apiKey: widget.apiKey,
            apiHeaders: await const GoogleApiHeaders().getHeaders(),
          );
          final detail = await _places.getDetailsByPlaceId(p.placeId!);
          final geometry = detail.result.geometry!;
          setState(() {
            sLocation = p.description;
            sLatitude = geometry.location.lat.toString();
            sLongitude = geometry.location.lng.toString();
            STM().back2Previous(context);
          });
          controller.sink.add("Updated");
        },
        logo: null,
      ),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.errorMessage ?? 'Unknown error')),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response.predictions.isNotEmpty) {
      setState(() {
        sLocation = response.status;
      });
    }
  }
}