import 'dart:convert';

import 'package:get/get.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Colors/colors.dart';
import '../../Constant/ApiBaseHelper.dart';
import '../../Constant/SizeBox.dart';
import '../../constant/api.dart';
import 'WalletController.dart';

class WalletController extends GetxController {
  final ApiBaseHelper _apiHelper = ApiBaseHelper();
  List transactionsList = [];
  RxString balance = '0.00'.obs;
  Future<void> getWalletTransactions() async {
    var apiUrl = Uri.parse('${baseurl}get-wallet?page=1&limit=10&search=&type=0');

    try {
       var response = await _apiHelper.getAPICall(apiUrl, true);
      var jsonResponse = jsonDecode(response.body);
       if (jsonResponse['status'] == true) {
         balance.value = jsonResponse['data']['delivery_boy']['user_balance'];
         transactionsList = jsonResponse['data']['wallet'];
       } else {
         log("Failed to load transactions: ${jsonResponse['message']}");
       }
    } catch (e) {
      print("Error fetching wallet transactions: $e");
    }
  }
}
