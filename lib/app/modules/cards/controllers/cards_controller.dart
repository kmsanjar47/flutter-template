import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart' ;
import 'package:flutter/material.dart'as ui;
import 'package:get/get.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/models/DTree.dart';
import 'package:m_expense/app/models/card.dart';
import 'package:m_expense/app/modules/cards/views/add_card_view.dart';
import 'package:m_expense/app/modules/cards/views/card_view.dart';
import 'package:m_expense/app/services/card.dart';
import 'package:m_expense/app/services/dropdown.dart';
import 'package:m_expense/app/utils/storage.dart';
import 'package:m_expense/app/utils/utils.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class CardsController extends GetxController {


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  final RxString _firstNumber = "".obs;
  final RxString _lastNumber = "".obs;
  final RxString _cardType = "MasterCard".obs;
  final AppStorage _storage = AppStorage();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardController = TextEditingController();
  final TextEditingController cardTypeController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();

  final RxList<DTree> _cardTypes = <DTree>[].obs;
  final RxBool _visibleNumberError = false.obs;
  final RxInt currentIndexPage = 0.obs;
  RxList<Card> cardList = <Card>[].obs;
  Card selectedCard = Card();
  int? selectedCardType;
  final RxBool _editAble = false.obs;




  List<String> get cardTypes => Utils.toStrList(_cardTypes);

  get visibleNumberError=>_visibleNumberError.value;
  get firstNumber=> _firstNumber.value;
  get lastNumber=> _lastNumber.value;
  String get cardType=> _cardType.value;
  final RxString _cardHolderName = "".obs;
  get getCardHolderName=> _cardHolderName.value;
  final RxString _cardExpiryDate = "".obs;
  get getCardExpiryDate=> _cardExpiryDate.value;
  bool get isEditable => _editAble.value;

  final SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: Get.context!);


  @override
  void onInit() {
    super.onInit();
    getOwnCards();
    getAllDropdown();
  }

  Future<void> getAllDropdown() async {
      var response = await DropdownAPI.get(typeId: 5);
      if(response['status']=='OK'){
        _cardTypes.value = Utils.toDTList(response);
      }else{
        debugPrint("somethings happened wrong");
      }
    }


  Future<void> getOwnCards()async{
    var response = await CardAPI.ownCards(_storage.userId.val);
    if(response['status']=='OK'){
      cardList.value = (response["result"] as List).map((e) => Card.fromJson(e)).toList();
    }else{
      print("somethings happened wrong");
    }
  }

  void clearData(){
    _firstNumber.value = "";
    _lastNumber.value = "";
    _cardHolderName.value = "";
    _cardExpiryDate.value = "";
    nameController.text="";
    expiryController.text="";
  }




  void onAddNewButtonPressed() {
    clearData();
    Get.to(()=>const AddCardView())?.then((value){
      getOwnCards();
    });
  }



  void onAddNewCardTap() async {
    if (validateCardNumber() && formKey.currentState!.validate() ) {
      formKey.currentState!.save();
      Map<String,dynamic> card = Card(
        actionType: "CREATED",
        createdBy: _storage.userId.val,
        number1: _firstNumber.value,
        number2: _lastNumber.value,
        name: _cardHolderName.value,
        cardType: selectedCardType,
        // expiryMonth: _cardExpiryDate.value.split("/").first,
        // expiryYear: _cardExpiryDate.split("/").last,
        userId: _storage.userId.val,
        limit: "0.0",
      ).toJson();
      var response = await CardAPI.addCard(card);
      if(response["status"]=="OK"){
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.scale,
          headerAnimationLoop: true,
          dialogType: DialogType.success,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          title: 'Success',
          desc:
          "New card added successfully",
          btnOkOnPress: () {

          },
          btnOkIcon: ui.Icons.check_circle,
          onDismissCallback: (type) {
          },
        ).show();

        clearData();
      }
      else{
        debugPrint("Something happened wrong");
      }


    }

  }

  bool validateCardNumber() {
    if(_firstNumber.value.length < 4 || _lastNumber.value.length < 4) {
      _visibleNumberError.value = true;
    }
    else{
      _visibleNumberError.value = false;
    }
    return !_visibleNumberError.value;
  }
  String? validateName(String? p1) {
    return p1 == null || p1.isEmpty ? "Please Enter Card Holder Name" : null;
  }
  String? validateExpDate(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter card expiry date";
    } else {
      // Regular expression for validating "MM/YY" format
      RegExp expDateRegex = RegExp(r'^\d{2}/\d{2}$');

      if (!expDateRegex.hasMatch(value)) {
        return "Need valid card expiry date in the format MM/YY";
      }

      // Additional checks for month and year ranges if needed
      // You can extract and validate the month and year components separately

      String monthPart = value.substring(0, 2);
      String yearPart = value.substring(3);

      int month = int.tryParse(monthPart) ?? 0;
      int year = int.tryParse(yearPart) ?? 0;

      if (month < 1 || month > 12) {
        return "Invalid month. Please enter a month between 01 and 12";
      }

      if (year < 0 || year > 99) {
        return "Invalid year. Please enter a two-digit year";
      }
    }

    return null; // No validation errors
  }


  void onNumberSave(String? p1) {
  }

  void onCardHolderNameChanged(String value) => _cardHolderName.value = value;
  void ongCardExpiryDateChanged(String value) => _cardExpiryDate.value = value;

  onLastPartChange( BuildContext context, String? value) {
    _lastNumber.value = value??"";
    if(value!.isEmpty) {
      FocusScope.of(context).previousFocus();
    }
  }
  onFirstPartChange(BuildContext context, String? text) {
    _firstNumber.value = text??"";
    print(text);
    if(text?.length==4) {
      FocusScope.of(context).nextFocus();
    }
  }

  void onPageChange(int value) {
  currentIndexPage.value = value;
  }

  void onCardTypeSave(String? text) => selectedCardType = getDDId(text, _cardTypes);

  int getDDId(String? name, RxList<DTree> data){
    return data.firstWhere((element) => element.name == (name??""), orElse: () => DTree(id: 0)).id;
  }

  String? validateCardType(String? value) {
    if(value==null || value.isEmpty) {
      return "Please select a card type";
    } else {
      return null;
    }
  }

    // String?  selectedCardTypeName() => _cardTypes.firstWhere((element) => element.id==5028).name;

  onCardItemTap(Card card){
    selectedCard = card;
    cardController.text = "${card.number1} XXXX XXXX ${card.number2}";
    _firstNumber.value = card.number1??"";
    _lastNumber.value = card.number2??"";
    nameController.text = card.name??"";
    _cardExpiryDate.value = "DD/YY";
    // cardTypeController.text = _cardTypes.firstWhere((element) => element.id==card.cardType).name;
    cardTypeController.text = _cardTypes.firstWhere((element) => element.id==card.cardType).name;

    _cardType.value = cardTypeController.text;
    _cardHolderName.value = card.name??"";

    _editAble.value = false;
    Get.to(()=>const CardView())?.then((value){
      getOwnCards();
    });
  } 

  void onEditCardTap() => _editAble.value = true;

  void onDeleteCardTap() {

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
      "Are you sure about delete the Card",
      btnOkOnPress: () async {
        _dialog.show(message: AppText.deleting_dot_dot.tr, type: SimpleFontelicoProgressDialogType.phoenix);

        selectedCard.id;
        var response = await CardAPI.delete(selectedCard.id!);
        if(response['status'] == "OK"){
          cardList.removeWhere((element) => element.id == selectedCard.id);
          currentIndexPage.value--;
          _dialog.hide();
          Get.back();
        }else{
          _dialog.hide();
          Get.snackbar("Error!", response['message']);
        }

      },
      btnOkColor: ui.Colors.redAccent,
      btnCancelColor: ui.Colors.grey.withOpacity(.5),
      btnCancelOnPress: (){},
      // btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        // clearData();
        // Get.back();
      },
    ).show();
  }

  Future<void> onSaveExistingCardTap() async {

    if (validateCardNumber() && editFormKey.currentState!.validate() ) {
      editFormKey.currentState!.save();


      _dialog.show(message: AppText.updating_dot_dot.tr, type: SimpleFontelicoProgressDialogType.phoenix);

      Map<String,dynamic> card = Card(
        actionType: "UPDATED",
        updatedBy: _storage.userId.val,
        number1: _firstNumber.value,
        number2: _lastNumber.value,
        name: _cardHolderName.value,
        cardType: selectedCardType,
        userId: _storage.userId.val,
        limit: "0.0",
      ).toJson();

      var response = await CardAPI.update(selectedCard.id!, card);
      if(response["status"]=="OK"){
        _dialog.hide();
        AwesomeDialog(
          context: Get.context!,
          animType: AnimType.scale,
          headerAnimationLoop: true,
          dialogType: DialogType.success,
          showCloseIcon: false,
          dismissOnTouchOutside: false,
          dismissOnBackKeyPress: false,
          title: 'Success',
          desc:
          "Card Details updated successfully",
          btnOkOnPress: ()=>Get.back(),
          btnOkIcon: ui.Icons.check_circle,
          onDismissCallback: (type) {
          },
        ).show();

        clearData();
      }else{
        _dialog.hide();
        debugPrint("Something happened wrong");
      }


    }
  }
}
