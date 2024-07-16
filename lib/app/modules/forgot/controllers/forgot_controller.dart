import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/modules/forgot/views/otp_view.dart';
import 'package:m_expense/app/modules/forgot/views/reset_view.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/services/forgot.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ForgotController extends GetxController {
  //TODO: Implement ForgotController


  var otp = '';
  var isValueFill = false.obs;
  String email = "";
  String tempPass = "";
  String password = "";
  String accessToken = "";


  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordFormKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: Get.context!);

  RxBool newObscure = true.obs;
  RxBool confirmedObscure = true.obs;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onCodeChange(String? value) async {
    otp = value!;
  }

  String? emailValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }

    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  void onEmailSave(String? value) => email = value??"";
  void onPasswordSave(String? value) => password = value??"";
  void onSendOtpPressed() async {

      if(emailFormKey.currentState!.validate()){
        emailFormKey.currentState!.save();
        _dialog.show(message: 'Processing...', type: SimpleFontelicoProgressDialogType.phoenix);

        var response = await ForgotPassAPI.sendOTP(
            {
              "email": email,
              "otp_length": 4
            }
        );
        if(response['status'] != "OK"){
          Get.snackbar("Error", response['message']);
          _dialog.hide();
        }
        else{
          _dialog.hide();
          Get.to(()=>const OtpView());
        }

    }
  }

  Future<void> onVerifyOtpPressed() async {

    if(otp.length==4){
      isValueFill.value=true;
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      _dialog.show(message: AppText.verifying_dot_dot.tr, type: SimpleFontelicoProgressDialogType.phoenix);
      var response = await ForgotPassAPI.matchOTP(
          {
            "email": email,
            "otp": int.parse(otp)
          }
      );
      otp="";
      if(response['status'] == "OK"){

        _dialog.hide();
        accessToken = response['result']['access_token'];
        Get.off(const ResetView());
      }
      else{

        _dialog.hide();
        Get.snackbar(
            "Error", response['message'],
          snackPosition: SnackPosition.BOTTOM
        );
      }


    }else {
      Get.snackbar(
        "Warning", "Please enter 4 digit OTP",
        snackPosition: SnackPosition.BOTTOM
      );
      isValueFill.value=false;
    }

    // if(emailFormKey.currentState!.validate()){
    //   emailFormKey.currentState!.save();
    //   var response = await ForgotPassAPI.sendOTP(
    //       {
    //         "email": email,
    //         "otp_length": 4
    //       }
    //   );
    //   if(response['status'] != "OK"){
    //     Get.snackbar("Error", response['message']);
    //   }
    // }

    // Get.to(()=>ResetView());
  }


  String? validateNewPass(String? value) {
    tempPass = value ?? "";
    if (value == null || value.isEmpty) {
      return 'Please enter a new password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    // Check for at least one numerical digit and one special character
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    RegExp digitRegex = RegExp(r'\d');

    if (!specialCharRegex.hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }

    if (!digitRegex.hasMatch(value)) {
      return 'Password must contain at least one numerical digit.';
    }

    return null;
  }


  String? validateRePass(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password.';
    }

    if (value != tempPass) {
      return 'Passwords do not match.';
    }

    return null;
  }


  void onChangePasswordPressed() async {
    if(passwordFormKey.currentState!.validate()){
      passwordFormKey.currentState!.save();
      var response = await ForgotPassAPI.changePassword(
          {
            "access_token": accessToken,
            "new_password": password
          }
      );
      if(response['status'] == "OK"){
        accessToken = "";
      }else{
        Get.snackbar("Error", response['message']);
      }

      Get.offAllNamed(Routes.LOGIN);


    }
  }
}
