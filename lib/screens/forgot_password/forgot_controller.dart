import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:ifresh_delivery/Constant/validations.dart';
import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:ifresh_delivery/screens/forgot_password/forgototp_screen.dart';
import 'package:ifresh_delivery/screens/login/login_screen.dart';
import 'package:get/get.dart';


class ForgotController extends GetxController {

  var forgotLoading = false.obs;
  var forgotrData ;

  var OTPLoading = false.obs;
  var OTPData ;

  var ResendOTPLoading = false.obs;
  var ResendOTPData ;
  
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  TextEditingController newPass = TextEditingController();
  TextEditingController conPass = TextEditingController();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController otpNo = TextEditingController();
  CountDownController countDownController =CountDownController();

  ForgotSendOtp(url,parameter) async {
    OTPLoading(true);
    try{
      print('Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      OTPData = jsonDecode(response.body);
      if(response.statusCode == 200){
        if(OTPData['status'] == true){
          var msg= OTPData['data'];
          toastMsg(msg.toString(),false);
          Get.to(OTPForgot(mobileNo.text.toString(),newPass.text.toString(),conPass.text.toString(),msg.toString()));
          OTPLoading(false);
        }else{
          var msg=OTPData ['data'];
          if(msg['mobile']!= null){
            msg  = msg['mobile'].toString();
            toastMsg(msg.toString(),true);
          }
          OTPLoading(false);
        }
        update();
        refresh();
      }
      else  {
        OTPData=[];
        OTPLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      // toastMsg(msg, false)
      OTPLoading(false);
      update();
    }
  }
  
  ForgotApi(url,parameter) async {
    forgotLoading(true);
    try{
      print('Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      forgotrData = jsonDecode(response.body);
      if(response.statusCode == 200){
        print('200200200200200200200');
        if(forgotrData['status'] == true){
          var msg= forgotrData['message'];
          toastMsg(msg.toString(),false);
          Get.offAll(LoginScreen());
          forgotLoading(false);
          newPass.clear();  // Clear all Controller
          conPass.clear();
          mobileNo.clear();
          otpNo.clear();
        }else{
          var msg=forgotrData ['data'];
          if(msg['mobile']!= null){
            msg  = msg['mobile'].toString();
            toastMsg(msg.toString(),false);
          }
          forgotLoading(false);
        }
        update();
        refresh();
      }
      else if(response.statusCode == 422){
        var msg= forgotrData['message'];
        toastMsg(msg.toString(),true);
      }
      else  {
        forgotrData=[];
        forgotLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      // toastMsg(msg, false)
      forgotLoading(false);
      update();
    }
  }

  ResendOtp(url,parameter)async{
    print('Welcome Send OTP Loading');
    ResendOTPLoading(true);
    try{
      print('Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, false);
      ResendOTPData = jsonDecode(response.body);
      if(response.statusCode == 200){
        var msg= ResendOTPData['data'];
        toastMsg(msg.toString(),false);
        countDownController.reset();
        ResendOTPLoading(false);
        update();
        refresh();

      }
      else  {
        ResendOTPData=[];
        ResendOTPLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      // toastMsg(msg, false)
      ResendOTPLoading(false);
      update();
    }
  }
}

