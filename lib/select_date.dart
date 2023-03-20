import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_room_services/values/styles.dart';

import 'manage/static_method.dart';
import 'request_details.dart';
import 'values/colors.dart';
import 'values/dimens.dart';

class SelectDate extends StatefulWidget {
  final List<dynamic> alldata;
  final List<dynamic> allids;
  final List<String> allimages;

  const SelectDate(
      {super.key,
      required this.alldata,
      required this.allimages,
      required this.allids});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  late BuildContext ctx;
  final _nameFormKey = GlobalKey<FormFieldState>();
  TextEditingController dobCtrl = TextEditingController();

  //Date picker
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      //Disabled past date
      //firstDate: DateTime.now().subtract(Duration(days: 1)),
      //Disabled future date
      //lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        String s = STM().dateFormat('yyyy-MM-dd', picked);
        dobCtrl = TextEditingController(text: s);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      key: _nameFormKey,
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
        title: Text('Select Date'),
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
                'Select a date for scrap pickup',
                style: Sty().largeText.copyWith(
                      color: Clr().primaryColor,
                    ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              readOnly: true,
              onTap: () {
                datePicker();
              },
              controller: dobCtrl,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Pickup date is required';
                }
              },
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.all(Dim().d16),
                  child: SvgPicture.asset("assets/calender.svg"),
                ),
                filled: true,
                fillColor: Clr().white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Clr().primaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Clr().transparent,
                    )),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.all(18),
                // label: Text('नाव',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Pickup time between 10 am - 6 pm. Our pickup exective will call you before coming.',
              style: Sty().mediumText.copyWith(fontSize: 14, color: Clr().grey),
            ),
            SizedBox(
              height: 350,
            ),
            SizedBox(
              width: 300,
              height: 55,
              child: ElevatedButton(
                  onPressed: () {
                    if (dobCtrl.text.isEmpty) {
                      STM().displayToast('Please select the date');
                    } else {
                      STM().replacePage(
                        ctx,
                        RequestDetails(
                          widget.alldata,
                          widget.allids,
                          dobCtrl.text,
                          widget.allimages,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    'Continue',
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
}
