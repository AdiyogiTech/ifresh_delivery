import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ifresh_delivery/main.dart';

class Environment {
  static String get filename {
    if (kReleaseMode) {
      return '.env.prod';
    }
    return '.env.dev';
  }
  static String? get apibaseurl{

print('inside apibaseurl ${dotenv.env['baseurl']}');
    return  dotenv.env['baseurl'];
  }


  static String get userid{
    var loginresponse = json.decode(prefs!.getString("login_response")!);
    var userid =loginresponse['employeeId'].toString();

    return  userid;
  }

  static String? get deviceid{
    var device_id = prefs!.getString("deviceid");

    return  device_id;
  }

  static String? get appname{
    return dotenv.env['appname'];
  }

  static String? get appversion{
    return dotenv.env['appversion'];
  }

  static String? get appstatus{
    return dotenv.env['appstatus'];
  }
  static bool get appuserlog{
    print('inside app userlog');
    print('inside app userlog value ${prefs!.getBool("loggedin")}');
    var userlog = prefs!.getBool("loggedin")??false;
    print('inside app userlog value $prefs!.getBool("loggedin")');
    return userlog;
  }
  static String? get apptimeout{
    return dotenv.env['apptimeout'];
  }
  static String? get gettokens{
    var gettoken = prefs!.getString("token");
    return gettoken;
  }
  static String? get appxapikey{
    return dotenv.env['header_xpi'];
  }
  static String? get appxapivalue{
    return dotenv.env['header_xpi_value'];
  }
}
