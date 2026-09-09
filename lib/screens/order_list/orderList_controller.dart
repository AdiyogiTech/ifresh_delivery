import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Constant/ApiBaseHelper.dart';
import '../../Constant/validations.dart';
import '../../constant/api.dart';

class OrderListController extends GetxController {
  var detailsLoader = false.obs;
  var orderDetailsData = {}.obs;
  var DeliverLoader = false.obs;
  var DeliverData;

  ///get orderList data....
  var OrderListLoading = false.obs;

  var LoadMoreDataloader = false.obs;
  var NoMoreDataloader = false.obs;
  ScrollController? OrderListScrollCtrl;
  var orderListlimit = 10;
  var orderListPage = 1;
  var orderListtotalPage = 0.obs;
  TextEditingController orderSearchCtrl = TextEditingController();
  var orderListData = [].obs;
  @override
  void onClose() {
    OrderListScrollCtrl?.dispose();
    super.onClose();
  }

  orderListPaginationSearch({required String id_name}) {

    if (OrderListScrollCtrl != null) return;   // ⭐ ADD THIS LINE

    OrderListScrollCtrl = ScrollController();
    log("orderListPaginationSearch");

    OrderListScrollCtrl?.addListener(() {
      if (OrderListScrollCtrl?.position.maxScrollExtent ==
              OrderListScrollCtrl?.position.pixels &&
          LoadMoreDataloader == false) {
        log("orderListPaginationSearch maxScrollExtent");
        if (NoMoreDataloader == false) {
          LoadMoreDataloader(true);
          orderListPage++;
          OrderListApiCall(
            orderSearchCtrl.text,
            id_name,
            orderListPage,
            orderListlimit,
          );
          update();
        }
      } else {
        update();
      }
    });
  }

  OrderListApiCall(search, status, page, limit) async {
    if (page == 1) {
      orderListData.value.clear();
      OrderListLoading(true);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    } else {
      OrderListLoading(false);
      LoadMoreDataloader(true);
      NoMoreDataloader(false);
    }
    update();
    var url;
    url = order_list_url +
        "?limit=${limit}" +
        "&page=${page}&search=${search}&order_status=${status}";

    // if(status==''){
    //   url=orderListUrl+"?limit=${limit}"+"&page=${page}";
    // }else {
    //   url=orderListUrl+"?limit=${limit}"+"&page=${page}&order_status=${status}";
    // }
    log('Url==>' + url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    orderListtotalPage.value = responsedata['total_page'] ?? 0;
    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        log("responsedata==>" + responsedata.toString());
        if (responsedata['data'].length == 0) {
          NoMoreDataloader(true);
        } else {
          orderListData.value.addAll(responsedata['data']);
          NoMoreDataloader(false);
        }
        OrderListLoading(false);
        LoadMoreDataloader(false);

        update();
      } else {
        if (responsedata['data'].length == 0) {
          NoMoreDataloader(true);
        } else {
          orderListData.value = [];
          NoMoreDataloader(false);
        }
        OrderListLoading(false);
        LoadMoreDataloader(false);
        update();
      }
    } else if (response.statusCode == 404) {
      if (responsedata['data'].length == 0) {
        NoMoreDataloader(true);
      } else {
        orderListData.value = [];
        NoMoreDataloader(false);
      }
      OrderListLoading(false);
      LoadMoreDataloader(false);
      update();
    }
  }

  ///order status list........
  var OrderStatusDataLoading = false.obs;
  List OrderStatusData = [];

  OrderStatusApiCalling() async {
    OrderStatusDataLoading.value = true;
    OrderStatusData.clear();
    var url = order_status_url;
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        log("hgg---->" + responsedata.toString());
        OrderStatusData.addAll(responsedata['data']);
        OrderStatusDataLoading.value = false;
        update();
      } else {
        OrderStatusData = [];
        OrderStatusDataLoading.value = false;
        update();
      }
    }
  }

  ///order details ........
  var OrderDetailsDataLoading = false.obs;
  var OrderId = ''.obs;
  List OrderDetailsData = [];

  OrderDetailsApiCalling(id) async {
    OrderDetailsDataLoading.value = true;
    OrderDetailsData.clear();
    var url = order_details_url + '/${id}';
    log('url==>' + url.toString());
    var response = await ApiBaseHelper().getAPICall(Uri.parse(url), true);
    var responsedata = jsonDecode(response.body);
    log('responsedata11==>' + responsedata.toString());
    if (response.statusCode == 200) {
      if (responsedata['status'] == true) {
        log("hgg---->" + responsedata.toString());
        OrderDetailsData.add(responsedata['data']);
        log('OrderDetailsData11==>' + OrderDetailsData.toString());
        OrderDetailsDataLoading.value = false;
        update();
      } else {
        OrderDetailsData = [];
        OrderDetailsDataLoading.value = false;
        update();
      }
    }
  }

  ///order status update otp.....
  var statusOTPLoading = false.obs;
  var OTPData;

  TextEditingController otpController = TextEditingController();
  //
  // OrderStatusUpdateOtp(parameter, isCencel) async {
  //   var url = order_status_updateOtp_url;
  //   log('url==>$url');
  //   statusOTPLoading(true);
  //   try {
  //     log('Welcome Send OTP In Try');
  //     var response =
  //         await ApiBaseHelper().postAPICall(Uri.parse(url), parameter, true);
  //     OTPData = jsonDecode(response.body);
  //     if (response.statusCode == 200) {
  //       if (OTPData['status'] == true) {
  //         var msg = OTPData['data'];
  //         //Get.back();
  //         toastMsg(OTPData['message'].toString(), false);
  //         log('msg1==>' + msg.toString());
  //         if (isCencel == true) {
  //           cencelOtpCtrl.text = OTPData['data'].toString();
  //           toastMsg(OTPData['message'].toString(), false);
  //           log('jhj');
  //         } else if (isCencel == false) {
  //           otpController.text = OTPData['data'].toString();
  //           toastMsg(OTPData['message'].toString(), true);
  //         }
  //         statusOTPLoading(false);
  //       } else if (OTPData['status'] == false) {
  //         var msg = OTPData['data'];
  //         log('msg==>' + msg.toString());
  //         toastMsg(OTPData['message'].toString(), true);
  //         if (isCencel == true) {
  //           log('jhj3');
  //           cencelOtpCtrl.text = OTPData['data'].toString();
  //           toastMsg(OTPData['message'].toString(), false);
  //         } else if (isCencel == false) {
  //           log('jhj4');
  //           otpController.text = OTPData['data'].toString();
  //           toastMsg(OTPData['message'].toString(), false);
  //         }
  //         log('jhj2');
  //         toastMsg(OTPData['message'].toString(), false);
  //         toastMsg(msg.toString(), false);
  //         Get.back();
  //       } else {
  //         var msg = OTPData['data'];
  //         if (msg['mobile'] != null) {
  //           msg = msg['mobile'].toString();
  //           toastMsg(msg.toString(), true);
  //         }
  //         statusOTPLoading(false);
  //       }
  //       update();
  //       refresh();
  //     } else {
  //       OTPData = [];
  //       statusOTPLoading(false);
  //       update();
  //       refresh();
  //     }
  //   } catch (e) {
  //     print('Welcome Send OTP In Catch\n ${e}');
  //     // toastMsg(msg, false)
  //     statusOTPLoading(false);
  //     update();
  //   }
  // }
  OrderStatusUpdateOtp(parameter, isCencel) async {
    var url = order_status_updateOtp_url;
    log('url==>$url');

    statusOTPLoading(true);

    try {
      log('Welcome Send OTP In Try');

      var response =
      await ApiBaseHelper().postAPICall(Uri.parse(url), parameter, true);

      OTPData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var msg = OTPData['data'];

        if (OTPData['status'] == true) {
          toastMsg(OTPData['message'].toString(), false);
          log('msg1==>${msg.toString()}');

          if (isCencel == true) {
            cencelOtpCtrl.text = msg.toString();
          } else {
            otpController.text = msg.toString();
          }
        }
        else if (OTPData['status'] == false) {
          log('msg==>${msg.toString()}');
          toastMsg(OTPData['message'].toString(), false);

          if (isCencel == true) {
            cencelOtpCtrl.text = msg.toString();
          } else {
            otpController.text = msg.toString();
          }

          // Get.back();
        }
        else {
          if (msg['mobile'] != null) {
            toastMsg(msg['mobile'].toString(), true);
          }
        }

        update();
        refresh();
      }
      else {
        OTPData = [];
      }
    }
    catch (e) {
      print('Welcome Send OTP In Catch\n $e');
    }
    finally {
      statusOTPLoading(false);
      update();
      refresh();
    }
  }

  ///order status update .....
  var updateOrderStatusLoading = false.obs;
  OrderStatusUpdate(parameter) async {
    var url = order_status_update_url;
    log('url==>' + url.toString());
    updateOrderStatusLoading(true);
    try {
      var response =
          await ApiBaseHelper().postAPICall(Uri.parse(url), parameter, true);
      var responsedata = jsonDecode(response.body);
      log('OTPData==>' + OTPData.toString());
      if (response.statusCode == 200) {
        print("sucess code----->");
        if (responsedata['status'] == true) {
          OrderDetailsApiCalling(OrderId.value);
          Get.back();
          log('responsedata==>' + responsedata.toString());
          toastMsg(responsedata['message'], false);
          updateOrderStatusLoading(false);
          update();
        } else {
          toastMsg(responsedata['message'], true);
          updateOrderStatusLoading(false);
          update();
        }
      } else if (response.statusCode == 422) {
        toastMsg(responsedata['message'], true);
        updateOrderStatusLoading(false);
        update();
      } else {
        updateOrderStatusLoading(false);
        update();
      }
    } catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      updateOrderStatusLoading(false);
      update();
    }
  }

  ///order cencel .....
  var OrderCencelLoading = false.obs;
  TextEditingController cencelOtpCtrl = TextEditingController();

  OrderCencel(parameter) async {
    var url = order_item_cencel_url;
    log('url==>' + url.toString());
    OrderCencelLoading(true);
    try {
      var response =
          await ApiBaseHelper().postAPICall(Uri.parse(url), parameter, true);
      var responsedata = jsonDecode(response.body);
      log('responsedata==>' + responsedata.toString());
      if (response.statusCode == 200) {
        print("sucess code----->");
        if (responsedata['status'] == true) {
          Get.back();
          OrderDetailsApiCalling(OrderId.value);
          log('responsedata==>' + responsedata.toString());
          toastMsg(responsedata['message'], false);
          OrderCencelLoading(false);
          update();
        } else {
          toastMsg(responsedata['message'], true);
          OrderCencelLoading(false);
          update();
        }
      } else if (response.statusCode == 422) {
        toastMsg(responsedata['message'], true);
        OrderCencelLoading(false);
        update();
      } else {
        OrderCencelLoading(false);
        update();
      }
    } catch (e) {
      print('Welcome Send OTP In Catch\n ${e}');
      OrderCencelLoading(false);
      update();
    }
  }

  void setStaticOrderDetails(String orderId) {
    print('inside setStaticOrderDetails with orderId: $orderId');
    detailsLoader(true);
    try {
      // Assuming a static lookup for simplicity
      var staticOrderDetails = {
        "order_no": "12345",
        "id": orderId,
        "customer_name": "John Doe",
        "customer_mobile": "1234567890",
        "total_price": "100.00",
        "payment_type_name": "Cash",
        "pickup_otp": "7890",
        "delivery_status_name": "Pending",
        "order_date": "10-03-2025",
        "gst": "5%",
        "amount": "1000",
        "delivery_datetime": "2023-12-25T10:00:00",
        "items": [
          {"item_name": "Product 1", "quantity": 1, "price": "50.00"},
          {"item_name": "Product 2", "quantity": 1, "price": "50.00"}
        ]
      };

      orderDetailsData.assignAll(staticOrderDetails);
      detailsLoader(false);
      update();
    } catch (e) {
      print("Error in setting static order details data: $e");
      detailsLoader(false);
      update();
    }
  }

  ///delivery order status
  var updateDeliveryOrderStatusLoading = false.obs;
  updateDeliveryOrderStatusUpdate(parameter) async {
    var url = delivery_order_update_status;
    log('url==>$url');
    updateDeliveryOrderStatusLoading(true);
    try {
      var response =
          await ApiBaseHelper().postAPICall(Uri.parse(url), parameter, true);
      var responsedata = jsonDecode(response.body);
      log('this is here ${responsedata}');
      if (response.statusCode == 200) {
        print("sucess code----->");
        if (responsedata['status'] == true) {
          toastMsg(responsedata['message'], false);
          updateDeliveryOrderStatusLoading(false);
          update();
        } else {
          toastMsg(responsedata['message'], true);
          updateDeliveryOrderStatusLoading(false);
          update();
        }
      } else if (response.statusCode == 422) {
        toastMsg(responsedata['message'], true);
        updateOrderStatusLoading(false);
        update();
      } else {
        updateOrderStatusLoading(false);
        update();
      }
    } catch (e) {
      print('Welcome what is error In Catch\n ${e}');
      updateOrderStatusLoading(false);
      update();
    }
  }
}
