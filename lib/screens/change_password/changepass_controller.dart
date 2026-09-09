import 'dart:convert';
import 'package:ifresh_delivery/Constant/validations.dart';
import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:get/get.dart';


class ChangePassController extends GetxController{

  var ChangeLoading = false.obs;
  var ChangeData ;


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ChangeApi(url,parameter) async {

    ChangeLoading(true);
    try{
      print('Welcome Send OTP In Try');
      var response = await ApiBaseHelper().postAPICall(url, parameter, true);
      ChangeData = jsonDecode(response.body);
      if(response.statusCode == 200){
        print('Welcome Send OTP 200');
        var msg= ChangeData['message'];
        toastMsg(msg.toString(),false);
        Get.back();
        print('hello in if');
        ChangeLoading(false);

        update();
        refresh();
      }
      else if(response.statusCode == 422){
        var msg= ChangeData['message'];
        toastMsg(msg.toString(),true);
        print('hello in if');
        ChangeLoading(false);
        // Get.back();
        update();
        refresh();
      }
      else  {
        // var msg= ChangeData['message'];
        // toastMsg(msg.toString(),false);
        ChangeData=[];
        ChangeLoading(false);
        update();
        refresh();
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      // toastMsg(msg, false)
      ChangeLoading(false);
      update();
    }
  }
}

