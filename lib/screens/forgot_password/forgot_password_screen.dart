import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/Constant/SizeBox.dart';
import 'package:ifresh_delivery/Constant/custome_auth_design.dart';
import 'package:ifresh_delivery/Constant/custome_textform_field.dart';
import 'package:ifresh_delivery/Constant/validations.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/constant/strings.dart';
import 'package:ifresh_delivery/screens/forgot_password/forgot_controller.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  ForgotController forgotController = Get.put(ForgotController());


  bool viewpass = true;
  bool cviewpass = true;
  bool isTimerStart = false;
  bool isTimerDisplay = false;
  bool isResendDisplay = false;



  final defaultPinTheme = PinTheme(
    width: 45,
    height: 45,
    margin: EdgeInsets.symmetric(horizontal: 2),
    padding: EdgeInsets.all(12),
    textStyle: TextStyle(fontSize: 16, color: Colors.black54),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthBackground(
        labelname: 'Forgot Password',
        childs: Form(
          key: formKey,
          child: Column(
            children: [
              sizebox_height_40,
              AuthTextField(
                hintText: mobile,
                validator: Validations.validateMobile,
                length: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                IconImage: 'assets/images/phone.png',
                Imagescale: 1.3,
                controller: forgotController.mobileNo,
              ),
              AuthTextField(
                hintText: newpassword,
                length: 12,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscure: viewpass,
                IconImage: 'assets/images/keyIcon.png',
                Imagescale: 3.5,
                Imageheight: 31,
                validator: Validations.validatePassword,
                controller: forgotController.newPass,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (viewpass) {
                        //if viewpass == true, make it false
                        viewpass = false;
                      } else {
                        viewpass = true; //if viewpass == false, make it true
                      }
                    });
                  },
                  icon: Icon(
                    viewpass == true ? Icons.visibility_off : Icons.visibility,
                    color: primary,
                    size: 24,
                  ),
                ),
                hoverColor: Color.fromRGBO(54, 54, 54, 1),
              ),
              AuthTextField(
                hintText: con_newpassword,
                length: 12,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                IconImage: 'assets/images/keyIcon.png',
                controller: forgotController.conPass,
                Imagescale: 3.5,
                obscure: cviewpass,

                validator:(value)=>  Validations.validateConfirmPassword
                  (forgotController.newPass.text, value!),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (cviewpass) {
                        //if viewpass == true, make it false
                        cviewpass = false;
                      } else {
                        cviewpass = true; //if viewpass == false, make it true
                      }
                    });
                  },
                  icon: Icon(
                    cviewpass == true ?
                    Icons.visibility_off :
                    Icons.visibility,
                    color: primary,
                    size: 24,
                  ),
                ),
                hoverColor: Color.fromRGBO(54, 54, 54, 1),
              ),
              sizebox_height_50,
              GestureDetector(
                onTap: () async {
                  if(formKey.currentState!.validate()){
                    print('numnber ,,,,,,,,, ${forgotController.mobileNo.text.toString()}');
                    var forgotbody = {
                      "mobile": forgotController.mobileNo.text,
                      "is_register":"0"
                    };
                    await forgotController.ForgotSendOtp(Uri.parse(send_otp_url), forgotbody);
                  }

                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                      border: Border.fromBorderSide(BorderSide(
                          width: 5,
                          color: primarylogin
                      ))
                  ),
                  child: CircleAvatar(
                    radius: 31,
                    backgroundColor: primarylogin,
                    child: Center(
                        child: Icon(Icons.arrow_forward_ios_rounded,
                          color: white,
                          size: 35,
                        ) ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
