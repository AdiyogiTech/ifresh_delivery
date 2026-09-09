import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/Constant/SizeBox.dart';
import 'package:ifresh_delivery/Environment/Environment.dart';
import 'package:ifresh_delivery/constant/ApiBaseHelper.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/constant/custome_textform_field.dart';
import 'package:ifresh_delivery/constant/validations.dart';
import 'package:ifresh_delivery/screens/profile/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Edit_profile extends StatefulWidget {
  const Edit_profile({super.key});

  @override
  State<Edit_profile> createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile> {
  ProfileController profileControllers = Get.put(ProfileController());

  File? pickfile;

  Future<http.Response> multipartAPICall(url, parameter) async {
    print("post url : $url");
    print("post parameter : $parameter");


    var token = Environment.gettokens;

    print("get token : $token");
    Map<String, String> mainHeaders = {
      Environment.appxapikey.toString(): Environment.appxapivalue.toString(),
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(parameter);

      request.headers.addAll(mainHeaders);

      // ignore: unnecessary_null_comparison
      if (pickfile != null) {
        print("response body...." + pickfile.toString());
        request.files.add(await http.MultipartFile.fromPath(
            'image', pickfile!.path));
      } else {}

      http.StreamedResponse responses = await request.send();

      var responsedata = await http.Response.fromStream(responses);
      print("response body...." + responsedata.toString());
      print("response body...." + pickfile.toString());
      final result = jsonDecode(responsedata.body);

      if (responsedata.statusCode == 200) {
        var profileUrl = Uri.parse(profile_url);
        Get.find<ProfileController>().GetProfileData(profileUrl);
        Get.back();
      }

      print("post statusCode : ${responsedata.statusCode.toString()}");

      print("post response : ${responsedata.body.toString()}");

      return responsedata;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
  }

  imagenull() {
    pickfile = null;
  }

  Future getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 100);
    if (pickedFile != null) {
      pickfile = File(pickedFile.path);

      setState(() {});
      print("pick file form gellary" + pickfile.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imagenull();
    getcalldata();
  }

  final formKey = GlobalKey<FormState>();

  // use for api
  bool isStoreOpen = false;
  var store_status;
  var selectedCountry;
  var selectedState;
  var selectedCity;
  var selectedArea;

  List countryList = [];
  List stateList = [];
  List cityList = [];
  List areaList = [];
  var countryId; // use for api
  var stateId; // use for api
  var cityId;
  var areaId;

  Future<void> getcalldata() async {
    var profileData = Get.find<ProfileController>().profileData;
    if (profileData != null) {
      if (profileData['country_name'] != null && profileData['country_id'] != null) {
        selectedCountry = profileData['country_name'] == null
            ? "Select Country"
            : profileData['country_name'].toString();
        countryId = profileData['country_id'] == null
            ? ""
            : profileData['country_id'].toString();
        await fetchCountry();
        if (profileData['state_name'] != null &&
            profileData['state_id'] != null) {
          selectedState = profileData['state_name'].toString();
          stateId = profileData['state_id'].toString();
          fetchState(countryId.toString());
        }
        if (profileData['city_name'] != null &&
            profileData['city_id'] != null) {
          selectedCity = profileData['city_name'].toString();
          cityId = profileData['city_id'].toString();
          fetchCity(stateId.toString());
        }
        if (profileData['area_name'] != null &&
            profileData['area_id'] != null) {
          selectedArea = profileData['area_name'].toString();
          areaId = profileData['area_id'].toString();
          fetchArea(cityId.toString());
        }
      } else {
        fetchCountry();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
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
          "Edit Profile",
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
      body: GetBuilder<ProfileController>(builder: (profileController) {
        if (profileController.ProfileLoader.value) {
          return Center(
            child: CircularProgressIndicator(
              color: primarylogin,
              strokeWidth: 2,
            ),
          );
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Profile Header with Image
                Container(
                  height: 140,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // Profile Image
                        Stack(
                          children: [
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
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: pickfile != null
                                      ? Image.file(
                                    File(pickfile!.path.toString()),
                                    fit: BoxFit.cover,
                                    height: 78,
                                    width: 78,
                                  )
                                      : Image.network(
                                    profileController.image.toString(),
                                    width: 78,
                                    height: 78,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/images/iFresh.png",
                                        width: 78,
                                        height: 78,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  getFromGallery();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: primarylogin,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),

                        // User Info
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileController.name.toString().capitalize ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profileController.mobile.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Form Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Name Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AuthTextField(
                          hintText: "Enter Name",
                          validator: Validations.validateName,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]"))
                          ],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          Imagescale: 2,
                          IconImage: 'assets/images/eprofile.png',
                          iconColor: primary,
                          controller: profileController.nameController,
                          borderColor: Colors.transparent,
                          fillColor: Colors.white,
                          borderRadius: 16,
                          elevation: 0,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Mobile Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AuthTextField(
                          hintText: "Enter Mobile No.",
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: Validations.validateMobile,
                          IconImage: 'assets/images/phone.png',
                          iconColor: primary,
                          Imagescale: 1.5,
                          controller: profileController.mobileController,
                          borderColor: Colors.transparent,
                          fillColor: Colors.white,
                          borderRadius: 16,
                          elevation: 0,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Email Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AuthTextField(
                          hintText: "Enter Email",
                          length: 25,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validations.validateEmail,
                          IconImage: 'assets/images/ic_mail.png',
                          iconColor: primary,
                          controller: profileController.emailController,
                          Imagescale: 3.5,
                          borderColor: Colors.transparent,
                          fillColor: Colors.white,
                          borderRadius: 16,
                          elevation: 0,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Address Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AuthTextField(
                          hintText: "Enter address",
                          length: 40,
                          validator: Validations.validateName,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]"))
                          ],
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          Imagescale: 1.8,
                          IconImage: 'assets/images/city.png',
                          iconColor: primary,
                          controller: profileController.addressController,
                          borderColor: Colors.transparent,
                          fillColor: Colors.white,
                          borderRadius: 16,
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Location Dropdowns
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Country Dropdown
                      _buildDropdownField(
                        hint: selectedCountry ?? "Select Country",
                        value: selectedCountry,
                        items: countryList.map((country) {
                          return DropdownMenuItem<String>(
                            value: country['name'].toString(),
                            child: Container(
                              width: size.width * 0.6,
                              child: Text(
                                country['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                countryId = country['id'].toString();
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          print('Selected State ID: $newValue');
                          cityList.clear();
                          stateList.clear();
                          areaList.clear();
                          fetchState(countryId);
                          selectedCity = null;
                          selectedState = null;
                          selectedArea = null;
                          setState(() {
                            selectedCountry = newValue;
                            if (countryId == 0) {
                              countryId = null;
                            }
                          });
                        },
                        iconPath: 'assets/images/city.png',
                      ),

                      const SizedBox(height: 12),

                      // State Dropdown
                      _buildDropdownField(
                        hint: selectedState ?? "Select State",
                        value: selectedState,
                        items: stateList.map((state) {
                          return DropdownMenuItem<String>(
                            value: state['name'].toString(),
                            child: Container(
                              width: size.width * 0.6,
                              child: Text(
                                state['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                stateId = state['id'].toString();
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          print('Selected State ID: $newValue');
                          cityList.clear();
                          areaList.clear();
                          fetchCity(stateId);
                          selectedCity = null;
                          selectedArea = null;
                          setState(() {
                            selectedState = newValue;
                            if (stateId == 0) {
                              stateId = null;
                            }
                          });
                        },
                        iconPath: 'assets/images/city.png',
                      ),

                      const SizedBox(height: 12),

                      // City Dropdown
                      _buildDropdownField(
                        hint: selectedCity ?? "Select City",
                        value: selectedCity,
                        items: cityList.map((city) {
                          return DropdownMenuItem<String>(
                            value: city['name'].toString(),
                            child: Container(
                              width: size.width * 0.6,
                              child: Text(
                                city['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                cityId = city['id'].toString();
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          areaList.clear();
                          fetchArea(cityId);
                          selectedArea = null;
                          setState(() {
                            selectedCity = newValue;
                            if (cityId == 0) {
                              cityId = null;
                            }
                          });
                        },
                        iconPath: 'assets/images/city.png',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              var updateUrl = update_profile_url;

                              var body = {
                                'name': profileControllers.nameController.text,
                                'email': profileControllers.emailController.text,
                                'mobile': profileControllers.mobileController.text,
                                'address': profileControllers.addressController.text,
                                'country_id': countryId.toString(),
                                'state_id': stateId.toString(),
                                'city_id': cityId.toString(),
                                'area_id': areaId.toString(),
                                'store_status': store_status.toString(),
                                'latitude': "26.2994579",
                                'longitude': "73.0287094"
                              };
                              print("updateUrl....." + updateUrl.toString());
                              print("body....." + body.toString());
                              await multipartAPICall(updateUrl, body);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primarylogin,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primarylogin,
                            side: BorderSide(color: primarylogin, width: 1.5),
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required String iconPath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        isExpanded: true,
        isDense: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              iconPath,
              scale: 1.8,
              width: 20,
              height: 20,
              color: primarylogin,
            ),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        value: value,
        items: items,
        validator: (val) {
          if (val == null) {
            return "Please select an option";
          }
          return null;
        },
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey[600],
          size: 20,
        ),
      ),
    );
  }

  var countries_url = "${baseurlCustomer}" + "countries";
  var states_url = "${baseurlCustomer}" + "states/";
  var cities_url = "${baseurlCustomer}" + "cities/";
  var areas_url = "${baseurlCustomer}" + "areas/";

  Future<void> fetchCountry() async {
    var countryUrl = Uri.parse(countries_url);
    print("countryUrl--> " + countryUrl.toString());
    var response = await ApiBaseHelper().getAPICall(countryUrl, true);
    var CountryData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        countryList.addAll(CountryData['data']);
      });
    }
  }

  Future<void> fetchState(countryId) async {
    var stateUrl = Uri.parse(states_url + countryId);
    print("profileUrl--> " + stateUrl.toString());
    var response = await ApiBaseHelper().getAPICall(stateUrl, true);
    var StateData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        stateList.addAll(StateData['data']);
      });
    }
  }

  Future<void> fetchCity(state_id) async {
    var cityUrl = Uri.parse(cities_url + state_id);
    print("cityurl : " + cityUrl.toString());
    var response = await ApiBaseHelper().getAPICall(cityUrl, true);
    var CityData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        cityList.addAll(CityData['data']);
      });
    }
  }

  Future<void> fetchArea(city_id) async {
    var areaUrl = Uri.parse(areas_url + city_id);
    print("cityurl : " + areaUrl.toString());
    var response = await ApiBaseHelper().getAPICall(areaUrl, true);
    var AreaData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        areaList.addAll(AreaData['data']);
      });
    }
  }
}

OutlineInputBorder _outLineInputBoarder(Color borderColor) {
  return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1),
      borderRadius: BorderRadius.circular(12));
}