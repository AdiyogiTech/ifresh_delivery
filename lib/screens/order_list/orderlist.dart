import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/screens/order_list/orderList_controller.dart';
import 'package:ifresh_delivery/screens/orderdetails/order_details.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  OrderListController orderListController = Get.put(OrderListController());

  List<Map<String, dynamic>> headingList = [
    {
      "name": "All",
    },
    {
      "name": "Order Placed",
    },
    {
      "name": "Order Confirmed",
    },
    {
      "name": "Order Dispatched",
    },
    {
      "name": "Delivered",
    },
    {
      "name": "Cancelled",
    },
  ];

  OutlineInputBorder _OutlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderColor, width: 1),
    );
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      orderListController.orderListPaginationSearch(id_name: '');
      getOrderlistData();
    });
  }

  var currentIndex;

  getOrderlistData() async {
    orderListController.orderListPage = 1;
    orderListController.orderListlimit = 10;
    await orderListController.OrderListApiCall(orderListController.orderSearchCtrl.text,'',orderListController.orderListPage, orderListController.orderListlimit);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
        displacement: 50,
        backgroundColor: Colors.white,
        color: primarylogin,
        strokeWidth: 2,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          orderListController.orderListPage = 1;
          orderListController.orderListlimit = 10;
          await orderListController.OrderListApiCall(
              orderListController.orderSearchCtrl.text,
              '',
              orderListController.orderListPage,
              orderListController.orderListlimit);
        },
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                itemCount: headingList.length,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        currentIndex = index;
                      });
                      orderListController.orderListPaginationSearch(id_name: headingList[index]['name'].toString());
                      await orderListController.OrderListApiCall(
                          orderListController.orderSearchCtrl.text,
                          currentIndex == 0 ? '' : currentIndex,
                          1,
                          10
                      );
                      log('orderListData==>'+orderListController.orderListData.toString());
                      print("currentIndex --->"+currentIndex.toString());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: currentIndex == index ? primarylogin : Colors.white,
                        border: Border.all(
                          width: 1,
                          color: currentIndex == index ? Colors.transparent : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        headingList[index]['name'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: currentIndex == index ? Colors.white : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  onChanged: (searchValue) async {
                    await orderListController.OrderListApiCall(
                        searchValue,
                        '',
                        orderListController.orderListPage,
                        orderListController.orderListlimit
                    );
                  },
                  controller: orderListController.orderSearchCtrl,
                  cursorColor: primarylogin,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primarylogin, width: 1.5),
                    ),
                    hintText: "Search orders...",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Orders List
            Expanded(
              child: GetBuilder<OrderListController>(
                builder: (orderListController) {
                  if (orderListController.OrderListLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primarylogin,
                        strokeWidth: 2,
                      ),
                    );
                  } else if (orderListController.orderListData.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 40,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No orders found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: orderListController.orderListData.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var Orders = orderListController.orderListData[index];

                        log("order status here ${Orders['order_status_id']} & ${Orders['delivery_boy_order_status']}");

                        var orderNo = Orders['order_no'].toString() != "null"
                            ? Orders['order_no'].toString()
                            : "";
                        var id = Orders['id'].toString() != "null"
                            ? Orders['id'].toString()
                            : "";
                        var customer_name = Orders['customer_name'].toString() != "null"
                            ? Orders['customer_name'].toString()
                            : "";
                        var customer_mobile = Orders['customer_mobile'].toString() != "null"
                            ? Orders['customer_mobile'].toString()
                            : "";
                        var total_price = Orders['total_price'].toString() != "null"
                            ? Orders['total_price'].toString()
                            : "";
                        var payment_type_name = Orders['payment_type_name'].toString() != "null"
                            ? Orders['payment_type_name'].toString()
                            : "";
                        var pickup_otp = Orders['pickup_otp'].toString() != "null"
                            ? Orders['pickup_otp'].toString()
                            : "";
                        var delivery_status_name = Orders['order_status_id'].toString() != "null"
                            ? Orders['order_status_id'].toString()
                            : "";
                        String formattedDate;
                        String formattedTime;
                        String amPmIndicator;
                        if (Orders["delivery_datetime"].toString() != "null") {
                          String timestamp = Orders["delivery_datetime"].toString();
                          DateTime dateTime = DateTime.parse(timestamp);
                          formattedDate = "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month}-${dateTime.year}";
                          formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                          amPmIndicator = DateFormat('a').format(dateTime);
                        } else {
                          formattedDate = "--/--/----";
                          formattedTime = "--:--";
                          amPmIndicator = "";
                        }

                        return GestureDetector(
                          onTap: () {
                            orderListController.OrderId.value = Orders['id'].toString();
                            Get.to(OrderDetailsPage(indexx: index));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Order Icon
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: getStatusColorId(Orders['order_status_id'].toString()).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.receipt_outlined,
                                        color: getStatusColorId(Orders['order_status_id'].toString()),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Order Details
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  orderNo,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            DateFormat("dd MMM, yyyy").format(DateTime.parse(Orders['date'])),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.person_outline,
                                                size: 12,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  customer_name.capitalize ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.phone_outlined,
                                                size: 12,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                customer_mobile,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Price and Status
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "₹${Orders['total'].toString()}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: getStatusColorId(Orders['order_status_id'].toString()).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              getPaymentStatusId(Orders['order_status_id'].toString()),
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                color: getStatusColorId(Orders['order_status_id'].toString()),
                                              ),
                                            ),
                                          ),
                                          if (Orders["delivery_status_id"].toString() == "7")
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                "OTP: $pickup_otp",
                                                style: const TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                // Accept/Reject Buttons
                                if (Orders['order_status_id'] == 2 && Orders['delivery_boy_order_status'] == 1)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return _showDialogButton(
                                                        () async {
                                                      await orderListController.updateDeliveryOrderStatusUpdate({
                                                        'vendor_order_id': Orders['id'].toString(),
                                                        'delivery_order_status': '2'
                                                      });
                                                      orderListController.orderListPaginationSearch(id_name: '');
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              minimumSize: const Size(double.infinity, 36),
                                            ),
                                            child: const Text('Accept'),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return _showDialogButton(
                                                        () async {
                                                      await orderListController.updateDeliveryOrderStatusUpdate({
                                                        'vendor_order_id': Orders['id'].toString(),
                                                        'delivery_order_status': '3'
                                                      });
                                                      orderListController.orderListPaginationSearch(id_name: '');
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              minimumSize: const Size(double.infinity, 36),
                                            ),
                                            child: const Text('Reject'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  ///for payments status....
  String getPaymentStatusId(String fullDay) {
    Map<String, String> dayMapping = {
      '1': 'Order Placed',
      '2': 'Order Confirmed',
      '3': 'Order Dispatched',
      '4': 'Delivered',
      '5': 'Cancelled',
    };
    return dayMapping[fullDay] ?? fullDay;
  }

  Color getStatusColorId(String fullDay) {
    Map<String, Color> dayMapping = {
      '1': Colors.orange,
      '2': Colors.green,
      '3': Colors.blue,
      '4': Colors.green,
      '5': Colors.red,
    };

    return dayMapping[fullDay] ?? Colors.grey;
  }

  ///drop down button
  AlertDialog _showDialogButton(Function function) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Confirm Action',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: const Text(
        'Are you sure you want to proceed?',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            function();
            Get.back();
            orderListController.orderListPaginationSearch(id_name: '');
            orderListController.orderListPage = 1;
            orderListController.orderListlimit = 10;
            orderListController.OrderListApiCall(
                orderListController.orderSearchCtrl.text,
                '',
                orderListController.orderListPage,
                orderListController.orderListlimit);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primarylogin,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

//
// class CustomDialogBox extends StatelessWidget {
//   final String message;
//   final Future<void> Function() onConfirm; // Change VoidCallback to Future<void> Function()
//
//   const CustomDialogBox({
//     Key? key,
//     required this.message,
//     required this.onConfirm,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Confirmation!'),
//       content: Text(message),
//       actions: [
//         ElevatedButton(
//           onPressed: () async {
//             await onConfirm(); // Wait for the async function to complete
//             Navigator.of(context).pop(); // Close dialog after completion
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: primarylogin,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: const Text('Accept', style: TextStyle(color: Colors.white)),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Cancel', style: TextStyle(color: Colors.red)),
//         ),
//       ],
//     );
//   }
// }
//
// void showCustomDialog(BuildContext context, String message, Future<void> Function() onConfirm) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return CustomDialogBox(
//         message: message,
//         onConfirm: onConfirm, // Pass the async function
//       );
//     },
//   );
// }