import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Colors/colors.dart';

class Validations {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null; // Validation passed
  }
  static String? validateMetaTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter MetaTitle';
    }
    return null; // Validation passed
  }
  static String? validateMetaKeyword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter MetaKeyword';
    }
    return null; // Validation passed
  }
  static String? validateMetaDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Meta Description';
    }
    return null; // Validation passed
  }
  static String? validateSortDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter SortDescription';
    }
    return null; // Validation passed
  }
  static String? validateTags(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Product Tags';
    }
    return null; // Validation passed
  }


  // Validation of Mobile Number
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the mobile number';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null; // Validation passed
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Weight';
    }
    return null; // Validation passed
  }
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Height';
    }
    return null; // Validation passed
  }
  static String? validateLength(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Length';
    }
    return null; // Validation passed
  }
  static String? validateWidth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Width';
    }
    return null; // Validation passed
  }
  static String? validateModal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Modal ';
    }
    return null; // Validation passed
  }

  static String? validateSku(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Sku Code';
    }
    return null; // Validation passed
  }
  static String? validateMinQunatity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Minimum Quantity';
    }
    return null; // Validation passed
  }

  static String? validateMaxQunatity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Maximum Quantity';
    }
    return null; // Validation passed
  }
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Price';
    }
    return null; // Validation passed
  }
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Amount';
    }
    return null; // Validation passed
  }
  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Message';
    }
    return null; // Validation passed
  }
  static String? validateMargin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Margin';
    }
    return null; // Validation passed
  }
  static String? validateWholeSaleMargin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the WholeSale Margin';
    }
    return null; // Validation passed
  }
  static String? validateWholeSalePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the WholeSale Price';
    }
    return null; // Validation passed
  }
  static String? validateWholeSaleMarginPer(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the WholeSale margin percentage';
    }
    return null; // Validation passed
  }
  static String? validateMarginPercentage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Margin Percentage';
    }
    return null; // Validation passed
  }
  ///
  static String? validateVariantPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Variant Price';
    }
    return null; // Validation passed
  }
  static String? validateVariantMargine(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Variant Margin';
    }
    return null; // Validation passed
  }
  static String? validateVariantwholesale(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Variant Wholesale';
    }
    return null; // Validation passed
  }
  static String? validateVariantwholesaleMargin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Variant Wholesale Margin';
    }
    return null; // Validation passed
  }







  // Validation of Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {

      return 'Please enter a valid email address';
    }
    return null; // Validation passed
  }

  // Validation of Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the password';
    }
    if (value.length < 8) {
      return 'Password size must be 8';
    }
    return null; // Validation passed
  }

  // Validation of Confirm Password
  static String? validateConfirmPassword(
      String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null; // Validation passed
  }

  static String? validateState(String value) {
    if (value.isEmpty) {
      return 'Please enter State';
    }
    return null; // Validation passed
  }

  static String? validateCity(String value) {
    if (value.isEmpty) {
      return 'Please enter City';
    }
    return null; // Validation passed
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return ' Please enter OTP';
    }
    else if(value.length != 6){
      return ' Please enter correct OTP';
    }
    return null; // Validation passed
  }

  static String? validatePincode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the Pincode';
    }
    if (value.length != 6) {
      return 'Pincode must be 6 digits';
    }
    return null; // Validation passed
  }


  static String? validateAddress(String value) {
    if (value.isEmpty) {
      return 'Please enter Address';
    }

    return null; // Validation passed
  }
}
Future<void> toastMsg(var msg,bool iserrorr){
  var Msg = Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: iserrorr == true?Colors.red:primarylogin,
      textColor: Colors.white,
      fontSize: 16.0
  );
  return Msg;
}