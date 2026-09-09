import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/constant/validations.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';


class WithDrawController extends GetxController {
  void onInit() {
    WithdrawRequestPaginationSearch();
    super.onInit();
  }

  final String baseUrl = "$baseurl";
  var isLoading = false.obs;

  var requestLoading = false.obs;

  var LoadMoreDataloader = false.obs;
  var NoMoreDataloader = false.obs;
  ScrollController? RequestscrollCtrl =ScrollController();
  var withdrawrequestlimit = 20;
  var withdrawrequestPage = 1;
  var withdrawrequesttotalPage =0.obs ;
  List withdrawList = [];

  WithdrawRequestPaginationSearch(){
    log('yess');
    // RequestscrollCtrl = ScrollController();
    RequestscrollCtrl?.addListener(() {
      log('innn');
      if (RequestscrollCtrl?.position.maxScrollExtent == RequestscrollCtrl?.position.pixels && LoadMoreDataloader == false) {
        if(withdrawrequesttotalPage.value>=withdrawrequestPage){
          LoadMoreDataloader(true);
          withdrawrequestPage++;
          log('innn....${withdrawrequestPage}');
          getWithDrawRequest('','',withdrawrequestPage,withdrawrequestlimit,);
          update();
        }
      }else{
        update();
      }

    });
  }

  getWithDrawRequest(search,status,page,limit) async {
    if(page==1){
      withdrawList.clear();
      requestLoading(true);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }else{
      requestLoading(false);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }
    update();
    var url="${baseUrl}withdraw-request?page=${page}&limit=${limit}&paid_status=${status}";
    log('url==>'+url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    withdrawrequesttotalPage.value =responsedata['total_page'] ?? 0;
    if(response.statusCode==200){
      if(responsedata['status']==true){
        log("responsedata==>"+responsedata.toString());
        if(responsedata['data'].length==0){
          NoMoreDataloader(true);
        }else{
          withdrawList.addAll(responsedata['data']);
          NoMoreDataloader(false);
        }
        requestLoading(false);
        LoadMoreDataloader(false);
        update();
      }
      else{
        if(responsedata['data'].length==0){
          NoMoreDataloader(true);
        }else{
          withdrawList=[];
          NoMoreDataloader(false);
        }
        requestLoading(false);
        LoadMoreDataloader(false);
        update();
      }

    }
  }

  Future<void> addWithDrawRequest(String amount, String message) async {
    isLoading(true);
    var apiUrl=Uri.parse(addWithdraw_request);
    var body = <String, String>{
      'amount': amount,
      'message': message,
    };
    try {
      var response = await ApiBaseHelper().postAPICall(apiUrl,body, true,);
      var message = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("Inside addWithDrawRequest body${response.body}");
        await getWithDrawRequest('','',1,10);
        toastMsg(message['message'], false);
        isLoading(false);
        update();
      } else {
        print("inside else ");
        toastMsg(message['message'], true);
        // print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error sending API request: $e');
      toastMsg(e.toString(), true);
    } finally {
      isLoading(false);
      update();
    }
  }
}
