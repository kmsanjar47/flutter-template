import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/utils/storage.dart';

class AppDrawerController extends GetxController {
  //TODO: Implement DrawerController

  
  get languageCode => AppStorage().languageCode.val;

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


  void onCloseClick()=>Get.back();

  void onLogOutClick() {
    AppStorage().logOutUser();
  }

  void onChangeLanguageTap() {
    if(languageCode== 'en'){
      Locale locale = const Locale('du', 'DU');
      Get.updateLocale(locale);
      setLanguageCode('du');
    }
    else{
      Locale locale = const Locale('en', 'US');
      Get.updateLocale(locale);
      setLanguageCode('en');
    }
  }

  void setLanguageCode(String value){ AppStorage().languageCode.val = value;}

}
