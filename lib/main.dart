import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:ifresh_delivery/screens/pushnotification.dart';
import 'package:ifresh_delivery/screens/splash/splashscreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Colors/colors.dart';
import 'Environment/Environment.dart';

SharedPreferences? prefs;

/// Notifications
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// Firebase Messaging background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  PushNotificationServicePage.myBackgroundMessageHandler(message);
  print('Handling a background message ${message.messageId}');
}

// Firebase Messaging foreground handler
void _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  if (message.notification == null) return; // Prevent null exception

  print("Foreground message received: ${message.notification!.title}");

  final String? sound = message.notification?.android?.sound;

  // AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //   'channel_id',
  //   'channel_name',
  //   sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
  //   icon: 'ic_notification',
  //   importance: Importance.high,
  //   priority: Priority.high,
  // );
  //
  // NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

  // await flutterLocalNotificationsPlugin.show(
  //   0,
  //   message.notification?.title ?? "No Title",
  //   message.notification?.body ?? "No Body",
  //   // platformDetails,
  // );
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  debugPrint('notification details payload: $title');
}

// void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//   final String? payload = notificationResponse.payload;
//   // if (notificationResponse.payload != null) {
//   //   debugPrint('notification payload: $payload');
//   // }
//   print("onDidReceiveNotificationResponse : ");
// }

Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  await Permission.notification.request();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  prefs = await SharedPreferences.getInstance();

  await dotenv.load(fileName: Environment.filename);
  _initializeHERESDK();

  runApp(MyApp());
}
Future<void> getFCMToken() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // request permission first (important Android 13+)
    await messaging.requestPermission();

    // retry until token available
    String? token;
    for (int i = 0; i < 5; i++) {
      token = await messaging.getToken();
      if (token != null) break;
      await Future.delayed(const Duration(seconds: 2));
    }

    debugPrint("FCM TOKEN: $token");

  } catch (e) {
    debugPrint("FCM ERROR: $e");
  }
}



void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = "SzjNhV2d5o0_QS2NjRcrEw";
  String accessKeySecret =
      "Lz7rvU4QiHTY6KpLkhR5wG7jGDCsDRA6UUmaY-i2bqPvyaM0Zlk2PO4hG2uR7tcLTWOzvCGzsMJeVgitHKPbsg";
  SDKOptions sdkOptions =
  SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
      getFCMToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint("FCM TOKEN REFRESHED: $newToken");

      // TODO: send this updated token to your server API
    });

  }
  //
  // @override
  // void initState() {
  //   requestNotificationPermission();
  //
  //   super.initState();
  //
  //   // var initializationSettingsAndroid =
  //   //  AndroidInitializationSettings('@mipmap/ic_launcher');
  //   //
  //   // final DarwinInitializationSettings initializationSettingsDarwin =
  //   // DarwinInitializationSettings(
  //   //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //   //
  //   // final LinuxInitializationSettings initializationSettingsLinux =
  //   // LinuxInitializationSettings(defaultActionName: 'Open notification');
  //   //
  //   // final InitializationSettings initializationSettings = InitializationSettings(
  //   //     android: initializationSettingsAndroid,
  //   //     iOS: initializationSettingsDarwin,
  //   //     linux: initializationSettingsLinux);
  //   // flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //   //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  // }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color:primarylogin, // your global loader color
        ),
      ),
      title: 'iFresh Delivery',
      home: SplashScreen(),
    );
  }
}
