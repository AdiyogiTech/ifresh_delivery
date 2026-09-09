// To parse this JSON data, do
//
//     final settingModel = settingModelFromJson(jsonString);

import 'dart:convert';

SettingModel settingModelFromJson(String str) => SettingModel.fromJson(json.decode(str));

String settingModelToJson(SettingModel data) => json.encode(data.toJson());

class SettingModel {
  bool status;
  String message;
  Data data;

  SettingModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Settings settings;

  Data({
    required this.settings,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    settings: Settings.fromJson(json["settings"]),
  );

  Map<String, dynamic> toJson() => {
    "settings": settings.toJson(),
  };
}

class Settings {
  String favicon;
  String logo;
  String applicationName;
  String copyright;
  String address;
  String email;
  String phone;
  String isOtpAllow;
  String facebook;
  String twitter;
  String youtube;
  String instagram;
  String forceUpdateAndroid;
  String forceUpdateIos;
  String appVersionAndroid;
  String appVersionIos;
  String appUrlAndroid;
  String appUrlIos;
  String forceUpdateMessageAndroid;
  String forceUpdateMessageIos;
  String maintenance;
  String maintenanceToggle;
  String defaultAddressPincode;
  String footerText;
  String refferMessage;
  String firebaseKey;
  String basePath;
  Map<String, String> genderList;
  Map<String, String> addressType;
  String googleMapKey;
  List<String> attributeGroup;
  List<String> isNonVeg;

  Settings({
    required this.favicon,
    required this.logo,
    required this.applicationName,
    required this.copyright,
    required this.address,
    required this.email,
    required this.phone,
    required this.isOtpAllow,
    required this.facebook,
    required this.twitter,
    required this.youtube,
    required this.instagram,
    required this.forceUpdateAndroid,
    required this.forceUpdateIos,
    required this.appVersionAndroid,
    required this.appVersionIos,
    required this.appUrlAndroid,
    required this.appUrlIos,
    required this.forceUpdateMessageAndroid,
    required this.forceUpdateMessageIos,
    required this.maintenance,
    required this.maintenanceToggle,
    required this.defaultAddressPincode,
    required this.footerText,
    required this.refferMessage,
    required this.firebaseKey,
    required this.basePath,
    required this.genderList,
    required this.addressType,
    required this.googleMapKey,
    required this.attributeGroup,
    required this.isNonVeg,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    favicon: json["favicon"],
    logo: json["logo"],
    applicationName: json["application_name"],
    copyright: json["copyright"],
    address: json["address"],
    email: json["email"],
    phone: json["phone"],
    isOtpAllow: json["is_otp_allow"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    youtube: json["youtube"],
    instagram: json["instagram"],
    forceUpdateAndroid: json["force_update_android"],
    forceUpdateIos: json["force_update_ios"],
    appVersionAndroid: json["app_version_android"],
    appVersionIos: json["app_version_ios"],
    appUrlAndroid: json["app_url_android"],
    appUrlIos: json["app_url_ios"],
    forceUpdateMessageAndroid: json["force_update_message_android"],
    forceUpdateMessageIos: json["force_update_message_ios"],
    maintenance: json["maintenance"],
    maintenanceToggle: json["maintenance_toggle"],
    defaultAddressPincode: json["default_address_pincode"],
    footerText: json["footer_text"],
    refferMessage: json["reffer_message"],
    firebaseKey: json["firebase_key"],
    basePath: json["base_path"],
    genderList: Map.from(json["gender_list"]).map((k, v) => MapEntry<String, String>(k, v)),
    addressType: Map.from(json["address_type"]).map((k, v) => MapEntry<String, String>(k, v)),
    googleMapKey: json["google_map_key"],
    attributeGroup: List<String>.from(json["attribute_group"].map((x) => x)),
    isNonVeg: List<String>.from(json["is_non_veg"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "favicon": favicon,
    "logo": logo,
    "application_name": applicationName,
    "copyright": copyright,
    "address": address,
    "email": email,
    "phone": phone,
    "is_otp_allow": isOtpAllow,
    "facebook": facebook,
    "twitter": twitter,
    "youtube": youtube,
    "instagram": instagram,
    "force_update_android": forceUpdateAndroid,
    "force_update_ios": forceUpdateIos,
    "app_version_android": appVersionAndroid,
    "app_version_ios": appVersionIos,
    "app_url_android": appUrlAndroid,
    "app_url_ios": appUrlIos,
    "force_update_message_android": forceUpdateMessageAndroid,
    "force_update_message_ios": forceUpdateMessageIos,
    "maintenance": maintenance,
    "maintenance_toggle": maintenanceToggle,
    "default_address_pincode": defaultAddressPincode,
    "footer_text": footerText,
    "reffer_message": refferMessage,
    "firebase_key": firebaseKey,
    "base_path": basePath,
    "gender_list": Map.from(genderList).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "address_type": Map.from(addressType).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "google_map_key": googleMapKey,
    "attribute_group": List<dynamic>.from(attributeGroup.map((x) => x)),
    "is_non_veg": List<dynamic>.from(isNonVeg.map((x) => x)),
  };
}
