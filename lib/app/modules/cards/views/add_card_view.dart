import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:m_expense/app/models/card.dart' as model;
import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/modules/cards/controllers/cards_controller.dart';
import 'package:m_expense/app/modules/cards/views/cards_slide_view.dart';
import 'package:m_expense/app/utils/utils.dart';
import 'package:m_expense/app/widgets/dropdown_field.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

class AddCardView extends GetView<CardsController> {
  const AddCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    var inputDecoration = OtpPinFieldStyle(
      textStyle: Style.fonts.w400s14.copyWith(color: Style.colors.secondary),
      fieldPadding: 4,
      /// border color for inactive/unfocused Otp_Pin_Field
      defaultFieldBorderColor: Colors.transparent,

      /// border color for active/focused Otp_Pin_Field
      activeFieldBorderColor: Style.colors.secondary,
      fieldBorderWidth: 1,

      /// Background Color for inactive/unfocused Otp_Pin_Field
      defaultFieldBackgroundColor: Style.colors.offWhite,

      /// Background Color for active/focused Otp_Pin_Field
      activeFieldBackgroundColor: Style.colors.offWhite,

      /// Background Color for filled field pin box
      filledFieldBackgroundColor: Style.colors.offWhite,

      /// border Color for filled field pin box
      filledFieldBorderColor: Colors.transparent,
    );

    const iconPadding = 14.0;
    return Scaffold(
      backgroundColor: Style.colors.offWhite,
      appBar: AppBar(
        title: Text(AppText.add_card.tr,
          style: Style.fonts.w500s22.copyWith(color: AppColors().secondary),),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            width: 38,
            height: 38,
            child: ClipRRect(borderRadius: BorderRadius.circular(40),
                child: Image.network(Style.profilePhoto, height: 38,
                    width: 38,
                    fit: BoxFit.fill)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Obx(() =>
                  const CardsSlideView().cardWidget(
                      size,
                      bgImagePath: "assets/images/card_blue_bg.svg",
                      cardIcon: "assets/icons/card.svg",
                      number: controller.firstNumber + "  XXXX  XXXX  " +
                          controller.lastNumber,
                      name: controller.getCardHolderName,
                      expiryDate: controller.getCardExpiryDate
                  )),
              const SizedBox(height: 24),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Style.colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 30,
                      child: OtpPinField(
                          fieldHeight: 30,
                          fieldWidth: 18,
                          textInputAction: TextInputAction.done,
                          onSubmit: (text) {},
                          autoFocus: false,
                          onChange: (text)=>controller.onFirstPartChange(context, text),
                          /// to decorate your Otp_Pin_Field
                          otpPinFieldStyle: inputDecoration,
                          maxLength: 4,
                          showCursor: false,
                          mainAxisAlignment: MainAxisAlignment.center,
                          otpPinFieldDecoration: OtpPinFieldDecoration.custom),
                    ),
                    Text("  XXXX   XXXX   ", style: Style.fonts.w500s16.copyWith(
                        color: Style.colors.secondary),),
                    SizedBox(
                        width: 90,
                        height: 30,
                        child: OtpPinField(
                          fieldHeight: 30,
                            fieldWidth: 18,
                            textInputAction: TextInputAction.done,
                            onSubmit: (text) {},
                            autoFocus: false,
                            onChange: (text)=>controller.onLastPartChange(context, text),
                            /// to decorate your Otp_Pin_Field
                            otpPinFieldStyle: inputDecoration,
                            maxLength: 4,
                            showCursor: false,
                            mainAxisAlignment: MainAxisAlignment.center,
                            otpPinFieldDecoration: OtpPinFieldDecoration.custom),
                    ),

                  ],
                ),
              ),
              Obx(() => Visibility(
                  visible: controller.visibleNumberError,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 20, top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Please fill the card number",

                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
                    ),
                  ))),
              const SizedBox(height: 24),
              TextFormField(
                cursorColor: Colors.black,
                validator: controller.validateName,
                controller: controller.nameController,
                onSaved: controller.onNumberSave,
                inputFormatters: [Utils.uppercaseInputFormatter],
                keyboardType: TextInputType.text,
                onChanged: controller.onCardHolderNameChanged,
                decoration: InputDecoration(
                  hintText: AppText.card_holder_name.tr,
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(iconPadding),
                      child: SvgPicture.asset("assets/icons/account.svg",
                          color: Style.colors.secondary, width: 17)),
                  isDense: true,
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 18),
                  hintStyle: Style.fonts.w400s14.copyWith(
                      color: const Color(0xFFBDBDBD)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Obx(()=> DropdownInputField(
                titleColor: Style.colors.secondary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                hintText: AppText.select_a_card_type.tr,
                validator: controller.validateCardType,
                onSaved: controller.onCardTypeSave,
                items: controller.cardTypes,
                onChanged: (_) {},
              ),
              ),

              // TextFormField(
              //   cursorColor: Colors.black,
              //   validator: controller.validateExpDate,
              //   controller: controller.expiryController,
              //   onSaved: controller.onNumberSave,
              //   // Assign the onSaved callback
              //   keyboardType: TextInputType.number,
              //   inputFormatters: [Utils.cardExpiryDateFormatter],
              //   onChanged: controller.ongCardExpiryDateChanged,
              //   decoration: InputDecoration(
              //     hintText: "MM/YY",
              //     prefixIcon: Padding(
              //       padding: EdgeInsets.all(iconPadding),
              //       child: SvgPicture.asset("assets/icons/calendar.svg",
              //           color: Style.colors.secondary, width: 17),
              //     ),
              //     isDense: true,
              //     fillColor: Colors.white,
              //     filled: true,
              //     contentPadding: const EdgeInsets.symmetric(
              //         horizontal: 18, vertical: 18),
              //     hintStyle: Style.fonts.w400s14.copyWith(
              //         color: const Color(0xFFBDBDBD)),
              //     border: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.circular(5)
              //     ),
              //   ),
              // ),
              const SizedBox(height: 24),
              InkWell(
                onTap: controller.onAddNewCardTap,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.07, -1.00),
                      end: Alignment(0.07, 1),
                      colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Text(
                    AppText.add_card.tr,
                    textAlign: TextAlign.center,
                    style: Style.fonts.w500s18.copyWith(
                        color: Style.colors.white, height: null),
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
