import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/Constant/SizeBox.dart';
import 'package:ifresh_delivery/main.dart';
import 'package:ifresh_delivery/screens/setting_model_controller/setting_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constant/validations.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  SettingController settingController = Get.put(SettingController());
  String? phoneNumber;
  String? emailAddress ;
  String? address ;
  Future<void> makePhoneCall() async {
    final Uri url = Uri.parse("tel:$phoneNumber");

    try {
      await launchUrl(url);
    } catch (e) {
      toastMsg("Calling not supported on this device",false);
    }
  }
  // void callPhoneNumber() async {
  //   final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  //   if (await canLaunchUrl(phoneUri)) {
  //     await launchUrl(phoneUri);
  //   } else {
  //     print('Could not launch phone dialer');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Could not launch phone dialer.')),
  //     );
  //   }
  // }
  //

  void sendEmail() async {
    final Uri url = Uri.parse('mailto:$emailAddress');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch email.')));
      throw 'Could not launch $url';
    }

  }

  //
  void openMap() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';

    }
  }

  callData(){
    var setting_json_data = json.decode(prefs!.getString("setting").toString());
    print("check data" + setting_json_data['data'].toString());
    emailAddress = setting_json_data['data']['settings']["email"].toString();
    phoneNumber = setting_json_data['data']['settings']["phone"].toString();
    address = setting_json_data['data']['settings']["address"].toString();
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        elevation: 2,
        automaticallyImplyLeading: false,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.arrow_back,color: Colors.white),
          ),
        ),
        title: Text('Contact us',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // sizebox_height_30,
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/contactusImage.png',scale: 3.5,),
              ),
              sizebox_height_20,
              ContactInfo(
                icon:  Icons.phone_in_talk_rounded,
                text: phoneNumber,
                onTap: makePhoneCall,
              ),
              ContactInfo(
                icon:  Icons.email,
                text: emailAddress,
                onTap: sendEmail,
              ),
              ContactInfo(
                icon: Icons.location_on,
                text: address,
                onTap: openMap,
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget ContactInfo({IconData? icon, String? text, void Function()? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(BorderSide(width: 2,color: primarylogin))
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,

                  child: Icon(
                    icon,
                    size: 30,
                    color: primarylogin,
                  ),
                ),
              ),
              sizebox_width_10,
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  text!,
                  maxLines: 3,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
