import 'package:flutter/material.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/Environment/Environment.dart';
import 'package:ifresh_delivery/helper_widget/bottombar.dart';
import 'package:ifresh_delivery/screens/login/login_screen.dart';
import 'package:ifresh_delivery/screens/setting_model_controller/setting_controller.dart';
import 'package:get/get.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../constant/strings.dart';



class AppUpdateDialog extends StatefulWidget {
  var appupdatetext;
  var appforceupdate;
  var appurl;
  AppUpdateDialog({this.appupdatetext,this.appforceupdate,this.appurl});
  @override
  _AppUpdateDialogState createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {


  @override
  void initState() {
    super.initState();
    print("widget.appupdatetext  ${widget.appupdatetext}");
    print("appforceupdate  ${widget.appforceupdate}");

  }

  @override
  void dispose() {

    super.dispose();
  }
  var userlogin;
  SettingController settingController =Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child:  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: white
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/appbar_img.png",color: primary,),
              SizedBox(height: 20),
              Text(
                appname,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 0.5
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.appupdatetext}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        StoreRedirect.redirect(
                            androidAppId: widget.appurl.toString(),
                            iOSAppId: "585027354");
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.purple, backgroundColor: Colors.white,
                      ),
                      child: Text('Go To Playstore',style: TextStyle(color: primary),),
                    ),
                  ),
                  widget.appforceupdate== "1"?Container():
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          userlogin = Environment.appuserlog;
                          print("userlogin...."+userlogin.toString());
                          // var settingUrl = apiUrls().setting_api;
                          // print("settingUrl....."+settingUrl.toString());
                          // settingController.GetSettingData(settingUrl);
                          await Navigator.pushReplacement(context, MaterialPageRoute(builder:
                              (context)=>userlogin==true?
                          BottomBar(bottomindex: 2,):
                          LoginScreen()
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.purple, backgroundColor: Colors.white,
                        ),
                        child: Text('Continue',style: TextStyle(color: primary),),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppMaintanceDialog extends StatefulWidget {
  var appupdatetext;
  AppMaintanceDialog({this.appupdatetext});
  @override
  _AppMaintanceDialogState createState() => _AppMaintanceDialogState();
}

class _AppMaintanceDialogState extends State<AppMaintanceDialog> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child:  Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: white
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:  EdgeInsets.only( left: 10,right: 10 ),
                child: Container(
                    // color: black,
                    child:  Image.asset("assets/images/appbar_img.png",color: primary,),),
              ),

              SizedBox(height: 25),
              Text(
                '${widget.appupdatetext}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}