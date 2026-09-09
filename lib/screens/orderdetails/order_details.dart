import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/helper_widget/bottombar.dart';
import 'package:ifresh_delivery/screens/order_list/orderList_controller.dart';
import 'package:pinput/pinput.dart';
import '../../constant/api.dart';
import '../here_map/locationScreen.dart';
import '../profile/profile_controller.dart';

class OrderDetailsPage extends StatefulWidget {
  final indexx;
  OrderDetailsPage({Key? key, this.indexx});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  OrderListController orderListController = Get.put(OrderListController());
  var currentIndex;
  late Position position;
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    getDetailsData();
    getOrderStatusList();
    fetchLocation_ofDeliveryBoy();
    profileController.GetProfileData(Uri.parse(profile_url));
    Future.delayed(Duration.zero, () {
      orderListController
          .setStaticOrderDetails(orderListController.OrderId.value);
    });
    log('hereerererererererer ${orderListController.OrderId.value}');
  }

  void fetchLocation_ofDeliveryBoy() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      log('herer suckers');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        log('Location permissions are permanently denied.');
        await Geolocator.openAppSettings();
        return;
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        log('latitude and longitude: ${position.latitude}, ${position.longitude}');
      } else {
        log('Location permissions are still not granted.');
      }
    } catch (e) {
      log('Error while fetching location: $e');
    }
  }

  // void fetchLocation_ofDeliveryBoy () async{
  //   position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   log('latitude and longitude ${position.latitude} ${position.longitude}');
  // }

  getOrderStatusList() async {
    await orderListController.OrderStatusApiCalling();
    log('OrderStatusData==>${orderListController.OrderStatusData}');

    // log('indexx==>'+widget.indexx.toString());
  }

  getDetailsData() async {
    await orderListController.OrderDetailsApiCalling(
        orderListController.OrderId.value);
    log('OrderDetailsData==>' +
        orderListController.OrderDetailsData.toString());
    setState(() {});
  }

  final defaultPinTheme = PinTheme(
    width: 45,
    height: 45,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300, width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Get.back(result: true);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          title: Text(
            "Order Details",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          titleSpacing: 0.0,
          backgroundColor: primary,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<OrderListController>(builder: (orderListController) {
            if (orderListController.OrderDetailsDataLoading.value) {
              return SizedBox(
                height: height * 0.8,
                child: Center(
                  child: CircularProgressIndicator(
                    color: primarylogin,
                    strokeWidth: 2,
                  ),
                ),
              );
            } else if (orderListController.OrderDetailsData.isEmpty) {
              return SizedBox(
                height: height * 0.8,
                child: Center(
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
                          Icons.receipt_outlined,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Order details not found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Shipping Address Section
                    _buildSectionHeader("Shipping Address"),
                    const SizedBox(height: 12),

                    Container(
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
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: primarylogin.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: primarylogin,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${orderListController.OrderDetailsData[0]['shipping_address_1'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_address_2'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_city'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_state'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_country'].toString()}, ${orderListController.OrderDetailsData[0]['shipping_postcode'].toString()}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Order Assign By:',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                orderListController.OrderDetailsData[0]['delivery_assign_by'] == 2
                                    ? 'Franchise Admin'
                                    : 'Franchise',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: primarylogin,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Customer Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  Icons.person_outline,
                                  orderListController.OrderDetailsData[0]['customer_name'].toString(),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.receipt_outlined,
                                  orderListController.OrderDetailsData[0]['order_no'].toString(),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.email_outlined,
                                  orderListController.OrderDetailsData[0]['customer_email'].toString(),
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.phone_outlined,
                                  orderListController.OrderDetailsData[0]['customer_mobile'].toString(),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColorId(orderListController
                                  .OrderDetailsData[0]['order_status_id']
                                  .toString()).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              getPaymentStatusId2(orderListController
                                  .OrderDetailsData[0]['order_status_id']
                                  .toString()),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: getStatusColorId(orderListController
                                    .OrderDetailsData[0]['order_status_id']
                                    .toString()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Pickup Address Section
                    _buildSectionHeader("Pickup Address"),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primarylogin.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.store_outlined,
                              color: primarylogin,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${orderListController.OrderDetailsData[0]['vendor_address'].toString()}, ${orderListController.OrderDetailsData[0]['vendor_city_name'].toString()}, ${orderListController.OrderDetailsData[0]['vendor_state_name'].toString()}, ${orderListController.OrderDetailsData[0]['vendor_country_name'].toString()}, ${orderListController.OrderDetailsData[0]['vendor_postcode'].toString()}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Order Items Section
                    _buildSectionHeader("Order Items"),
                    const SizedBox(height: 12),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderListController
                          .OrderDetailsData[0]['order_products'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    orderListController.OrderDetailsData[0]
                                    ['order_products'][index]['main_image']
                                        .toString(),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey[400],
                                        size: 30,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderListController.OrderDetailsData[0]
                                      ['order_products'][index]['product_name']
                                          .toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      orderListController.OrderDetailsData[0]
                                      ['order_products'][index]['attribute_name']
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${orderListController.OrderDetailsData[0]['order_products'][index]['total_price'].toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: primarylogin,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Qty: ${orderListController.OrderDetailsData[0]['order_products'][index]['quantity'].toString()}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Order Information Section
                    _buildSectionHeader("Order Information"),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment Method',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primarylogin.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  getPaymentStatusId(orderListController
                                      .OrderDetailsData[0]['payment_type']
                                      .toString()),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: primarylogin,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          _buildPriceRow('Subtotal', '₹${orderListController.OrderDetailsData[0]['subtotal']}'),
                          const SizedBox(height: 8),
                          _buildPriceRow('Tax', '₹${orderListController.OrderDetailsData[0]['tax']}'),
                          const SizedBox(height: 8),
                          _buildPriceRow('Shipping', '₹${orderListController.OrderDetailsData[0]['shipping']}'),
                          const SizedBox(height: 8),
                          _buildPriceRow('Discount', '-₹${orderListController.OrderDetailsData[0]['discount']}'),

                          const Divider(height: 20),

                          _buildPriceRow('Total', '₹${orderListController.OrderDetailsData[0]['total']}', isTotal: true),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Delivery Boy Details
                    // _buildSectionHeader("Delivery Boy Details"),
                    // const SizedBox(height: 12),
                    //
                    // Container(
                    //   padding: const EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(16),
                    //   ),
                    //   child: orderListController.OrderDetailsData[0]['delivery_boy_name'] == null
                    //       ? Center(
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16),
                    //       child: Text(
                    //         'No delivery boy details available',
                    //         style: TextStyle(
                    //           fontSize: 13,
                    //           color: Colors.grey[600],
                    //         ),
                    //       ),
                    //     ),
                    //   )
                    //       : Column(
                    //     children: [
                    //       _buildInfoRow(
                    //         Icons.person_outline,
                    //         orderListController.OrderDetailsData[0]['delivery_boy_name'].toString(),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       _buildInfoRow(
                    //         Icons.email_outlined,
                    //         orderListController.OrderDetailsData[0]['delivery_boy_email'].toString(),
                    //       ),
                    //       const SizedBox(height: 8),
                    //       _buildInfoRow(
                    //         Icons.phone_outlined,
                    //         orderListController.OrderDetailsData[0]['delivery_boy_mobile'].toString(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //
                    // const SizedBox(height: 16),

                    // Order History Section
                    _buildSectionHeader("Order History"),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline Dots
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              orderListController.OrderDetailsData[0]['order_history'].length,
                                  (index) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xffb5e550),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xffb5e550).withOpacity(0.3),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index < orderListController.OrderDetailsData[0]['order_history'].length - 1)
                                      Container(
                                        height: 45,
                                        width: 2,
                                        color: const Color(0xffb5e550).withOpacity(0.3),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),

                          // History Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                orderListController.OrderDetailsData[0]['order_history'].length,
                                    (index) {
                                  final orderHistory = orderListController.OrderDetailsData[0]['order_history'][index];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: index < orderListController.OrderDetailsData[0]['order_history'].length - 1
                                          ? 16
                                          : 0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orderHistory['comment'].toString() ?? 'NA',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${DateFormat('d MMM, yyyy').format(DateTime.parse(orderHistory['created_at'].toString()))} | ${DateFormat('hh:mm a').format(DateTime.parse(orderHistory['created_at'].toString()))}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Update Status Section
                    if (orderListController.OrderDetailsData[0]['order_status_id'] != 4 &&
                        orderListController.OrderDetailsData[0]['order_status_id'] != 5 &&
                        orderListController.OrderDetailsData[0]['delivery_boy_order_status'] == 2) ...[
                      _buildSectionHeader("Update Status"),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: orderListController.OrderStatusData.length,
                          itemBuilder: (context, index) {
                            int currentStatusId = int.parse(
                                orderListController.OrderDetailsData[0]['order_status_id'].toString());

                            int statusId = int.parse(
                                orderListController.OrderStatusData[index]['id'].toString());

                            print('statusid>>>$statusId, currentstatusid>>>$statusId');
                            bool isUpdatedStatus = statusId <= currentStatusId;
                            return GestureDetector(
                              onTap:  isUpdatedStatus
                                  ? null:() {
                                currentIndex = index;
                                showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                       padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: primarylogin.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.update,
                                                color: primarylogin,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              "Update Status",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              "Are you sure you want to update the order status?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                OutlinedButton(
                                                    onPressed:
                                                        () {
                                                      Navigator.pop(
                                                          context);
                                                      orderListController
                                                          .otpController
                                                          .clear();
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                      foregroundColor: Colors.grey[600],
                                                      side: BorderSide(color: Colors.grey.shade300),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                                                    ),
                                                    child:
                                                    Text(
                                                      "Cancel",
                                                    )),
                                                sizebox_width_20,
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: primarylogin,
                                                      foregroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(25),
                                                      ),
                                                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                                                    ),
                                                    onPressed: orderListController.OrderStatusData[index]['id'] == 3
                                                        ? () async {
                                                      var body =
                                                      {
                                                        'vendor_order_id':
                                                        orderListController.OrderDetailsData[0]['id'].toString(),
                                                        'update_status':
                                                        orderListController.OrderStatusData[index]['id'].toString(),
                                                      };
                                                      log('body3==>' +
                                                          body.toString());
                                                      await orderListController.OrderStatusUpdate(
                                                          body);
                                                      Navigator.pop(
                                                          context);
                                                    }
                                                        : () async {

                                                      var body =
                                                      {
                                                        'vendor_order_id':
                                                        orderListController.OrderDetailsData[0]['id'].toString(),
                                                        'update_status':
                                                        orderListController.OrderStatusData[index]['id'].toString(),
                                                      };

                                                      log('body ==> ${body.toString()}');

                                                      await orderListController.OrderStatusUpdateOtp(
                                                          body,
                                                          false);

                                                      if (orderListController.OTPData['status'] !=
                                                          false) {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          builder: (_) => Dialog(

                                                            child: Container(
                                                              padding: EdgeInsets.all(20),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets.all(12),
                                                                    decoration: BoxDecoration(
                                                                      color: primarylogin.withOpacity(0.1),
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons.pin_outlined,
                                                                      color: primarylogin,
                                                                      size: 24,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 16),
                                                                  const Text(
                                                                    "Enter OTP",
                                                                    style: TextStyle(
                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 4),
                                                                  const Text(
                                                                    "Ask customer for OTP",
                                                                    style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.grey,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(height: 20),
                                                                  Pinput(
                                                                    length: 6,
                                                                    inputFormatters: [
                                                                      FilteringTextInputFormatter.digitsOnly
                                                                    ],
                                                                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                                                                    listenForMultipleSmsOnAndroid: true,
                                                                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                                                                    errorTextStyle: TextStyle(
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12,
                                                                      color: Colors.red,
                                                                    ),
                                                                    defaultPinTheme: defaultPinTheme,
                                                                    focusedPinTheme: defaultPinTheme.copyWith(
                                                                      decoration: defaultPinTheme.decoration!.copyWith(
                                                                        border: Border.all(color: primary),
                                                                      ),
                                                                    ),
                                                                    errorPinTheme: defaultPinTheme.copyWith(
                                                                      decoration: defaultPinTheme.decoration!.copyWith(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        border: Border.all(color: Colors.red), // Error border color
                                                                      ),
                                                                    ),
                                                                    controller: orderListController.otpController,
                                                                    isCursorAnimationEnabled: true,
                                                                  ),
                                                                  sizebox_height_10,
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 100,
                                                                        height: 40,
                                                                        child: OutlinedButton(
                                                                          style: OutlinedButton.styleFrom(
                                                                            foregroundColor: Colors.grey[600],
                                                                            side: BorderSide(color: Colors.grey.shade300),
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                            ),
                                                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                                                          ),
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                            orderListController.otpController.clear();
                                                                          },
                                                                          child: Text(
                                                                            "Cancel",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      sizebox_width_20,
                                                                      SizedBox(
                                                                        width: 100,
                                                                        height: 40,
                                                                        child: ElevatedButton(
                                                                          onPressed: () {
                                                                            var otpBody = {
                                                                              'vendor_order_id': orderListController.OrderDetailsData[0]['id'].toString(),
                                                                              'update_status': orderListController.OrderStatusData[index]['id'].toString(),
                                                                              'otp': orderListController.otpController.text,
                                                                            };
                                                                            orderListController.OrderStatusUpdate(otpBody);
                                                                          },
                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor: primarylogin,
                                                                            foregroundColor: Colors.white,
                                                                            shape: RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                            ),
                                                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                                                          ),
                                                                          child: Text(
                                                                            "Submit",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      "Continue",)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 10),
                                padding: const EdgeInsets.only(
                                    left: 15,
                                    right: 15,
                                    bottom: 3,
                                    top: 3),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: isUpdatedStatus
                                        ? primarylogin
                                        : Colors.grey.shade400,),
                                ),
                                child: Text(
                                  orderListController
                                      .OrderStatusData[index]['name']
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isUpdatedStatus
                                        ? primarylogin
                                        : Colors.grey.shade400,),
                                ),
                              ),
                            );

                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Track Location Button
                    if ((orderListController.OrderDetailsData[0]["order_status_id"] == 2 &&
                        orderListController.OrderDetailsData[0]["delivery_boy_order_status"] == 2 &&
                        orderListController.OrderDetailsData[0]["is_global"] == 0) ||
                        (orderListController.OrderDetailsData[0]["order_status_id"] == 3 &&
                            orderListController.OrderDetailsData[0]["delivery_boy_order_status"] == 2 &&
                            orderListController.OrderDetailsData[0]["is_global"] == 0))
                      Center(
                        child: GestureDetector(
                          onTap: profileController.status == false
                              ? () {
                            _showEnableLocationDialog();
                          }
                              : () {
                            double vendorLat = double.parse(
                                orderListController.OrderDetailsData[0]['vendor_latitude']);
                            double vendorLong = double.parse(
                                orderListController.OrderDetailsData[0]['vendor_longitude']);

                            double customerLat = double.parse(
                                orderListController.OrderDetailsData[0]['shipping_latitude']);
                            double customerLong = double.parse(
                                orderListController.OrderDetailsData[0]['shipping_longitude']);

                            GeoCoordinates vendorLocation = GeoCoordinates(vendorLat, vendorLong);
                            GeoCoordinates customerLocation = GeoCoordinates(customerLat, customerLong);
                            GeoCoordinates deliveryBoyLocation = GeoCoordinates(
                                position.latitude, position.longitude);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationTrackerScreen(
                                  Start: vendorLocation,
                                  end: customerLocation,
                                  deliveryBoyLocation: deliveryBoyLocation,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: primarylogin,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: primarylogin.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Track Location',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: primarylogin,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal ? Colors.grey[900] : Colors.grey[700],
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? primarylogin : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  void _showUpdateStatusDialog(OrderListController orderListController, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primarylogin.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.update,
                  color: primarylogin,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Update Status",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to update the order status?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        orderListController.otpController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: orderListController.OrderStatusData[index]['id'] == 3
                          ? () async {
                        var body =
                        {
                          'vendor_order_id':
                          orderListController.OrderDetailsData[0]['id'].toString(),
                          'update_status':
                          orderListController.OrderStatusData[index]['id'].toString(),
                        };
                        log('body3==>' +
                            body.toString());
                        await orderListController.OrderStatusUpdate(
                            body);
                        Navigator.pop(
                            context);
                      }
                          : () {
                        _showOtpDialog(orderListController, index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primarylogin,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOtpDialog(OrderListController orderListController, int index) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primarylogin.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pin_outlined,
                  color: primarylogin,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Ask customer for OTP",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // Pinput with autofill preserved
              Pinput(
                length: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                listenForMultipleSmsOnAndroid: true,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                errorTextStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.red,
                ),
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: primary),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red), // Error border color
                  ),
                ),
                controller: orderListController.otpController,
                isCursorAnimationEnabled: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        orderListController.otpController.clear();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        var body = {
                          'vendor_order_id': orderListController.OrderDetailsData[0]['id'].toString(),
                          'update_status': orderListController.OrderStatusData[index]['id'].toString(),
                          'otp': orderListController.otpController.text,
                        };
                        orderListController.OrderStatusUpdate(body);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primarylogin,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Center(
                          child: const Text('Submit')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnableLocationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Enable Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'You need to enable location tracking from the home page to track the delivery.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.to(() => BottomBar(bottomindex: 1));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primarylogin,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );
  }

  ///for payments status....
  String getPaymentStatusId(String fullDay) {
    Map<String, String> dayMapping = {
      '1': 'Cash on delivery',
      '2': 'Online payment',
    };
    return dayMapping[fullDay] ?? fullDay;
  }

  ///for payments status....
  String getPaymentStatusId2(String fullDay) {
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
}


