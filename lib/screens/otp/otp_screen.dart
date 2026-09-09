import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/constant/custome_auth_design.dart';
import 'package:ifresh_delivery/constant/strings.dart';
import 'package:ifresh_delivery/constant/validations.dart';
import 'package:ifresh_delivery/screens/login/Login_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:ifresh_delivery/helper_widget/bottombar.dart';

import '../../main.dart';

class OTPLogin extends StatefulWidget {
  // final String mobileNo;
  var mobileNo;
 // var otp;
 // OTPLogin( {this.mobileNo,this.otp});
  OTPLogin( {this.mobileNo});

  @override
  State<OTPLogin> createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  TextEditingController otpController = TextEditingController();
  CountDownController countDownController = CountDownController();
  final formKey = GlobalKey<FormState>();
  LoginController loginController =Get.put(LoginController());
  bool resendDisable = false ;

  void submit() {
    print('Otp is ::..:: }');
    if(formKey.currentState!.validate()){
      var otpText = otpController.text;
      print('Otp is ::.. ${otpText}');
      // Get.to(HomeScreen());
      // otpController.clear();
    }
  }

  void resendOtp() {
    otpController.clear();
    var otpUrl = Uri.parse(send_otp_url);

    var body = {
      "mobile": widget.mobileNo.toString(),
      "is_register": "0".toString()
    };
    print("body....."+body.toString());
    loginController.SendOtpAPiCall(otpUrl, body);
    // print(widget.mobileNo);
    countDownController.start();
    var i = 0;print(" resend.............${i++}.");
    setState(() {
      resendDisable = false;
    });
  }

  final defaultPinTheme = PinTheme(
    width: 45,
    height: 45,
    margin: EdgeInsets.symmetric(horizontal: 2),
    padding: EdgeInsets.all(12),
    textStyle: TextStyle(fontSize: 16, color: Colors.black54),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey)
    ),
  );

  void _registerForegroundMessageHandler() {
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print(" --- foreground message received ---");
      print(remoteMessage.notification!.title);
      print(remoteMessage.notification!.body);
      var title = remoteMessage.notification!.title;
      var body = remoteMessage.notification!.body;
      _showNotification(title,body);
      // Get.snackbar(title,body);
    });
  }

  Future<void> _showNotification(titles,bodys) async {
    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    // var androidPlatformChannelSpecifics =   AndroidNotificationDetails(
    //   'your channel id',
    //   'your channel name',
    //   importance: Importance.max,
    //   priority: Priority.high,
    //   ticker: 'ticker',
    //   playSound: true,
    //   fullScreenIntent: true, // If needed
    //   enableVibration: true,
    //   setAsGroupSummary: true,
    //   styleInformation: DefaultStyleInformation(true, true),
    //   // additionalFlags: Int32List.fromList(<int>[4]), // FLAG_IMMUTABLE
    // );
    //
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics);

    // android: androidPlatformChannelSpecifics, iOS: iosDetail);
    // await flutterLocalNotificationsPlugin.show(0, titles, bodys, NotificationDetails(android: androidPlatformChannelSpecifics), );
  }

  @override
  void initState() {
    super.initState();
    var mobile = widget.mobileNo.toString();
    _registerForegroundMessageHandler();
   // otpController.text = widget.otp.toString();
    print("mobile......"+mobile.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: AuthBackground(
            labelname: "enter otp",
            childs: Column(
              children: [
                sizebox_height_70,
                Pinput(
                  length: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  errorTextStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.red
                  ),
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.grey),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red), // Set the error border color to red
                    ),
                  ),
                  controller: otpController,
                  autofocus: true,
                  isCursorAnimationEnabled: true,
                  validator: Validations.validateOtp,
                ),

                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: resendDisable
                            ? () {
                          resendOtp();
                        } : null,
                        child: Text(
                          resend, //Resend
                          style: TextStyle(
                              color: resendDisable==true?primary:Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                      CircularCountDownTimer(
                        width: 40,
                        height: 40,
                        controller: countDownController,
                        duration: 60,
                        fillColor: Colors.white,
                        ringColor: Colors.transparent,
                        isReverse: true,
                        isReverseAnimation: true,
                        textFormat: CountdownTextFormat.MM_SS,
                        textStyle:  TextStyle(
                            fontSize: 14,
                            color: primary,
                            fontWeight: FontWeight.w500),
                        onStart: () {
                          // setState(() {
                          //   resendDisable = true;
                          // });
                        },
                        onComplete: () {
                          setState(() {
                            resendDisable = true;
                          });
                        },
                      )
                    ],
                  ),
                ),
                sizebox_height_30,
                GestureDetector(
                  onTap: () {
                    if(formKey.currentState!.validate()){
                      var loginUrl = Uri.parse(login_url);
                      var body = {
                        "mobile":  widget.mobileNo.toString(),
                        "otp": otpController.text,
                        // "password":otpController.text
                        "fcm_id" : loginController.token.toString(),
                      };
                      print("body....."+body.toString());
                      loginController.LoginAPiCall(loginUrl, body);
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomBar(bottomindex: 1,)));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                        border: Border.fromBorderSide(BorderSide(
                            width: 5,
                            color: primarylogin
                        ))
                    ),
                    child: CircleAvatar(
                      radius: 31,
                      backgroundColor: primarylogin,
                      child: Center(
                          child: Icon(Icons.arrow_forward_ios_rounded,
                            color: white,
                            size: 35,
                          ) ),
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}


