import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/Environment/Environment.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/helper_widget/bottombar.dart';
import 'package:ifresh_delivery/screens/app_update/App_Mentaintion_Mood.dart';
import 'package:ifresh_delivery/screens/login/login_screen.dart';
import 'package:ifresh_delivery/screens/setting_model_controller/setting_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var setting_data;
  bool? logincheck;
  var setting_datas;
  SettingController settingController = Get.put(SettingController());

  appUpdates() async {
    print('inside splash app upfates $baseurl');
    var settingUrl = Uri.parse(settings_url);
    log('settings_url==>${settings_url}');
    await settingController.SettingData(settingUrl);
    var serverVersion;
    if (Platform.isAndroid) {
      print('inside setting_complete_data is android $setting_complete_data');

      serverVersion = setting_complete_data['data']['settings']
              ['app_version_android']
          .toString();
    } else {
      serverVersion = setting_complete_data['data']['settings']
              ['app_version_android']
          .toString();
    }
    print(
        'inside not outside ${setting_complete_data['data']['settings']['maintenance_toggle'].toString()}');
    if (setting_complete_data['data']['settings']['maintenance_toggle']
            .toString() ==
        maintainversion) {
      print('inside setting_complete_data  toggle');
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AppMaintanceDialog(
                    appupdatetext: setting_complete_data['data']['settings']
                            ['maintenance']
                        .toString()),
              ));
    } else if (double.parse(serverVersion) >
        (Platform.isAndroid ? appversion : iosversion)) {
      print('inside setting_complete_data else if ');
      showDialog(
          context: context,
          barrierDismissible: setting_complete_data['data']['settings']
                          ['force_update_android']
                      .toString() ==
                  App_force_updateNo
              ? true
              : false,
          // barrierDismissible: true,
          builder: (_) => WillPopScope(
                onWillPop: () async {
                  return setting_complete_data['data']['settings']
                                  ['force_update_android']
                              .toString() ==
                          App_force_updateNo
                      ? false
                      : true;
                },
                child: AppUpdateDialog(
                  appforceupdate: setting_complete_data['data']['settings']
                          ['force_update_android']
                      .toString(),
                  appupdatetext: setting_complete_data['data']['settings']
                          ['force_update_message_android']
                      .toString(),
                  appurl: setting_complete_data['data']['settings']
                          ['app_url_android']
                      .toString(),
                ),
              ));
      // Get.dialog(
      //
      //   WillPopScope(
      //     onWillPop: () async {
      //       return cmsController.appsettingdata.value.data.androidForceUpdate=="1"
      //           ? false
      //           : true;
      //       // return false;
      //     },
      //     child: AppUpdateDialog(
      //       appforceupdate:appsettingdata.value.data.androidForceUpdate ,
      //       appupdatetext:appsettingdata.value.data.appUpdateText ,
      //       appurl:appsettingdata.value.data.androidAppUrl ,
      //     ),
      //   ),
      // );
    } else {
      print('inside setting_complete_data else timer');
      Timer(Duration(seconds: 3), () async {
        Environment.appuserlog == true
            ? Get.offAll(BottomBar(
                bottomindex: 1,
              ))
            : Get.to(LoginScreen());
      });
    }
    // update();
    // getroute();
  }

  loginCheck() {
    Timer(Duration(seconds: 3), () async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  void initState() {
    print('inside initstate');
    super.initState();
    // logincheck = Environment.appuserlog;
    //
    // print("inside logincheck..."+logincheck.toString());
    appUpdates();
    //loginCheck();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              color: primary,
            ),
          ),
          Positioned(
            top: 140,
            child: Image.asset(
              "assets/images/iFresh.png",
              scale: 4.0,color: Colors.white,
            ),
          ),
          Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60),
                  topLeft: Radius.circular(60),
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: size.height * 0.5,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    "assets/images/splashimg.png",
                    scale: 1,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
