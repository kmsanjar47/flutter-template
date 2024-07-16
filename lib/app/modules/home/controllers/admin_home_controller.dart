import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_expense/app/modules/expense_report/bindings/expense_report_binding.dart';
import 'package:m_expense/app/modules/expense_report/views/expense_report_view.dart';
import 'package:m_expense/app/routes/app_pages.dart';

class AdminHomeController extends GetxController {

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  get getKey=>_key;

  void onMenuIconClick() {
    _key.currentState!.openEndDrawer();
  }

  void onSubmitExpense() {
    Get.toNamed(Routes.EXPENSE);
  }

  void onViewExpensePressed()=>Get.toNamed(Routes.EXPENSE_REPORT);

  void onCardsPressed() {
    Get.toNamed(Routes.CARDS);
  }

  void onShowApplicationPressed() {
    Get.toNamed(Routes.EXPENSE_REPORT);
  }
}
