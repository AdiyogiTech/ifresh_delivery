import 'package:flutter/material.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/Constant/SizeBox.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/screens/profile/editprofile.dart';
import 'package:ifresh_delivery/screens/profile/profile_controller.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileController profileController = Get.put(ProfileController());

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callProfileapi();
    });
  }

  callProfileapi()async{
    var profileUrl=Uri.parse(profile_url);
    await profileController.GetProfileData(profileUrl);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: GetBuilder<ProfileController>(
        builder: (ProfileController) {
          if (ProfileController.ProfileLoader.value) {
            return Center(
              child: CircularProgressIndicator(
                color: primarylogin,
                strokeWidth: 2,
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
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
                          // Profile Image with Edit Button
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
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: Image.network(
                                      profileController.image.toString(),
                                      height: 88,
                                      width: 88,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/iFresh.png",
                                          height: 88,
                                          width: 88,
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
                                    Get.to(() => Edit_profile());
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
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
                                      Icons.edit,
                                      color: primarylogin,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 16),

                          // User Name
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileController.name.toString().capitalize ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    "Delivery Partner",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Profile Information Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
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
                        // Phone
                        _buildInfoItem(
                          icon: Icons.phone_outlined,
                          title: "Phone Number",
                          value: profileController.mobile.toString(),
                        ),

                        const SizedBox(height: 20),

                        // Email
                        _buildInfoItem(
                          icon: Icons.email_outlined,
                          title: "Email Address",
                          value: profileController.email.toString(),
                        ),

                        // Commented sections preserved
                        // const SizedBox(height: 20),
                        // _buildInfoItem(
                        //   icon: Icons.location_city_outlined,
                        //   title: "Country",
                        //   value: profileController.country_name.toString(),
                        // ),

                        // const SizedBox(height: 20),
                        // _buildInfoItem(
                        //   icon: Icons.map_outlined,
                        //   title: "State",
                        //   value: profileController.state_name.toString(),
                        // ),

                        const SizedBox(height: 20),

                        // City
                        _buildInfoItem(
                          icon: Icons.location_on_outlined,
                          title: "City",
                          value: profileController.city_name.toString(),
                        ),

                        // Commented address section
                        // const SizedBox(height: 20),
                        // _buildInfoItem(
                        //   icon: Icons.home_outlined,
                        //   title: "Address",
                        //   value: profileController.address.toString(),
                        //   isMultiLine: true,
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Edit Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => Edit_profile());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primarylogin,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    bool isMultiLine = false,
  }) {
    return Row(
      crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primarylogin.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primarylogin,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value != "null" ? value : "Not provided",
                style: TextStyle(
                  fontSize: isMultiLine ? 14 : 16,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: isMultiLine ? 3 : 1,
                overflow: isMultiLine ? TextOverflow.ellipsis : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}