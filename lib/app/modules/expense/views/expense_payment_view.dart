import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/modules/expense/controllers/expense_controller.dart';
import 'package:m_expense/app/modules/expense/views/expense_view.dart';
import 'package:m_expense/app/widgets/dropdown_field.dart';
import 'package:m_expense/app/widgets/input_field.dart';

import '../../../utils/utils.dart';

class ExpensePaymentView extends GetView<ExpenseController> {
  const ExpensePaymentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Style.colors.offWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Style.colors.primary,
        title: Text(AppText.submit_expense.tr, style: Style.fonts.w500s22.copyWith(color: AppColors().white),),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24),
            width: 38,
            height: 38,
            child: ClipRRect(borderRadius: BorderRadius.circular(40),
                child: Image.network(Style.profilePhoto,height: 38,width: 38, fit: BoxFit.fill)),
          )
        ],
        elevation: 0,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: Style.colors.primary),
        child: Stack(
          children: [
            Align(alignment: Alignment.topCenter, child: Container(height: 200,width: size.width, color: Style.colors.primary,)),

            Container(
              width: size.width,
              height: size.height,
              decoration: ShapeDecoration(
                color: Style.colors.offWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Form(
                  key: controller.secondFormKey,
                  child: Column(
                    children: [

                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 16,bottom: 8),
                        child: Text(AppText.select_payment_method.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),),
                      ),


                      Obx(()=> Row(
                          children: [
                            _checkBox(size, isActive: controller.isCash, title: AppText.cash.tr, onTap: ()=>controller.setPaymentType("CASH")),
                            const Spacer(),
                            _checkBox(size, isActive: !controller.isCash, title: AppText.card.tr, onTap: ()=>controller.setPaymentType("CARD")),
                          ],
                        ),
                      ),
                      Obx(() => Visibility(
                          visible: !controller.isCash,
                          child: InputField(
                              readOnly: true,
                              controller: controller.cardController,
                              contentPadding: const EdgeInsets.only(left: 18, top: 11, bottom: 11),
                              // title: AppText.reference.tr,
                              validator: controller.validateCardField,
                              titleColor: Style.colors.secondary,
                              hintText: AppText.select_used_card.tr,
                              fillColor: Style.colors.white,
                              suffixIcon: IconButton(
                                icon: SvgPicture.asset(
                                    "assets/icons/arrow_down.svg"),
                                onPressed: onCardFieldTap,
                              )))),
                      Obx(()=> DropdownInputField(
                          titleColor: Style.colors.secondary,
                          title: AppText.type_of_cost.tr,
                          hintText: AppText.please_select_a_category.tr,
                          validator: controller.validateCostType,
                          onSaved: controller.onTypeOfCostSave,
                          value: controller.typeOfCost,
                          items: controller.costTypes,
                          onChanged: (value) {
                            // Handle the selected value
                          },
                        ),
                      ),
                      Obx(()=> DropdownInputField(
                          titleColor: Style.colors.secondary,
                          title: AppText.currency.tr,
                          hintText: AppText.select_currency.tr,
                          validator: controller.validateCurrency,
                          onSaved: controller.onSaveCurrency,
                          items: controller.currencies,
                          value: controller.currency,
                          onChanged: (value) {
                            // Handle the selected value
                          },
                        ),
                      ),
                      InputField(
                          contentPadding: const EdgeInsets.only(left: 18,top: 13,bottom: 15),
                          title: AppText.vat_amount_nl.tr,
                          controller: controller.vatController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                            DecimalTextInputFormatter(),],
                          hintText: "0.0",
                          titleColor: Style.colors.secondary,
                          fillColor: Style.colors.white,
                          onSaved: controller.onVatSaved),

                      InputField(
                          contentPadding: const EdgeInsets.only(left: 18,top: 13,bottom: 15),
                          title: AppText.total_bill.tr,
                          controller: controller.billController,
                          hintText: "0.0",
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                            DecimalTextInputFormatter()],
                          titleColor: Style.colors.secondary,
                          validator: controller.validateTotalBill,
                          fillColor: Style.colors.white,
                          onSaved: controller.onTotalBillSave),

                      // InputField(
                      //     contentPadding: const EdgeInsets.only(left: 18,top: 13,bottom: 15),
                      //     title: AppText.description.tr,
                      //     controller: controller.descriptionController,
                      //     hintText: AppText.description.tr,
                      //     titleColor: Style.colors.secondary,
                      //     fillColor: Style.colors.white,
                      //     onSaved: controller.onDescriptionSaved),
                      const SizedBox(height: 24),

                      Row(children: [
                        InkWell(
                          onTap: controller.onSaveTap,
                          child: Container(
                            width: size.width*.26,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(-0.07, -1.00),
                                end: Alignment(0.07, 1),
                                colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            child:  Text(
                              AppText.save.tr,
                              textAlign: TextAlign.center,
                              style: Style.fonts.w500s18.copyWith(color: Style.colors.white, height: null),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: controller.onSubmitTap,
                          child: Container(
                            width: size.width*.58,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(-0.07, -1.00),
                                end: Alignment(0.07, 1),
                                colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            child:  Text(
                              AppText.submit.tr,
                              textAlign: TextAlign.center,
                              style: Style.fonts.w500s18.copyWith(color: Style.colors.white, height: null),
                            ),
                          ),
                        ),

                      ],),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _checkBox(Size size, {bool isActive = false, String title = "", GestureTapCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: size.width*.5-34,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Style.colors.white),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height:12,
              width: 12,
              decoration: BoxDecoration(
                color: isActive ? Colors.green:null,
                  border:isActive ? null : Border.all(color: Style.colors.secondary, width: 1.5),
                  borderRadius: BorderRadius.circular(12)
              ),
            ),
            const SizedBox(width: 8),
            Text(title,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary))
          ],
        ),
      ),
    );
  }

  void onCardFieldTap() {
    Get.dialog(const ExpenseView().dialog(_cardList(),
      padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 120),
      icon: Icons.keyboard_arrow_up_rounded,
      title: "Select Card"
    ));
  }

  Widget _cardList()=>ListView.builder(
    itemCount: controller.cardList.length,
      itemBuilder: (_,index)=>_cardItem(index));

  _cardItem(int index) {
    return InkWell(
      onTap: ()=>controller.onCardItemTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(.2), width: 1))),
        child: Text("${controller.cardList.elementAt(index).number1??""} XXXX XXXX ${controller.cardList.elementAt(index).number2??""}", style: Style.fonts.w400s14.copyWith(color: Style.colors.secondary),),
      ),
    );
  }
}
