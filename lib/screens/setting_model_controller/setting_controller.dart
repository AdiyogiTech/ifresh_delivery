import 'dart:convert';

import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:get/get.dart';


class SettingController extends GetxController{

  var setting_responce;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  SettingData(url)async{
    print('inside url $url');
    try{
      var  setting_responce=  await ApiBaseHelper().getAPICall(url,false);
      print("setting_responce==>"+setting_responce.statusCode.toString());
      if(setting_responce.statusCode == 200){
        var responce = jsonDecode(setting_responce.body);
        print("inside setting_responce.."+responce['data'].toString());
        ApiBaseHelper().settingdata(responce);
        update();
      }else {
        update();
      }

    }
    catch (e){
      print("catch error  setting=>"+e.toString());
      update();
    }
  }
}