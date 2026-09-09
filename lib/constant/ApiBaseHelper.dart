import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/Environment/Environment.dart';

import 'package:http/http.dart' as http;

import '../helper_widget/bottombar.dart';
import '../main.dart';
import '../screens/login/login_model.dart';
import '../screens/login/login_screen.dart';
import '../screens/setting_model_controller/setting_model.dart';

// var currentdate= DateFormat('yyyy-MM-dd').format(DateTime.now());
var setting_complete_data;

class ApiBaseHelper {

  var _mainHeaders;

  void updateHeader(String token) {
    print("token update...."+token.toString());
    _mainHeaders = {
      // 'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  var subheaders = {
    // 'Content-Type': 'application/json',
    Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
  };

   var setting_json_data;
  //
  settingdata(response) {
    print('inside setting response $response');
    var JWTmodel = SettingModel.fromJson(response);
    log('JWTmodel==>'+JWTmodel.toString());
    prefs!.setString("setting", json.encode(JWTmodel).toString());
    setting_json_data = json.decode(prefs!.getString("setting").toString());
    log('>setting_json_data=='+setting_json_data.toString());
    print("inside setting_json_data...."+setting_json_data['data']['settings']['application_name'].toString());

    setting_complete_data = setting_json_data;
    print("setting_contoller_data...."+setting_complete_data.toString());
  }

  Future<String> getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      prefs!.setString("deviceid", iosDeviceInfo.identifierForVendor.toString());
      return iosDeviceInfo.identifierForVendor.toString(); // unique ID on iOS
    } else   {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      prefs!.setString("deviceid",androidDeviceInfo.id.toString());
      log("check android id --->>${prefs!.getString("deviceid")}");
      return androidDeviceInfo.id.toString();

    }

  }
  Future<void> logindata(login) async {
    var JWTmodel = LoginModel.fromJson(login);

    prefs!.setString("loginresponse", json.encode(JWTmodel).toString());
    var jsondata = json.decode(prefs!.getString("loginresponse").toString());

    prefs!.setString("token", jsondata['data']['token'].toString());
    prefs!.setBool("loggedin",true);
    var get_token= prefs!.getString("token").toString();
    updateHeader(get_token);

    print("inside get login token ${prefs!.getString("token").toString()}");
    print("jsondat...."+prefs!.getBool("loggedin").toString());

    Get.offAll(BottomBar(bottomindex: 2,));
  }

  Future<void> AppLogout() async {
    try {
      // SharedPreferences clear
      prefs!.setBool("loggedin", false);
      prefs!.remove("token");

      // Optional: temp cache files bhi delete karna ho to
      final tempDir = Directory.systemTemp;
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }

      Get.offAll(() => const LoginScreen()); // back stack bhi clear
    } catch (e) {
      print("Logout error: $e");
    }
  }


  Future<http.Response> postAPICall(Uri url, parameter, bool header) async {
    print("Post URL: $url");
    print("Post Parameter: $parameter");

    var token = Environment.gettokens;

    print("Get token for post API: $token");

    // Define the headers, including the 'Content-Type' for JSON
    var subheaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
    };
    Map<String, String> mainHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      'Authorization': 'Bearer $token',
      // 'Content-Type': 'application/json', // Add Content-Type header
    };

    try {
      // Ensure the body is encoded as JSON if it's a Map
      // String body = json.encode(parameter);

      final response = await http
          .post(
        url,
        body: parameter,  // Use the JSON-encoded body
        headers: header == true ? mainHeaders : subheaders,
      )
          .timeout(
        Duration(
          seconds: int.parse(Environment.apptimeout.toString()),
        ),
      );
      print("Post StatusCode: ${response.statusCode}");
      print("Post Response: ${response.body}");
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  Future<http.Response> getAPICall(Uri url, header) async {
    print("get url 1: $url");

    var token =Environment.gettokens;

    print("get token : $token");

    var subheaders = {
      // 'Content-Type': 'application/json',
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
    };
    Map<String, String> mainHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.get(
        url,
        headers: header == true ? mainHeaders : subheaders,
      ).timeout(
        Duration(seconds: int.parse(Environment.apptimeout.toString()),
        ),
      );

      print("get statusCode : ${response.statusCode.toString()}");
      print("get response : ${response.body.toString()}");
      return _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }

  }
  Future<http.Response> putAPICall(Uri url, parameter, header) async {
    log("post url : $url");
    log("post parameter : $parameter");
    Map<String, String> headers;
    log("${header} ");
    if (header != null) {
      var token = Environment.gettokens;
      print("post if ");
      headers = {
        'Content-Type': 'application/json',
        Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
        'Authorization': 'Bearer $token'
      };
    } else {
      print("post else ");
      headers = {
        'Content-Type': 'application/json',
        Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      };
    }
    log("post header : ${headers} ");

    try {
      final response = await http.put(url,
        body: parameter.isNotEmpty ? jsonEncode(parameter) : null,
        headers: headers,
      ).timeout(Duration(
        seconds: int.parse(Environment.apptimeout.toString()),
      ),
      );

      log("post statusCode : ${response.statusCode.toString()}");
      log("post response : ${response.body.toString()}");
      return _response(response);
    } on SocketException {
      log("post SocketException");
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      log("post TimeoutException");
      throw FetchDataException('Something went wrong, try again later');
    }
  }
  Future<http.Response> multipartAPICall(url, parameter,header) async {
    print("multipart url : $url");
    print("multipart parameter : $parameter");
    print("multipart header : $header");
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(parameter);

      request.headers.addAll(header == null ? _mainHeaders : header);

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);

      print("multipart statusCode : ${responsedata.statusCode.toString()}");
      print("multipart response : ${responsedata.body.toString()}");

      return _response(responsedata);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  http.Response _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 422:

        return response;
      case 401:
        // AppLogout();
        return response;
    // toastMsg(jsonDecode(response.body)['messages'][0], true);
    // throw BadRequestException(response.body.toString());
      case 404:
      // toastMsg(jsonDecode(response.body)['messages'][0], true);
      // throw BadRequestException(response.body.toString());
        return response;
      case 401:
      // toastMsg(jsonDecode(response.body)['messages'][0], true);
        return response;
    //
    // throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
        return response;
      default:
      // toastMsg(jsonDecode(response.body)['messages'][0], true);
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode: ${response.statusCode}');
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
