
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_expense/app/const/const.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/models/DTree.dart';
import 'package:m_expense/app/models/expense.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/services/dropdown.dart';
import 'package:m_expense/app/services/expense.dart';
import 'package:m_expense/app/utils/storage.dart';
import 'package:photo_view/photo_view.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ExpenseReportController extends GetxController {

  final RxBool _isSubmittedFilter = true.obs;
  get isSubmitted => _isSubmittedFilter.value;
  final AppStorage _storage = AppStorage();
  final List<String> _dateRange = [
    DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 730))),
    DateFormat('yyyy-MM-dd').format(DateTime.now())
  ];
  final RxList<Expense> _allExpense = <Expense>[].obs;
  final RxList<Expense> _expenseList = <Expense>[].obs;
  List<DTree> _expenseTypeList = <DTree>[];
  final RxList<DTree> _currencies = <DTree>[].obs;
  RxList<Expense> get expenseList => _expenseList;
  List<DTree> get expenseTypeList => _expenseTypeList;


  final RxString _filterType = "All".obs;
  String get getFilterType => _filterType.value;

  final RxBool _showReport = false.obs;
  get showReport => _showReport.value;
  get isStuff => _storage.userType.val == UserType.STUFF.toString();

  final SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: Get.context!);


  @override
  Future<void> onInit() async {
    super.onInit();
    await getDropdowns();
    await onShowReportTap();
  }


  Future<void> getDropdowns()async{
    var response2 = await DropdownAPI.get(typeId: 1);
    if(response2['status']=='OK'){
      _currencies.value = (response2['result'] as List).map((e) => DTree.fromJson(e)).toList();
    }

    var response = await DropdownAPI.get(typeId: 2);
    if(response['status']=='OK'){
      _expenseTypeList = (response['result'] as List).map((e) => DTree.fromJson(e)).toList();
    }


  }

  String getExpenseType(int index){
    return (expenseTypeList.firstWhere((element) => element.id == expenseList.elementAt(index).typeOfCost, orElse: () => DTree(id: 0))).name;
  }


  String getCurrencySymbol(int index){
    return (_currencies.firstWhere((element) => element.id == expenseList.elementAt(index).currency, orElse: () => DTree(id: 0))).name.split(" ").last;
  }


  void onSubmittedFilterTap() {
    _isSubmittedFilter.value = true;
    _showReport.value = true;
  }



  onShowReportTap() async{
    _dialog.show(message: 'Processing...', type: SimpleFontelicoProgressDialogType.phoenix);
    var response = await ExpenseAPI.rangeFilter(
        field: "user_id",
        fieldValue: _storage.userId.val,
        from: _dateRange.first,
        to:_dateRange.last
    );

    if(response['status'] == "OK"){
      _allExpense.value = (response["result"] as List).map((e) => Expense.fromJson(e)).toList();
      _expenseList.value = _allExpense.where((item) => ["DECLINED","ARCHIVED","SUBMITTED", "DRAFTED"].contains(item.status)).toList();
    }
    if(isSubmitted) _showReport.value = true;

    _dialog.hide();
  }

  void onAllTap() {
    _expenseList.value = _allExpense.where((item) => ["DECLINED","ARCHIVED","SUBMITTED", "DRAFTED"].contains(item.status)).toList();
    _filterType.value = "All";
  }
  void onPendingTap(){
    _expenseList.value = _allExpense.where((item) => ["SUBMITTED"].contains(item.status)).toList();
    _filterType.value = "Pending";
  }
  void onSavedTap() {
    _expenseList.value = _allExpense.where((item) => ["DRAFTED"].contains(item.status)).toList();
    _filterType.value = "Drafted";
  }
  void onArchivedTap(){
    _expenseList.value = _allExpense.where((item) => ["ARCHIVED"].contains(item.status)).toList();
    _filterType.value = "Archived";
  }


  void onDeclinedTap() {
    _expenseList.value = _allExpense.where((item) => ["DECLINED"].contains(item.status)).toList();
    _filterType.value = "Declined";
  }



  onFromDatePicked(String date) => _dateRange.first = date;
  onToDatePicked(String date) => _dateRange.last = date;

  removeItem(int index) async {

    _dialog.show(message: 'Processing...', type: SimpleFontelicoProgressDialogType.phoenix);
    var response = await ExpenseAPI.delete(expenseList.elementAt(index).id??"");
    if(response['status']=='OK'){
      _allExpense.removeWhere((element) => element.id == expenseList[index].id);
      expenseList.removeAt(index);
      expenseList.refresh();
    }
    else{
      debugPrint("Something happened wrong");
    }
    _dialog.hide();
  }


  onItemDeleteTap(int index){
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: true,
      dialogType: DialogType.infoReverse,
      showCloseIcon: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      title: 'Warning',
      desc:
      "Are you sure about delete the Expense",
      btnOkOnPress: () {
        removeItem(index);
      },
      btnOkColor: Colors.redAccent,
      btnCancelColor: Colors.grey.withOpacity(.5),
      btnCancelOnPress: (){},
      // btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        // clearData();
        // Get.back();
      },
    ).show();
  }


  onItemEditTap(int index) {
    Get.toNamed(Routes.EXPENSE, arguments: expenseList.elementAt(index).toJson())?.then((value) async {
      await onShowReportTap();
        onAllTap();
    });
  }
  onItemSubmitTap(int index) async {


    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: true,
      dialogType: DialogType.infoReverse,
      showCloseIcon: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      title: 'Warning',
      desc:
      "Are you sure about submitting the Expense",
      btnOkOnPress: () async {
        _dialog.show(message: 'Processing...', type: SimpleFontelicoProgressDialogType.phoenix);
        var response = await ExpenseAPI.update(expenseList.elementAt(index).id??"", data: {"status":"SUBMITTED"});
        if(response['status']=='OK'){

          // Find and update the expense
          for (var expense in _allExpense) {
            if (expense.id == expenseList[index].id) {
              expense.status = "SUBMITTED";
            }
          }
          // expenseList[index].status = "SUBMITTED";
          if(getFilterType=="All") {
            _expenseList.value = _allExpense;
          }
          else {
            _expenseList.value = _allExpense.where((item) => [getFilterType.toUpperCase()].contains(item.status)).toList();
          }
        }
        else{
          debugPrint("Something happened wrong");
        }
        _dialog.hide();
      },
      btnOkColor: Colors.green,
      // btnCancelColor: Colors.grey.withOpacity(.5),
      btnCancelOnPress: (){},
      // btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {},
    ).show();


  }

  onPreviewAttachmentTap(int index) {
    Get.dialog(
      Stack(
        children: [
          PhotoView(
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              imageProvider: NetworkImage("$mainAppBaseURL/expense/file/${expenseList[index].documentName}")),
          Positioned(
            right: 24,
              top: 50,
              child: IconButton(onPressed: Get.back, icon: Icon(Icons.close_outlined, color: Style.colors.white,))),
        ],
      ),
    );
  }



  onSubmitAllTap() async {
    // Gather drafted expense IDs
    final draftedExpenseIds = _allExpense
        .where((expense) => expense.status == 'DRAFTED')
        .map((expense) => expense.id ?? '')
        .toList();

    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: true,
      dialogType: DialogType.infoReverse,
      showCloseIcon: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      title: 'Warning',
      desc: draftedExpenseIds.isEmpty ? "There are no expense to submit" : "Are you sure about submitting all the Expenses",
      btnOkOnPress: () async {
        if(draftedExpenseIds.isNotEmpty){

          _dialog.show(message: 'Processing...', type: SimpleFontelicoProgressDialogType.phoenix);
          // Submit draft expenses
          final response = await ExpenseAPI.submitAllDraft(data: {'expense_ids': draftedExpenseIds});

          // Update expense status if successful
          if (response['status'] == 'OK') {
            _allExpense.where((expense) => expense.status == 'DRAFTED').forEach((expense) {
              expense.status = 'SUBMITTED'; // Update status in-place
            });
          }
          _dialog.hide();
          onSavedTap();
        }
      },
      btnOkColor: Colors.green,
      // btnCancelColor: Colors.grey.withOpacity(.5),
      btnCancelOnPress: () => Get.back(), // Close dialog on cancel
      // btnOkIcon: Icons.check_circle,
    ).show();
  }

}
