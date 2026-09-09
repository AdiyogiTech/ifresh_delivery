import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:here_sdk/core.dart';
import 'package:ifresh_delivery/Constant/validations.dart';
import '../../Constant/ApiBaseHelper.dart';
import '../../constant/api.dart';
import '../../screens/here_map/routing.dart';
import '../../screens/order_list/orderList_controller.dart';
import 'locationService.dart';


class LocationController extends GetxController {
  var locationDataLoading = false.obs;
  var locationSendingDataLoading = false.obs;


  Rxn<GeoCoordinates> deliveryBoyCoordinates = Rxn<GeoCoordinates>();

  final LocationService locationService = LocationService();


  locationStatusApiCalling(bool status) async {
    locationDataLoading.value = true;
    var url = locationStatusUrl;
    try {
      var response = await ApiBaseHelper().postAPICall(
          Uri.parse(url), {"location_status": status.toString()}, true);
        print("Location API Response: ${response.body}");

    } catch (e) {
      print("Error: $e");
    } finally {
      locationDataLoading.value = false;
      update();
    }
  }

  // Function to call the API with location data (latitude, longitude, and address)
  locationApiCalling(String lat, String long, {String? address}) async {
    locationSendingDataLoading.value = true;
    var url = locationUpdateUrl;

    try {

      // Prepare the request data
      var response = await ApiBaseHelper().postAPICall(Uri.parse(url), {
        'latitude': lat,
        'longitude': long,
        'address': address,
      }, true);

      // Update delivery boy coordinates
      deliveryBoyCoordinates.value = GeoCoordinates(
        double.parse(lat),
        double.parse(long),
      );

      log('Updated Coordinates: ${deliveryBoyCoordinates.value}');

      // Refresh the marker on the map
      // routingExample.addRoute(startCoordination: vendorLocation, endCoordination: customerLocation); // Call the function to refresh the marker

      print("Location 5 mins API Response: ${response.body}");

      // Handle success response
      if (response.statusCode == 200) {
        print("response >> ${response.body.toString()}");
       // toastMsg('Location updated successfully !!', false);
      } /*else {
        toastMsg('Failed to update location', true);
      }*/
    } catch (e) {
      print("Error: $e");
      toastMsg('An error occurred while updating location', true);
    } finally {
      locationSendingDataLoading.value = false;
      update(); // Update any observers
    }
  }


  // Function to fetch location and then call the location API
  updateLocation() async {
    log('Update Location is called !!');
    Position? position = await locationService.getCurrentLocation();
    if (position != null) {
      // Fetch address from latitude and longitude
      String address = await locationService.getAddressFromCoordinates(
          position.latitude, position.longitude);

      // Call the locationApiCalling function with fetched location data and address
      await locationApiCalling(
        position.latitude.toString(),
        position.longitude.toString(),
        address: address, // Pass the address obtained from reverse geocoding
      );
    } else {
      toastMsg('Unable to get current location\nPlease On Your Location!!', true);
    }
  }
}

