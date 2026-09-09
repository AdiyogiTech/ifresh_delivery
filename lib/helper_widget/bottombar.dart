import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/helper_widget/drawer.dart';
import 'package:ifresh_delivery/screens/home/home.dart';
import 'package:ifresh_delivery/screens/order_list/orderlist.dart';
import 'package:ifresh_delivery/screens/profile/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/profile/profile_controller.dart';
import 'location apis/locationController.dart';

class BottomBar extends StatefulWidget {
  // const BottomBar({super.key});
  var bottomindex;
  BottomBar({super.key, this.bottomindex});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  //
  bool switchValue = false;
  Timer? _timer;
  //
  int _currentIndexBnb = 1;
  final locationController = Get.put(LocationController());
  ProfileController profileController = Get.put(ProfileController());

  List bodys = [
    OrderList(),
    Home(),
    Profile(),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    profileController.GetProfileData(Uri.parse(profile_url));
    _currentIndexBnb = widget.bottomindex ?? 1;
    // switchValue = profileController.status;
    // log('shit ${profileController.status}');
    local();
    // _listenToLocationChanges();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndexBnb = index;
    });
  }

  Timer? _locationUpdateTimer;

  void sendLocation5min() async {
    // Location ON/OFF is controlled only by the app bar button.
    // Do not flip status or show toasts from automatic page/timer updates.
    if (!profileController.status) {
      stopLocationUpdateTimer();
      return;
    }

    if (await Geolocator.isLocationServiceEnabled()) {
      locationController.updateLocation();
    } else {
      // Skip this cycle silently; keep toggle state as user set it.
      log('Location services disabled — skipping location update');
    }
  }

  void local() async {
    Timer(const Duration(seconds: 3), () async {
      if (!profileController.status) {
        stopLocationUpdateTimer();
        return;
      }

      // Check if location services are enabled — do not auto-toggle OFF
      if (!await Geolocator.isLocationServiceEnabled()) {
        log('Location services disabled — timer not started');
        return;
      }

      // Handle location permissions — do not auto-toggle OFF
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Location permissions denied — timer not started');
          return;
        }
      } else if (permission == LocationPermission.deniedForever) {
        log('Location permissions permanently denied — timer not started');
        return;
      }

      // Start the location update timer
      startLocationUpdateTimer();
    });
  }

  // Start the periodic timer (5-minute interval)
  Future<void> startLocationUpdateTimer() async {
    // Prevent multiple timers from starting
    if (_locationUpdateTimer == null ||
        !_locationUpdateTimer!.isActive && profileController.status == true) {
      if (await Geolocator.isLocationServiceEnabled()) {
        _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (_) {
          log('Periodic location update triggered');
          sendLocation5min();
        });
      } else {
        // Do not change toggle or toast — only button click should control that
        log('Location services disabled — timer not started');
        return;
      }
    }
  }

  // Stop the location update timer
  void stopLocationUpdateTimer() {
    if (_locationUpdateTimer != null && _locationUpdateTimer!.isActive) {
      _locationUpdateTimer!.cancel();

      log('Location update timer stopped.');
      // locationController.locationStatusApiCalling(profileController.status);
      // setState(() {});
    }
  }

  // Toast message utility
  void toastMsg(String message, bool isWarning) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isWarning ? Colors.red : primarylogin,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndexBnb != 1) {
          setState(() {
            _currentIndexBnb = 1;
          });
          return false;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primarylogin.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.exit_to_app_rounded,
                          color: primarylogin,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Exit App',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Are you sure you want to exit?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey[700],
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
                                exit(0);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primarylogin,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                elevation: 0,
                              ),
                              child: const Text('Exit'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          return false;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primary,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/drawericon.png',
                  scale: 3.7,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          title: _currentIndexBnb == 0
              ? const Text(
            'Orders',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          )
              : _currentIndexBnb == 2
              ? const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          )
              : Image.asset(
            'assets/images/iFresh.png',
            scale: 8,
            color: Colors.white,
          ),
          titleSpacing: 0,
          centerTitle: true,
          actions: [
            ///working below
            Obx(() {
              // Show the loader if `isLoading` is true
              if (profileController.ProfileLoader.value) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () async {
                    bool newStatus = !profileController.status;
                    setState(() {
                      profileController.status = newStatus;
                    });

                    if (profileController.status == true) {
                      bool isLocationServiceEnabled =
                      await Geolocator.isLocationServiceEnabled();

                      if (isLocationServiceEnabled) {
                        locationController
                            .locationStatusApiCalling(profileController.status);

                        startLocationUpdateTimer();

                        // ON toast
                        toastMsg('Location tracking started', false);
                      } else {
                        setState(() {
                          profileController.status = false;
                        });
                        toastMsg('Please enable location services', true);
                      }
                    } else {
                      locationController
                          .locationStatusApiCalling(profileController.status);

                      stopLocationUpdateTimer();

                      // OFF toast
                      toastMsg('Location tracking stopped', true);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: profileController.status
                          ? Colors.green.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: profileController.status
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          profileController.status
                              ? Icons.location_on
                              : Icons.location_off,
                          color: profileController.status ?Colors.white : Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          profileController.status ? 'ON' : 'OFF',
                          style: TextStyle(
                            color: profileController.status ? Colors.white : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            ///working above
          ],
        ),

        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildNavItem('assets/images/orderIcon.png', "Orders", 0, _currentIndexBnb == 0),
              const SizedBox(width: 40), // Space for FAB
              _buildNavItem('assets/images/profileIcon.png', "Profile", 2, _currentIndexBnb == 2),
            ],
          ),
        ),

        body: bodys[_currentIndexBnb],

        drawer: DrawerPage(),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 55,
          width: 55,
          margin: const EdgeInsets.only(top: 8),
          child: FloatingActionButton(
            splashColor: Colors.transparent,
            onPressed: () => _onItemTapped(1),
            backgroundColor: _currentIndexBnb == 1 ? primarylogin : Colors.grey[200],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            elevation: _currentIndexBnb == 1 ? 4 : 0,
            child: Icon(
              Icons.home_rounded,
              color: _currentIndexBnb == 1 ? Colors.white : Colors.grey[500],
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndexBnb = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              scale: 2,
              color: isSelected ? primarylogin : Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
                color: isSelected ? primarylogin : Colors.grey.shade500,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                  color: primarylogin,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildNavBarItem(String imagePath, String label, int index) {
    bool isSelected = _currentIndexBnb == index;
    Color iconColor = isSelected ? white : Colors.black45;
    Color textColor = isSelected ? white : Colors.black45;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndexBnb = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              scale: 1.5,
              color: iconColor,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.8,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}