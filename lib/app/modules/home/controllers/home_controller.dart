import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_expense/app/models/dashboard_result.dart';
import 'package:m_expense/app/models/user.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/services/dashboard.dart';
import 'package:m_expense/app/services/user.dart';
import 'package:m_expense/app/utils/storage.dart';

class HomeController extends GetxController {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  get getKey=>_key;

  final List<String> _currencyList = ["BDT ৳", "Euro €", "USD \$", "Pound £"];
  get currencyList => _currencyList;

  final RxString _selectedCurrency = "USD \$".obs;
  get selectedCurrency => _selectedCurrency.value;
  void setCurrency(value) => _selectedCurrency.value=value;
  User user = User();
  Rx<DashboardResult> dashboardResult = DashboardResult().obs;
  final selectedDate = DateTime.now().obs;


  @override
  void onInit() {
    super.onInit();
    getUserInfo(AppStorage().userId.val);
    getDashboardInfo(yearAndMonth: getMonthStr);
  }



  Future getDashboardInfo({required String yearAndMonth}) async {
    var response = await DashboardAPI.info(yearAndMonth);
    if(response['status']=="OK"){
      dashboardResult.value = DashboardResult.fromJson(response['result']);
    }
  }

  Future getUserInfo(String userId) async {
    var response = await UserAPI.user(userId);
    if(response['status']=="OK"){
      user = User.fromJson(response['result']);
    }
  }

  void onLogoutClick() {
    Get.offAllNamed(Routes.LOGIN);
  }

  void onSubmitExpense() {
    Get.toNamed(Routes.EXPENSE);
  }

  void onViewExpensePressed()=>Get.toNamed(Routes.EXPENSE_REPORT);

  void onCardsPressed() {
    Get.toNamed(Routes.CARDS);
  }

  void onOpenDrawerPressed() {
    _key.currentState!.openEndDrawer();
  }



  void onPreviousMonthPressed() {
    selectedDate.update((val) {
      selectedDate.value = DateTime(val!.year, val.month - 1, 1);
    });
    getDashboardInfo(yearAndMonth: getMonthStr);
  }
  void onNextMonthPressed() {
    selectedDate.update((val) {
      selectedDate.value = DateTime(val!.year, val.month + 1, 1);
    });
    getDashboardInfo(yearAndMonth: getMonthStr);
  }

  String get getMonthStr => DateFormat("yyyy-MM").format(selectedDate.value);

  String getSelectedMonth() {
    return DateFormat("MMMM yyyy").format(selectedDate.value);
  }

  Future<void> onRefresh() async {
    await getDashboardInfo(yearAndMonth: getMonthStr);
    return;
  }
}
