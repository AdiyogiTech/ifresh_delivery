import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ifresh_delivery/Constant/validations.dart';
import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:ifresh_delivery/helper_widget/bottombar.dart';
import 'package:ifresh_delivery/main.dart';
// import 'package:ifresh_delivery/screens/login/otp_screen.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/screens/otp/otp_screen.dart';

class LoginController extends GetxController{

  var loginLoading = false.obs;
  var otpLoading = false.obs;
  var loginOtpLoading = false.obs;
  var login_data ;

  var otp_data ;


  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String ?_token;
  String? get token => _token;

  Future getToken() async {
    print("CheckCheck 1");
    try{
      print("FCM: getting...");

      FirebaseMessaging.instance.getToken().then((token){
        _token = token;
      });
      _token = await FirebaseMessaging.instance.getToken();

      print("FCM TOKEN : $_token");

      // prefs!.setString("token", _token!);
      prefs!.setString("token", login_data["data"]["token"]);
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        _token = token;
      });
      print("FCM 1 : $_token");
    }catch(e){
      print("Exception : $e");
    }
    print("CheckCheck 2");
  }


  @override
  void onReady() {
    getToken();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  LoginAPiCall(url,parameter) async {
    loginLoading.value=true;
    try {
      var result = await ApiBaseHelper().postAPICall(url, parameter, false);
      login_data = jsonDecode(result.body);
      // ignore: unnecessary_null_comparison
      if (result != null) {
        if (result.statusCode == 200) {
          login_data = jsonDecode(result.body);
          if (login_data["status"] == true) {
            print("inside login sucess login_data..." + login_data.toString());
            ApiBaseHelper().logindata(login_data);
            Get.offAll(BottomBar(bottomindex: 1,));
            mobileController.clear();
            passwordController.clear();
          }
          else {
            toastMsg(login_data["message"].toString(), true);
          }

          loginLoading.value = false;
          update();
        }else{
          var error_data = jsonDecode(result.body);
          print("error_data..."+error_data.toString());
          var msg = error_data["message"].toString();
          toastMsg(msg, true);
          login_data=[];
          loginLoading.value=false;
          update();
        }
      }
    } catch (e) {
      print("catch error ........${e}");
      loginLoading.value=false;
      update();
    }
  }


  SendOtpAPiCall(url,parameter) async {
    otpLoading(true);
    try {
      var result = await ApiBaseHelper().postAPICall(url, parameter, false);
      otp_data = jsonDecode(result.body);
      if (result != null) {
        if (result.statusCode == 200) {

          if (otp_data['status'] == true) {
            toastMsg(otp_data['message'].toString(), false);
            Get.to(OTPLogin(mobileNo: mobileController.text.toString()));
          } else {
            toastMsg(otp_data['message'].toString(), true);
          }
          otpLoading(false);
          update();
        }else if (result.statusCode == 422) {
          otp_data = jsonDecode(result.body);
          print("otp_data..."+otp_data.toString());
          toastMsg(otp_data['message'], true);
          otpLoading(false);
          update();
        }

        else{
          login_data=[];
          otpLoading(false);
          update();
        }
      }
    } catch (e) {
      print("catch error ........$e");
      otpLoading(false);
      update();
    }
  }


}