import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/constant/custome_textform_field.dart';
import 'package:ifresh_delivery/constant/strings.dart';
import 'package:ifresh_delivery/constant/validations.dart';
import 'package:ifresh_delivery/screens/change_password/changepass_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  ChangePassController changePassController = Get.put(ChangePassController());
  final formKey = GlobalKey<FormState>();
  bool oldviewpass = true;
  bool viewpass = true;
  bool cviewpass = true;

  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();

  change() async {
    if(formKey.currentState!.validate()){
      var changeUrl = Uri.parse(changepass_url);
      var body = {
        "old_password": oldpasswordController.text.toString(),
        "password": newpasswordController.text.toString(),
        "password_confirmation": conPasswordController.text.toString()
      };
      print("changeUrl....."+changeUrl.toString());
      print("body....."+body.toString());
      await changePassController.ChangeApi(changeUrl,body);
    }
  }

  void cancel(){
    print('bsdahjcvbjhsdbvchjsvchjs');
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomBar(bottomindex: 2,)));
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
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
          "Change Password",
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Logo Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: primary,
                    size: 50,
                  ),
                ),
                // Image.asset('assets/images/appbarlogo.png',
                //   scale: 5,
                //   color: primary,),

                const SizedBox(height: 40),

                // Old Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AuthTextField(
                    hintText: old_password,
                    length: 10,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscure: oldviewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    iconColor: primary,
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: Validations.validatePassword,
                    controller: oldpasswordController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: 16,
                    elevation: 0,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          oldviewpass = !oldviewpass;
                        });
                      },
                      icon: Icon(
                        oldviewpass ? Icons.visibility_off : Icons.visibility,
                        color: primary,
                        size: 20,
                      ),
                    ),
                    hoverColor: const Color.fromRGBO(54, 54, 54, 1),
                  ),
                ),

                const SizedBox(height: 16),

                // New Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AuthTextField(
                    hintText: newpassword,
                    length: 10,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    obscure: viewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    iconColor: primary,
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: Validations.validatePassword,
                    controller: newpasswordController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: 16,
                    elevation: 0,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          viewpass = !viewpass;
                        });
                      },
                      icon: Icon(
                        viewpass ? Icons.visibility_off : Icons.visibility,
                        color: primary,
                        size: 20,
                      ),
                    ),
                    hoverColor: const Color.fromRGBO(54, 54, 54, 1),
                  ),
                ),

                const SizedBox(height: 16),

                // Confirm Password Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AuthTextField(
                    hintText: con_newpassword,
                    length: 10,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscure: cviewpass,
                    IconImage: 'assets/images/keyIcon.png',
                    iconColor: primary,
                    Imagescale: 3.5,
                    Imageheight: 31,
                    validator: (value) => Validations.validateConfirmPassword(
                      newpasswordController.text,
                      value!,
                    ),
                    controller: conPasswordController,
                    borderColor: Colors.transparent,
                    fillColor: Colors.white,
                    borderRadius: 16,
                    elevation: 0,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          cviewpass = !cviewpass;
                        });
                      },
                      icon: Icon(
                        cviewpass ? Icons.visibility_off : Icons.visibility,
                        color: primary,
                        size: 20,
                      ),
                    ),
                    hoverColor: const Color.fromRGBO(54, 54, 54, 1),
                  ),
                ),

                const SizedBox(height: 50),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: change,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primarylogin,
                                primarylogin.withOpacity(0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: primarylogin.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Change',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: cancel,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: primarylogin,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primarylogin,
                              fontSize: 15,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}