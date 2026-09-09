import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ifresh_delivery/Constant/ApiBaseHelper.dart';
import 'package:ifresh_delivery/Constant/validations.dart';
import 'package:ifresh_delivery/main.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  var ProfileLoader=false.obs;
  var ProfileData;
  var image;
  var name;
  var email;
  var mobile;
  var address;
  var country_name;
  var country_id;
  var state_name;
  var state_id;
  var city_name;
  var city_id;
  var profileData;

  var status = false;
  bool _locationStatusInitialized = false;
  TextEditingController nameController =TextEditingController();
  TextEditingController mobileController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  TextEditingController addressController =TextEditingController();
  @override
  void onReady() {
    super.onReady();
  }
  @override
  void onClose() {
    super.onClose();
  }

  GetProfileData(url) async{
    ProfileLoader(true);
    try{
      var response = await ApiBaseHelper().getAPICall(url, true);
      if(response.statusCode == 200){
        ProfileData = jsonDecode(response.body);
        var msg =ProfileData["message"].toString();
        // toastMsg(msg,true);
        print("inside setting >>-----> $msg");

        profileData = ProfileData["data"];
        // Location ON/OFF is controlled by the app bar button only.
        // Sync from API only once so page refreshes / order-detail opens
        // do not flip the toggle.
        if (!_locationStatusInitialized) {
          final locStatus = profileData["location_status"];
          status = locStatus == true ||
              locStatus == "true" ||
              locStatus == 1 ||
              locStatus == "1";
          _locationStatusInitialized = true;
        }
        name = profileData["name"].toString() != "null" ?profileData["name"].toString() :" ";
        nameController.text = name;

        image = profileData["image"].toString() != "null" ?profileData["image"].toString() :"assets/images/profile2.png";
        mobile = profileData["mobile"].toString() != "null" ?profileData["mobile"].toString() :" ";
        mobileController.text = mobile;
        email = profileData["email"].toString() != "null" ?profileData["email"].toString() :" ";
        emailController.text = email;
        address = profileData["address"].toString() != "null" ?profileData["address"].toString() :" ";
        addressController.text = address;
        country_name = profileData["country_name"].toString() != "null" ?profileData["country_name"].toString() :" ";
        state_name = profileData["state_name"].toString() != "null" ?profileData["state_name"].toString() :" ";
        city_name = profileData["city_name"].toString() != "null" ?profileData["city_name"].toString() :" ";
        country_id = profileData["country_id"].toString() != "null" ?profileData["country_id"].toString() :" ";
        state_id = profileData["state_id"].toString() != "null" ?profileData["state_id"].toString() :" ";
        city_id = profileData["city_id"].toString() != "null" ?profileData["city_id"].toString() :" ";
        prefs!.setString('profileImage_url',image.toString());
        prefs!.setString('user_name',name.toString());
        ProfileLoader(false);
        update();
        refresh();
      }
    }
    catch(e){
      print("catch error====>"+e.toString());
      update();
    }
  }
}
