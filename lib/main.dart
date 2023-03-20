import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quick_room_services/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bn_home.dart';
import 'bn_my_requests.dart';
import 'sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  // MediaQueryData windowData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  // windowData = windowData.copyWith(textScaleFactor: 1.0,);
  // bool isLogin =
  // sp.getBool('is_login') != null ? sp.getBool("is_login")! : false;
  // bool isID = sp.getString('user_id') != null ? true : false;
  bool isLogin = sp.getBool('is_login') ?? false;
  OneSignal.shared.setAppId('da431044-5cb9-4a7e-8fae-9d610970a250');
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  OneSignal.shared.setNotificationOpenedHandler((value) {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => MyRequest(),
      ),
    );
  });
  await Future.delayed(const Duration(seconds: 3));
  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      // useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      // home: isLogin
      //     ? const Home()
      //     : isID
      //     ? const SelectCourse()
      //     : const Register(),
      home: isLogin ? Home() : SignIn(),
    ),
  );
}
