import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/screens/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../order_list/orderList_controller.dart';
import '../orderdetails/order_details.dart';
import '../profile/profile_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController homeController = Get.put(HomeController());
  OrderListController orderListController = Get.put(OrderListController());
  bool isDialogOpen = false; // To track if the dialog is already open
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkLocationPopup();

      // 👇 Wait until user interacts (optional but safest)
      await Future.delayed(const Duration(milliseconds: 300));

      await getDashbordData();
      orderListController.orderListPaginationSearch(id_name: '');
      await refreshOrders();
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await getDashbordData();
    //
    //   orderListController.orderListPaginationSearch(id_name: ''); // only listener
    //   await refreshOrders();
    //   await _checkLocationPopup(); // only API call
    //
    // });

  }

  Future<void> _checkLocationPopup() async {
    final prefs = await SharedPreferences.getInstance();

    bool alreadyShown = prefs.getBool("location_popup_shown") ?? false;

    if (!alreadyShown) {
      _showLocationDisclosure();
    }
  }
  ///location
  // Check initial location service status
  Future<void> _checkLocationStatus() async {

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled && profileController.status == true) {

      _showEnableLocationDialog();
    }
  }

  // Listen to location service status changes
  void _listenToLocationChanges() {

    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {

        if (isDialogOpen) {

          Get.back();
          isDialogOpen = false;
        }
      } else if (status == ServiceStatus.disabled &&
          profileController.status == true) {
        log('isLocationEnabled==>');
        _showEnableLocationDialog();
      }
    });
  }
  void _showLocationDisclosure() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            "Allow Location Access",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            "We collect your location data to assign nearby delivery orders, enable real-time tracking, and ensure accurate delivery.\n\n"
                "Location may be collected even when the app is closed or not in use to update delivery status.",

            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool("location_popup_shown", true);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text("Deny"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                // 👇 ONLY here permission call hoga
                await checkPermissionAndLocation();

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool("location_popup_shown", true);

                _checkLocationStatus();
                _listenToLocationChanges();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primarylogin,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Text("Allow"),
            ),
          ],
        );
      },
    );
  }
  Future<void> checkPermissionAndLocation() async {

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }
  }
  // Show dialog to enable location
  void _showEnableLocationDialog() {
    if (mounted && !isDialogOpen) {
      isDialogOpen = true;
      // Do not auto-turn location toggle OFF — only the app bar button should change it
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: const Text(
              'Enable Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            content: const Text(
              'Location services are disabled. Please enable location to continue.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  isDialogOpen = false;
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  Navigator.pop(context);
                  isDialogOpen = false;
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
  }

  getOrderlistData() async {
    orderListController.orderListPage = 1;
    orderListController.orderListlimit = 10;
    await orderListController.OrderListApiCall(
        orderListController.orderSearchCtrl.text,
        '',
        orderListController.orderListPage,
        orderListController.orderListlimit);
  }

  getDashbordData() async {
    await homeController.DashbordApiCalling();
  }
  Future<void> refreshOrders() async {
    orderListController.orderListPage = 1;
    orderListController.orderListlimit = 10;

    await orderListController.OrderListApiCall(
        orderListController.orderSearchCtrl.text,
        '',
        orderListController.orderListPage,
        orderListController.orderListlimit);

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        displacement: 50,
        backgroundColor: Colors.white,
        color: primarylogin,
        strokeWidth: 2,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1500));
          await homeController.DashbordApiCalling();
          orderListController.orderListPage = 1;
          orderListController.orderListlimit = 10;
          await orderListController.OrderListApiCall(
              orderListController.orderSearchCtrl.text,
              '',
              orderListController.orderListPage,
              orderListController.orderListlimit);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: GetBuilder<HomeController>(builder: (homeController) {
            if (homeController.dashBordDataLoading.value ||
                homeController.dashbordData.isEmpty) {
              return SizedBox(
                  height: size.height * 0.7,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: primarylogin,
                      strokeWidth: 2,
                    ),
                  ));
            } else {
              var dashboard = homeController.dashbordData[0];

              return Column(
                children: [
                  // Profile Header
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primarylogin,
                          primarylogin.withOpacity(0.9),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          // Profile Image
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.network(
                                  dashboard["user"]['image'].toString(),
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/profile2.png',
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dashboard["user"]['name'].toString().capitalize ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      dashboard["user"]['mobile'].toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        dashboard["user"]['email'].toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Cards
                  // Stats Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Total Stats Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Total Delivered
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dashboard['total_delivered'].toString() != "null"
                                              ? dashboard['total_delivered'].toString()
                                              : "0",
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const Text(
                                          "Total Delivered",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Vertical Divider
                              Container(
                                height: 40,
                                width: 1,
                                color: Colors.grey[200],
                              ),

                              // Total Pending
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          dashboard['total_pending'].toString() != "null"
                                              ? dashboard['total_pending'].toString()
                                              : "0",
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const Text(
                                          "Total Pending",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.pending_actions,
                                        color: Colors.orange,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Today Stats Row
                        Row(
                          children: [
                            // Today Delivered
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.green,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Today's Delivery",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dashboard['today_delivered'].toString() != "null"
                                              ? dashboard['today_delivered'].toString()
                                              : "0",
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.trending_up,
                                                size: 12,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                "+12%",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Today Pending
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.access_time,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "Today's Pending",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dashboard['today_pending'].toString() != "null"
                                              ? dashboard['today_pending'].toString()
                                              : "0",
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: const [
                                              Icon(
                                                Icons.trending_down,
                                                size: 12,
                                                color: Colors.orange,
                                              ),
                                              SizedBox(width: 2),
                                              Text(
                                                "-8%",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Quick Actions Row (Optional - can add if needed)
                        // Row(
                        //   children: [
                        //     // Earnings Card
                        //     Expanded(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(16),
                        //         decoration: BoxDecoration(
                        //           gradient: LinearGradient(
                        //             colors: [primary, primary.withOpacity(0.8)],
                        //             begin: Alignment.topLeft,
                        //             end: Alignment.bottomRight,
                        //           ),
                        //           borderRadius: BorderRadius.circular(20),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: primary.withOpacity(0.3),
                        //               blurRadius: 10,
                        //               offset: const Offset(0, 4),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 Container(
                        //                   padding: const EdgeInsets.all(6),
                        //                   decoration: BoxDecoration(
                        //                     color: Colors.white.withOpacity(0.2),
                        //                     shape: BoxShape.circle,
                        //                   ),
                        //                   child: const Icon(
                        //                     Icons.currency_rupee,
                        //                     color: Colors.white,
                        //                     size: 14,
                        //                   ),
                        //                 ),
                        //                 const SizedBox(width: 8),
                        //                 const Text(
                        //                   "Today's Earnings",
                        //                   style: TextStyle(
                        //                     color: Colors.white70,
                        //                     fontSize: 12,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 12),
                        //             const Text(
                        //               "₹ 2,450",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 24,
                        //                 fontWeight: FontWeight.w700,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     const SizedBox(width: 16),
                        //
                        //     // Rating Card
                        //     Expanded(
                        //       child: Container(
                        //         padding: const EdgeInsets.all(16),
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.circular(20),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.05),
                        //               blurRadius: 10,
                        //               offset: const Offset(0, 2),
                        //             ),
                        //           ],
                        //         ),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 Container(
                        //                   padding: const EdgeInsets.all(6),
                        //                   decoration: BoxDecoration(
                        //                     color: Colors.amber.withOpacity(0.1),
                        //                     shape: BoxShape.circle,
                        //                   ),
                        //                   child: const Icon(
                        //                     Icons.star,
                        //                     color: Colors.amber,
                        //                     size: 14,
                        //                   ),
                        //                 ),
                        //                 const SizedBox(width: 8),
                        //                 const Text(
                        //                   "Rating",
                        //                   style: TextStyle(
                        //                     color: Colors.grey,
                        //                     fontSize: 12,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             const SizedBox(height: 12),
                        //             Row(
                        //               children: const [
                        //                 Text(
                        //                   "4.8",
                        //                   style: TextStyle(
                        //                     fontSize: 24,
                        //                     fontWeight: FontWeight.w700,
                        //                     color: Colors.black87,
                        //                   ),
                        //                 ),
                        //                 SizedBox(width: 4),
                        //                 Text(
                        //                   "/5",
                        //                   style: TextStyle(
                        //                     fontSize: 14,
                        //                     color: Colors.grey,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Orders List Header
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Recent Orders",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Orders List
                  GetBuilder<OrderListController>(
                    builder: (orderListController) {
                      if (orderListController.OrderListLoading.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (orderListController.orderListData.value.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
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
                          ),
                        );
                      } else {
                        return ListView.builder(
                            itemCount: orderListController.orderListData.value.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemBuilder: (BuildContext context, int index) {
                              var Orders = orderListController.orderListData.value[index];

                              log("order status here ${Orders['order_status_id']} & ${Orders['delivery_boy_order_status']}");

                              log('all orders here one by one $Orders');
                              var orderNo = Orders['order_no'].toString() != "null"
                                  ? Orders['order_no'].toString()
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
                                onTap: () async {
                                  orderListController.OrderId.value = Orders['id'].toString();
                                  var result = await Get.to(OrderDetailsPage(
                                    indexx: index,
                                  ));
                                  if (result == true) {
                                    await refreshOrders();
                                    await getDashbordData();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
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
                                                        customer_name,
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

                                          // Price
                                          Column(
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
                                              // Container(
                                              //   padding: const EdgeInsets.symmetric(
                                              //     horizontal: 6,
                                              //     vertical: 2,
                                              //   ),
                                              //   decoration: BoxDecoration(
                                              //     color: Colors.grey[100],
                                              //     borderRadius: BorderRadius.circular(4),
                                              //   ),
                                              //   child: Text(
                                              //     payment_type_name,
                                              //     style: TextStyle(
                                              //       fontSize: 8,
                                              //       color: primarylogin,
                                              //       fontWeight: FontWeight.w600,
                                              //     ),
                                              //   ),
                                              // ),
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
                                        ],
                                      ),

                                      // Accept/Reject Buttons
                                      if (orderListController.orderListData[index]['order_status_id'] == 2 &&
                                          orderListController.orderListData[index]['delivery_boy_order_status'] == 1)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12),
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
                            });
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              );
            }
          }),
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
          onPressed: () async {
            await function();
            Get.back();
            await refreshOrders();
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