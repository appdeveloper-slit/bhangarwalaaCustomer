import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_room_services/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bn_home.dart';
import 'manage/static_method.dart';
import 'values/colors.dart';
import 'values/dimens.dart';
import 'values/styles.dart';

class BankDetails extends StatefulWidget {
  final sType;

  const BankDetails({super.key, this.sType});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  late BuildContext ctx;
  List<dynamic> accountlist = [
    'CURRENT',
    'SAVING',
  ];
  String? selectedValue;
  final _formKey = GlobalKey<FormState>();

  // List<String> arrayList3 = ['State'];
  String k = "0";
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController accountnumCtrl = TextEditingController();
  TextEditingController ifscCtrl = TextEditingController();
  TextEditingController upiidCtrl = TextEditingController();
  TextEditingController banknameCtrl = TextEditingController();
  String? sUserid, sUplodPan;

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sUserid = sp.getString('user_id');
    });
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getBankDetails();
      }
    });
  }

  @override
  void initState() {
    getSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(onWillPop: ()async{
      STM().back2Previous(ctx);
      return false;
    },
      child: Scaffold(
        backgroundColor: Clr().white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Clr().white,
          leading: InkWell(
              onTap: () {
                STM().back2Previous(ctx);
              },
              child: Icon(Icons.arrow_back_rounded, color: Clr().black)),
          actions: [
            // Padding(
            //   padding: EdgeInsets.all(Dim().d16),
            //   child: Row(
            //     children: [
            //       Text(
            //         'Need Help',
            //         style: Sty().mediumText.copyWith(color: Clr().black),
            //       ),
            //       SizedBox(
            //         width: 4,
            //       ),
            //       SvgPicture.asset('assets/help.svg'),
            //     ],
            //   ),
            // )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Bank Details',
                  style: Sty().largeText.copyWith(
                    color: Clr().black,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  cursorColor: Clr().primaryColor,
                  style: Sty().mediumText,
                  controller: nameCtrl,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                      color: Clr().grey,
                    ),
                    hintText: "Name on the Account",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '  *as mentioned in your passbook or bank account   ',
                  style: Sty()
                      .microText
                      .copyWith(color: Clr().grey, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  cursorColor: Clr().primaryColor,
                  controller: accountnumCtrl,
                  style: Sty().mediumText,
                  maxLength: 18,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (!RegExp(r'^\d{9,18}$').hasMatch(value)) {
                      return "Please enter a valid account number";
                    }
                  },
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                      color: Clr().grey,
                    ),
                    hintText: "Account Number",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  cursorColor: Clr().primaryColor,
                  controller: upiidCtrl,
                  style: Sty().mediumText,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (!RegExp(r'^[\w.\-_]{3,}@[a-zA-Z]{3,}').hasMatch(value)) {
                      return "Please enter a valid UPI ID";
                    }
                  },
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                      color: Clr().grey,
                    ),
                    hintText: "UPI ID",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  cursorColor: Clr().primaryColor,
                  style: Sty().mediumText,
                  controller: ifscCtrl,
                  maxLength: 11,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                    if (!RegExp(r'^[A-Za-z]{4}[a-zA-Z0-9]{7}$').hasMatch(value)) {
                      return "Please enter a valid ifsc code";
                    }
                  },
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                      color: Clr().grey,
                    ),
                    hintText: "IFSC Code",
                    counterText: "",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  cursorColor: Clr().primaryColor,
                  style: Sty().mediumText,
                  keyboardType: TextInputType.name,
                  controller: banknameCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  textInputAction: TextInputAction.done,
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                    hintStyle: Sty().smallText.copyWith(
                      color: Clr().grey,
                    ),
                    hintText: "Bank Name",
                  ),
                ),
                widget.sType == 'edit'
                    ? SizedBox(
                  height: 20,
                )
                    : Container(),
                widget.sType == 'edit'
                    ? TextFormField(
                  cursorColor: Clr().primaryColor,
                  readOnly: true,
                  style: Sty().mediumText,
                  keyboardType: TextInputType.name,
                  controller: banknameCtrl,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'This field is required';
                    }
                  },
                  textInputAction: TextInputAction.done,
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                    suffixIcon: InkWell(
                        onTap: () {
                          filePicker('pan', true);
                        },
                        child: Icon(
                          Icons.camera_alt,
                          color: Clr().black,
                        )),
                    hintStyle: Sty().smallText.copyWith(
                      color: Clr().grey,
                    ),
                    hintText: sUplodPan != null
                        ? "Image Selected"
                        : "Upload selfie with documents",
                  ),
                )
                    : Container(),
                widget.sType == 'edit'
                    ? SizedBox(
                  height: 20,
                )
                    : Container(),
                widget.sType == 'edit'
                    ? Row(
                  children: [
                    Expanded(
                      child: Text(
                        '*Hold your Aadhaar/ PAN card in your hand & keep your hand beside your face & click the selfie. Contents of the card should be clearly visible in the photo',
                        style: Sty().mediumText.copyWith(color: Clr().red),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      flex: 2,
                      child: Image.asset(
                        'assets/profile.png',
                        height: Dim().d100,
                        width: Dim().d100,
                      ),
                    ),
                  ],
                )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Account Type :',
                      style:
                      Sty().smallText.copyWith(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(Dim().d8)),
                            border: Border.all(color: Clr().black)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedValue,
                            hint: Text(
                              'Select Account Type',
                              style: Sty()
                                  .mediumText
                                  .copyWith(color: Clr().hintColor),
                            ),
                            isExpanded: true,
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 28,
                            ),
                            style: Sty().mediumText,
                            items: accountlist.map((value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  value.toString(),
                                  style: Sty().mediumText,
                                ),
                              );
                            }).toList(),
                            onChanged: (k) {
                              setState(() {
                                selectedValue = k!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addBankDetails();
                        }
                      },
                      child: Text(
                        'Submit',
                        style: Sty().largeText.copyWith(
                            color: Clr().white, fontWeight: FontWeight.w400),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Clr().primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filePicker(type, userWantsCamera) async {
    bool isCamera = userWantsCamera;
    FilePickerResult? result;
    ImagePicker _picker = ImagePicker();
    XFile? photo;
    if (isCamera == true) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg']);
    }
    final image;
    if (result != null || photo != null) {
      if (isCamera == true) {
        image = await photo!.readAsBytes();
      } else {
        image = File(result!.files.single.path.toString()).readAsBytesSync();
      }
      setState(() {
        switch (type) {
          case "pan":
            sUplodPan = base64Encode(image);
        }
      });
      print(sUplodPan);
    }
  }
  void getBankDetails() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'get_bank', body);
    var success = result['success'];
    if (success) {
      setState(() {
        nameCtrl = TextEditingController(
            text: result['bank']['customer_name'].toString());
        accountnumCtrl = TextEditingController(
            text: result['bank']['account_number'].toString());
        banknameCtrl =
            TextEditingController(text: result['bank']['bank_name'].toString());
        ifscCtrl = TextEditingController(
            text: result['bank']['ifsc_number'].toString());
        selectedValue = result['bank']['account_type'].toString();
        upiidCtrl = TextEditingController(text: result['bank']['upi_id'].toString());
      });
    }
  }

  void updateBankDetails() async {
    FormData body = FormData.fromMap({
      'user_id': sUserid,
      'customer_name': nameCtrl.text,
      'account_number': accountnumCtrl.text,
      'ifsc_number': ifscCtrl.text,
      'bank_name': banknameCtrl.text,
      'account_type': selectedValue,
    });
    var result = await STM().post(ctx, Str().processing, 'update_bank', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      STM().successDialogWithAffinity(ctx, message, widget);
    } else {
      STM().errorDialog(ctx, message);
    }
  }
  void addBankDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'customer_name': nameCtrl.text,
      'account_number': accountnumCtrl.text,
      'ifsc_number': ifscCtrl.text,
      'upi_id': upiidCtrl.text,
      'bank_name': banknameCtrl.text,
      'account_type': selectedValue,
      'user_id': sUserid,
    });
    var result = await STM().post(ctx, Str().loading, 'add_bank', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        sp.setBool('fillbankdetails', true);
        sp.setBool('login', true);
        STM().displayToast(message);
        STM().finishAffinity(ctx, Home());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
