import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/models/DTree.dart';
import 'package:m_expense/app/models/expense.dart';
import 'package:m_expense/app/models/card.dart' as model;
import 'package:m_expense/app/modules/expense/views/expense_payment_view.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/services/card.dart' as api;
import 'package:m_expense/app/services/dropdown.dart';
import 'package:m_expense/app/services/expense.dart';
import 'package:m_expense/app/utils/storage.dart';
import 'package:m_expense/app/utils/utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ExpenseController extends GetxController {

  final GlobalKey<FormState> firstFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> secondFormKey = GlobalKey<FormState>();
  TextEditingController documentController = TextEditingController();
  TextEditingController expenseDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  TextEditingController addressController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController cardController = TextEditingController();
  TextEditingController vendorController = TextEditingController();
  TextEditingController billController = TextEditingController();
  TextEditingController vatController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final AppStorage _storage = AppStorage();
  final RxBool _isNewForm = true.obs;
  File? _document;
  final RxString _paymentType = "CARD".obs;
  final RxBool _showDocument = false.obs;
  Expense _expense = Expense();
  final RxList<Expense> _referenceList = <Expense>[].obs;
  final RxList<DTree> _companies = <DTree>[].obs;
  final RxList<DTree> _costTypes = <DTree>[].obs;
  final RxList<DTree> _currencies = <DTree>[].obs;
  RxList<model.Card> cardList = <model.Card>[].obs;

  final RxString _company = "".obs;
  final RxString _costType = "".obs;
  final RxString _currency = "".obs;

  List<Expense> get referenceList => _referenceList.value;
  get isShowDocument => _showDocument.value;
  get isCash => _paymentType.value == "CASH";

  List<String> get companies => Utils.toStrList(_companies);
  List<String> get costTypes => Utils.toStrList(_costTypes);
  List<String> get currencies => Utils.toStrList(_currencies);


  String? get getCompany => _company.value.isEmpty?null:_company.value;
  String? get typeOfCost => _costType.value.isEmpty?null:_costType.value;
  String? get currency => _currency.value.isEmpty?null:_currency.value;


  SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: Get.context!);

  setPaymentType(String value) {
    if(value == "CASH"){
      _expense.card == null;
      cardController.text="";
    }
    _paymentType.value = value;
  }


  @override
  void onInit() async {
    super.onInit();
    await getAllDropdown();
    await getDeclinedExp();
    await getOwnCards();
    populateForEdit(Get.arguments);
  }

  Future<void> getOwnCards()async{
    var response = await api.CardAPI.ownCards(_storage.userId.val);
    if(response['status']=='OK'){
      cardList.value = (response["result"] as List).map((e) => model.Card.fromJson(e)).toList();
    }else{
      debugPrint("somethings happened wrong");
    }
  }

  Future<void>  getDeclinedExp() async {
    var response = await ExpenseAPI.rangeFilter(
      field: "status",
      fieldValue: "DECLINED",
      from: DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(const Duration(days: 31))),
      to: DateFormat("yyyy-MM-dd").format(DateTime.now()),
    );
    if(response['status']=='OK'){
      _referenceList.value = (response["result"] as List).map((e) => Expense.fromJson(e)).toList();
    }
    else{
      debugPrint("somethings happened wrong");
    }
  }
  String getExpenseType(int index){
    return (_costTypes.firstWhere((element) => element.id == referenceList.elementAt(index).typeOfCost, orElse: () => DTree(id: 0))).name;
  }
  String getCurrencySymbol(int index){
    return (_currencies.firstWhere((element) => element.id == referenceList.elementAt(index).currency, orElse: () => DTree(id: 0))).name.split(" ").last;
  }
  void onNextTap() {
    if(firstFormKey.currentState!.validate()){
      firstFormKey.currentState!.save();
      Get.to(() => const ExpensePaymentView());
    }
  }

  Future<void> getAllDropdown() async {

    for (var element in [4, 2, 1]) {
      var response = await DropdownAPI.get(typeId: element);
      if(response['status']=='OK'){
        switch(element){
          case 4:
            _companies.value = Utils.toDTList(response);
            break;
          case 2:
            _costTypes.value = Utils.toDTList(response);
            break;
          case 1:
            _currencies.value = Utils.toDTList(response);
            break;
        }
      }else{
        debugPrint("somethings happened wrong");
      }
    }
  }



  int getDDId(String? name, RxList<DTree> data){
    return data.firstWhere((element) => element.name == (name??""), orElse: () => DTree(id: 0)).id;
  }

  void onOrganizationSave(String? p1) {}

  String? validateOrganization(String? p1) {
    return null;
  }



  void onPressedCapture() {
    _pickImage(ImageSource.camera);
  }

  void onPressedGallery() {
    _pickImage(ImageSource.gallery);
  }

  _pickImage(ImageSource imageSource) async {
    final XFile? xFile = await _picker.pickImage(source: imageSource);
    if (xFile != null) {
      String fullName = xFile.name;
      String name = fullName.split('.').first;
      String extension = fullName.split('.').last;

      if (fullName.length > 30) {
        // If the file name is longer than 30 characters, modify it
        String firstPart = name.substring(0, 10);
        String lastPart = name.substring(name.length - 10);

        fullName = '$firstPart ... $lastPart.$extension';
      }
      documentController.text = fullName;
      _document = File(xFile.path);
      _showDocument.value = true;
    }

    Get.back();
  }



  Future<void> onExpenseDatePressed(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year-1, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(DateTime.now().year + 2),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    onPrimary: Colors.white, // selected text color
                    onSurface: Colors.white, // default text color
                    primary: Style.colors.primary // circle color
                ),
                textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        fontFamily: 'Quicksand'),
                    foregroundColor: Colors.white, // color of button's letters
                    backgroundColor: Style.colors.primary, // Background color
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Colors.transparent,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50))))),
            child: child!,
          );
        });
    if(selectedDate!=null){
      expenseDateController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
    }
  }


  String? validateDocument(String? text) => validate(text, "Please upload document");
  String? validateExpenseDate(String? text) => validate(text, "Please enter expiry date");
  String? validateAddress(String? text) =>  null; //validate(text, "Please enter address");
  String? validateCostType(String? text) =>  validate(text, "Please chose type of cost");
  String? validateVendor(String? text) =>  validate(text, "Please enter the vendor");
  String? validateTotalBill(String? text) =>  validate(text, "Please enter total bill");
  String? validateCurrency(String? text) => validate(text, "Please chose your currency");
  String? validateCompany(String? text) => validate(text, "Please chose your company");
  String? validate(String? text, String message) => text==null || text.isEmpty ? message : null;
  String? validateCardField(String? text) {
    if(isCash) {
      return null;
    }
    if(!isCash && text==null || text!.isEmpty) {
      return "Please select used card";
    }
    return null;
  }
  void onExpenseDateSave(String? text) => _expense.expenseDate = DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(text!));
  void onAddressSave(String? text) => _expense.address = text??"";
  void onTotalBillSave(String? text) => _expense.totalBill = double.parse(text!=null ? text.contains(",") ? text.removeAllWhitespace.replaceAll(",", ".")  : "$text.0" : "0.0").toString();
  void onSaveCurrency(String? text) => _expense.currency = getDDId(text, _currencies);
  void onTypeOfCostSave(String? text) => _expense.typeOfCost = getDDId(text, _costTypes);
  void onCompanySave(String? text) => _expense.company = getDDId(text, _companies);
  void onVendorSave(String? text) => _expense.vendor = text??"";
  void onDescriptionSaved(String? text) => _expense.description = text??"";
  void onVatSaved(String? text) => _expense.totalVat = double.parse(text!=null ? text.contains(",") ? text.removeAllWhitespace.replaceAll(",", ".") : "$text.0" : "0.0").toString();
  void clearData(){
    _paymentType.value = "CARD";
    documentController.text = "";
    expenseDateController.text = "";
    addressController.text = "";
    vendorController.text = "";
    _document=null;
    billController.text = "";
    descriptionController.text = "";
    expenseDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }



  void showDocument() {
    Get.dialog(
      Stack(
        children: [
          PhotoView(
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent
            ),
              imageProvider: FileImage(_document!)),
          Positioned(
              right: 24,
              top: 50,
              child: IconButton(onPressed: Get.back, icon: Icon(Icons.close_outlined, color: Style.colors.white,))),
        ],
      ),
    );
  }


  void onSaveTap() {
    if(_isNewForm.value) {
      postExpense("DRAFTED");
    } else {
      putExpense("DRAFTED");
    }
  }

  void onSubmitTap() async {
    if (_isNewForm.value) {
      postExpense("SUBMITTED");
    } else {
      putExpense("SUBMITTED");
    }
  }

  postExpense(String status)async{

    if(secondFormKey.currentState!.validate()){

      _dialog.show(message: 'Processing...', type: SimpleFontelicoProgressDialogType.phoenix);
      _expense.paymentMethod = _paymentType.value;
      _expense.userId = _storage.userId.val;
      _expense.userName = _storage.userName.val;
      _expense.status = status;
      _expense.actionType = "CREATED";
      _expense.createdBy = _storage.userId.val;

      secondFormKey.currentState!.save();
      var response = await ExpenseAPI.create(_expense.toJson(), _document!);
      if (response['status'] == "OK") {
        _dialog.hide();
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          title: 'Succes',
          desc:
          "Yor Expense ${status=="SUBMITTED"?"Submitted":"Saved"} Successfully",
          btnOkOnPress: () {
            clearData();
            Get.back();
            Get.back();
            Get.toNamed(Routes.EXPENSE_REPORT);
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            // clearData();
            // Get.back();
          },
        ).show();
      }
      else {
        Get.snackbar("Error!", response['result'].toString());
        _dialog.hide();
      }
    }
  }
  putExpense(String status)async{
    _expense.paymentMethod = _paymentType.value;
    _expense.status = status;
    _expense.actionType = "UPDATED";
    _expense.updatedBy = _storage.userId.val;

    if(secondFormKey.currentState!.validate()){
      secondFormKey.currentState!.save();
      var response = await ExpenseAPI.update(_expense.id??"", data: _expense.toJson(), document: _document);
      if (response['status'] == "OK") {
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          title: 'Succes',
          desc:
          "Yor Expense ${status=="SUBMITTED"?"Submitted":"Saved"} Successfully",
          btnOkOnPress: () {
            clearData();
            Get.back();
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            // clearData();
            // Get.back();
          },
        ).show();
      }
      else {
      }
    }
  }

  onReferenceItemClick(int index) {
    _expense.referenceId = referenceList.elementAt(index).id;
    referenceController.text = "${getExpenseType(index)}: ${getCurrencySymbol(index)} ${referenceList.elementAt(index).totalBill??"0.0"}";
    Get.back();
  }

  onCardItemTap(int index) {
    _expense.card = cardList.elementAt(index).id??"";
    cardController.text = "${cardList.elementAt(index).number1??""} XXXX XXXX ${cardList.elementAt(index).number2??""}";
    Get.back();
  }

  void populateForEdit(arguments) {
    if(arguments!=null){
      _isNewForm.value = false;
      _expense = Expense.fromJson(arguments);
      if(_expense.referenceId!=null) {
        var reference = referenceList.firstWhere((element) =>
        element.id == _expense.referenceId);
        String costType = _costTypes
            .firstWhere((element) => element.id == _expense.typeOfCost)
            .name;
        String currency = _currencies
            .firstWhere((element) => element.id == _expense.currency)
            .name
            .split(" ")
            .last;
        referenceController.text = "$costType: $currency ${_expense.totalBill??""}";
      }
      documentController.text = Utils.shortFileName(_expense.documentName??"");
      expenseDateController.text = DateFormat("dd/MM/yyyy").format(DateFormat("yyyy-MM-dd").parse(_expense.expenseDate!));
      addressController.text = _expense.address??"";
      _company.value = _companies.firstWhere((element) => element.id == _expense.company).name;
      vendorController.text = _expense.vendor??"";
      _paymentType.value = _expense.paymentMethod??"CARD";
      if(_paymentType.value == "CARD"){
        model.Card card = cardList.firstWhere((element) => element.id == _expense.card);
        cardController.text = "${card.number1} XXXX XXXX ${card.number2}";
      }
      _costType.value = _costTypes.firstWhere((element) => element.id==_expense.typeOfCost).name;
      _currency.value = _currencies.firstWhere((element) => element.id==_expense.currency).name;
      vatController.text = _expense.totalVat??"0.0";
      billController.text = _expense.totalBill??"0.0";
      descriptionController.text = _expense.description??"";
    }
  }









}
