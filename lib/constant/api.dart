
import 'package:ifresh_delivery/Environment/Environment.dart';

String baseurl = "${Environment.apibaseurl}";

 // var baseurlCustomer = "https://garu.co.in/api/customer/";
 var baseurlCustomer = "https://ifresh.technolite.in/api/customer/";
 // var baseurlCustomer = "https://garu.technolite.in/api/customer/";
 // var baseurlCustomer = "https://staging.adiyogitechnology.com/onlineutsav/api/customer/";

var settings_url = "${baseurl}" +"settings";
var send_otp_url = "${baseurl}" +"send-otp";
var login_url = "${baseurl}" +"login";
var profile_url = "${baseurl}" +"profile";
var update_profile_url = "${baseurl}" +"update-profile";
var forgot_url = "${baseurl}" +"reset-password";
var changepass_url = "${baseurl}" +"change-password";
var dashboard_url = "${baseurl}" +"dashboard";
var notifications_url = "${baseurl}" +"notifications";
var cms_url = baseurlCustomer + "cms/";

//Order Urls
var order_list_url ="${baseurl}" +"orders-list";
var order_details_url ="${baseurl}" +"order-detail";
var order_status_url ="${baseurl}" +"order-status";
var order_delivered_url ="${baseurl}" +"order-delivered";
var order_status_update_url ="${baseurl}" +"order-status-update";
var order_status_updateOtp_url ="${baseurl}" +"send-order-otp";
var order_item_cencel_url ="${baseurl}" +"order-item-cancel";

var delivery_order_update_status = "${baseurl}delivery-order-status";

//location urls
var locationStatusUrl = "${baseurl}update_location_status";
var locationUpdateUrl = "${baseurl}update_location";

///notification api...
var notification_url ="${baseurl}" +"notifications";

//wallet apis
var walletRequestUrl = '${baseurl}deliveryboy/get-wallet?page=1&limit=10&search=&type=0';
var addWithdraw_request="${baseurl}add-withdraw-request";

//=======> APP UPDATE HERE <=======

double appversion = 4.0;
double iosversion = 1.0;
var maintainversion = "1";
String App_force_updateNo="1";
var appname = "iFresh Delivery";
var appmaintancename = "iFresh Delivery";