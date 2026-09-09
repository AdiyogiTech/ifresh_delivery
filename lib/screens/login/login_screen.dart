import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/constant/custome_auth_design.dart';
import 'package:ifresh_delivery/constant/custome_textform_field.dart';
import 'package:ifresh_delivery/constant/strings.dart';
import 'package:flutter/gestures.dart';
import 'package:ifresh_delivery/constant/validations.dart';
import 'package:ifresh_delivery/screens/forgot_password/forgot_password_screen.dart';
import 'package:ifresh_delivery/screens/login/Login_controller.dart';
import 'package:ifresh_delivery/screens/otp/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  LoginController loginController =Get.put(LoginController());
  TextEditingController passwordController = TextEditingController();



  var isOtpLogin;
  bool viewpass = true;
  @override
  void initState() {
     super.initState();
     isOtpLogin= int.parse(setting_complete_data['data']['settings']['is_otp_allow'].toString());
     print("isOtpLogin....."+isOtpLogin.toString());
     // loginController.getToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthBackground(
        childs: Form(
          key: formKey,
          child: Column(
            children: [
              sizebox_height_60,
              // sizebox_height_50,
              isOtpLogin !=0 ?
              AuthTextField(
                  controller: loginController.mobileController,
                  hintText: "mobile",
                  length: 10,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validations.validateMobile,
                  IconImage: 'assets/images/phone.png',
                  iconColor: primary,
                  Imagescale: 1.9
              )
                  : Column(
                children: [
                  AuthTextField(
                      controller: loginController.mobileController,
                      hintText: "mobile",
                      length: 10,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: Validations.validateMobile,
                      IconImage: 'assets/images/phone.png',
                      iconColor: primary,
                      Imagescale: 1.9
                  ),
                  AuthTextField(
                    hintText: password,
                    length: 12,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscure: viewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    iconColor: primary,
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: Validations.validatePassword,
                    controller: loginController.passwordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          if (viewpass) {
                            //if viewpass == true, make it false
                            viewpass = false;
                          } else {
                            viewpass = true; //if viewpass == false, make it true
                          }
                        });
                      },
                      icon: Icon(
                        viewpass == true ? Icons.visibility_off : Icons.visibility,
                        color: primary,
                        size: 24,
                      ),
                    ),
                    hoverColor: Color.fromRGBO(54, 54, 54, 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: forgot_text,
                          style:  TextStyle(
                              color: primarylogin,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  ForgotPassword(),
                                ),
                              );
                            },
                        ),

                      ),
                      sizebox_width_15,
                    ],
                  ),
                ],
              ),


              sizebox_height_50,
              GestureDetector(
                onTap: isOtpLogin != 0 ? (){

                  if(formKey.currentState!.validate()){
                    var otpUrl = Uri.parse(send_otp_url);
                    var body = {
                      "mobile":  loginController.mobileController.text.trim(),
                      "is_register": "0".toString()
                    };
                    log("body for otp login.....$body");
                    loginController.SendOtpAPiCall(otpUrl, body);
                  }
                } :
                    (){
                  if(formKey.currentState!.validate()){
                    var loginUrl = Uri.parse(login_url);
                    var body = {
                      "mobile":  loginController.mobileController.text,
                      "password": loginController.passwordController.text,
                      "fcm_id" : loginController.token.toString(),
                    };
                    print("body for pass login...."+body.toString());
                    loginController.LoginAPiCall(loginUrl, body);
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
          ),
        ), labelname: 'LOGIN',
      ),
    );
  }

}

