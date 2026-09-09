import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/Constant/SizeBox.dart';
import 'package:ifresh_delivery/Constant/custome_auth_design.dart';
import 'package:ifresh_delivery/Constant/validations.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/constant/strings.dart';
import 'package:ifresh_delivery/screens/forgot_password/forgot_controller.dart';
import 'package:ifresh_delivery/screens/forgot_password/forgot_password_screen.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/screens/forgot_password/forgot_controller.dart';
import 'package:pinput/pinput.dart';


// ignore: must_be_immutable
class OTPForgot extends StatefulWidget {
  String? mobileNo;
  String? newpass;
  String? conpass;
  String? otp;
  OTPForgot(this.mobileNo,this.newpass,this.conpass,this.otp,{super.key});

  @override
  State<OTPForgot> createState() => _OTPForgotState();
}

class _OTPForgotState extends State<OTPForgot> {


  ForgotController forgotController = Get.put(ForgotController());
  @override
  void initState() {
    // TODO: implement initState
    print('mobilwno ... ${widget.mobileNo}');
    print('conpass ... ${widget.conpass}');
    print('conpass ... ${widget.conpass}');
    forgotController.otpNo.text = widget.otp.toString();
    super.initState();
  }



  final formKey = GlobalKey<FormState>();
  bool resendDisable = false ;
  bool isDisplayTimer = false ;


  Future<void> resendOtp() async{
   print('gscvsdjgvdshjvcgsdhjvcshdj');
    var body ={
      "mobile": widget.mobileNo.toString(),
      "is_register": "0"
    };
    print(' body ... ${body}');
    print(widget.mobileNo);
    await forgotController.ResendOtp(Uri.parse(send_otp_url),body);

    setState(() {
      resendDisable = false;
      isDisplayTimer = false;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          Get.offAll(()=>ForgotPassword()); // Back to LoginPage
          return false;
        },
        child: AuthBackground(
            labelname: enter_otp,
            childs: Form(
              key: formKey,
              child: Column(
                children: [
                  sizebox_height_50,
                  Pinput(
                    length: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    errorTextStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.red
                    ),
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: primary),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red), // Set the error border color to red
                      ),
                    ),
                    controller: forgotController.otpNo,
                    autofocus: true,
                    isCursorAnimationEnabled: true,
                    validator: Validations.validateOtp,
                  ),
                  Container(
                    height: 40,
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isDisplayTimer == true ?
                        GestureDetector(
                          onTap: resendDisable
                              ? () {
                            resendOtp();
                          } : null,
                          child: Text(
                            resend,
                            style: TextStyle(
                                color: primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ) :
                        CircularCountDownTimer(
                          width: 40,
                          height: 40,
                          controller: forgotController.countDownController,
                          duration: 30,
                          fillColor: Colors.white,
                          ringColor: Colors.transparent,
                          isReverse: true,
                          isReverseAnimation: true,
                          textFormat: CountdownTextFormat.MM_SS,
                          textStyle:  TextStyle(
                              fontSize: 14,
                              color: primary,
                              fontWeight: FontWeight.w500),

                          onComplete: () {
                            setState(() {
                              resendDisable = true;
                              isDisplayTimer = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  sizebox_height_30,
                  GestureDetector(
                    onTap: () async {
                      var forgoturl = Uri.parse(forgot_url);
                      print('bcbc ${widget.mobileNo} +  ${widget.newpass} + ${widget.conpass}');
                       var otpbody ={
                         "mobile":widget.mobileNo.toString(),
                         "password":widget.newpass.toString(),
                         "password_confirmation":widget.conpass.toString(),
                         "otp":forgotController.otpNo.text.toString(),
                       };

                       await forgotController.ForgotApi(forgoturl, otpbody);
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
              ),
            )),
      ),
    );
  }
}
//

