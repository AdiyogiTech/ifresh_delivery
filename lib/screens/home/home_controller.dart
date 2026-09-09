import 'dart:developer';

import 'package:get/get.dart';
import 'dart:convert';

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class HomeController extends GetxController {
  var dashBordDataLoading = false.obs;
  List dashbordData = [];

  DashbordApiCalling() async {
    dashBordDataLoading.value =true;
    dashbordData.clear();

    var url=dashboard_url;
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    if(response.statusCode==200){
      if(responsedata['status']==true){
        log("hgg---->"+responsedata.toString());
        dashbordData.add(responsedata['data']);
        dashBordDataLoading.value =false;
        update();
      }
      else{
        dashbordData =[];
        dashBordDataLoading.value =false;
        update();
      }

    }
  }
}
