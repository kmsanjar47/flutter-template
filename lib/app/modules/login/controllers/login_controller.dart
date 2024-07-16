import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:m_expense/app/const/const.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/services/user.dart';
import 'package:m_expense/app/utils/storage.dart';
import 'package:m_expense/app/models/credential.dart';


class LogInController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Credential _credential = Credential();
  final RxBool remember = false.obs;
  final AppStorage _storage = AppStorage();

  final RxBool obscure = true.obs;


  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
    if(_storage.login.val && _storage.remember.val){
      Get.offAllNamed(Routes.HOME);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }


  void onLoginClick() async {
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      var response = await UserAPI.login(_credential.toJson());
      if(response['status'] == "OK"){
        var data = JwtDecoder.decode(response['result']['access_token']);
        _storage.loginUser(
            login: true,
            remember: remember.value,
            userId: data['user_id'],
            userName: data['username'],
            userProfileName: (data['first_name']??"") + " " + (data['last_name']??""),
            refreshToken: response['result']['refresh_token'],
            token: response['result']['access_token']);
      }
      else{
        Get.snackbar("Error", response['message'],colorText: Colors.red);
      }

    }


  }

  String? emailValidation(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'Please enter an email address.';
    // }
    //
    // final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // if (!emailRegExp.hasMatch(value)) {
    //   return 'Please enter a valid email address.';
    // }
    return null;
  }

  void onEmailSave(String? email) => _credential.username = email;
  void onPasswordSave(String? password) => _credential.password = password;
  void onRememberMeClick(bool? value) {
    remember.value = !remember.value;
  }


}
