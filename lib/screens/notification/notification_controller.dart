import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';

class NotificationController extends GetxController {
  ///get Notification data....
  var notificationListLoading = false.obs;

  var LoadMoreDataloader = false.obs;
  var NoMoreDataloader = false.obs;
  ScrollController? notificationListScrollCtrl;
  var notificationListlimit = 10;
  var notificationListPage = 1;
  var notificationListtotalPage =0.obs ;
  TextEditingController notificationSearchCtrl=TextEditingController();
  List notificationListData = [];

  notificationListPaginationSearch(){
    notificationListScrollCtrl = ScrollController();
    log("orderListPaginationSearch");
    notificationListScrollCtrl?.addListener(() {


      if (notificationListScrollCtrl?.position.maxScrollExtent == notificationListScrollCtrl?.position.pixels && LoadMoreDataloader == false) {
        log("orderListPaginationSearch maxScrollExtent");

        if(NoMoreDataloader==false){
          LoadMoreDataloader(true);
          notificationListPage++;
          NotificationListApiCall('',notificationListPage,notificationListlimit,);
          update();
        }
      }else{
        update();
      }

    });
  }

  NotificationListApiCall(status,page,limit) async {
    if(page==1){
      notificationListData.clear();
      notificationListLoading(true);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }else{
      notificationListLoading(false);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }
    update();
    var url;
    url=notification_url+"?limit=${limit}"+"&page=${page}";

    log('Url==>'+url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    notificationListtotalPage.value =responsedata['total_page'] ?? 0;
    if(response.statusCode==200){
      if(responsedata['status']==true){
        log("responsedata==data>"+responsedata['data'].toString());
        if(responsedata['data'].length==0){
          NoMoreDataloader(true);
        }else{
          notificationListData.addAll(responsedata['data']);
          NoMoreDataloader(false);
        }
        notificationListLoading(false);
        LoadMoreDataloader(false);

        update();
      }
      else{
        if(responsedata['data'].length==0){
          NoMoreDataloader(true);
        }else{
          notificationListData=[];
          NoMoreDataloader(false);
        }
        notificationListLoading(false);
        LoadMoreDataloader(false);
        update();
      }

    }
    else if(response.statusCode==404){
      if(responsedata['data'].length==0){
        NoMoreDataloader(true);
      }else{
        notificationListData=[];
        NoMoreDataloader(false);
      }
      notificationListLoading(false);
      LoadMoreDataloader(false);
      update();
    }
  }
}
