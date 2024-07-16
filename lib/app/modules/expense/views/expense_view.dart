import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/models/expense.dart';
import 'package:m_expense/app/utils/utils.dart';
import 'package:m_expense/app/widgets/app_button.dart';
import 'package:m_expense/app/widgets/dropdown_field.dart';
import 'package:m_expense/app/widgets/input_field.dart';

import '../controllers/expense_controller.dart';

class ExpenseView extends GetView<ExpenseController> {
  const ExpenseView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
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
        body: Stack(
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
                  key: controller.firstFormKey,
                  child: Column(
                    children: [

                      InputField(
                          readOnly: true,
                          controller: controller.referenceController,
                          contentPadding: const EdgeInsets.only(left: 18,top: 11,bottom: 11),
                          title: AppText.reference.tr,
                          titleColor: Style.colors.secondary,
                          hintText: AppText.select_reference_expense.tr,
                          fillColor: Style.colors.white,
                          suffixIcon: IconButton(icon: SvgPicture.asset("assets/icons/arrow_down.svg"),onPressed: onReferenceFieldTap,)
                      ),

                      // Obs added for button change
                      Obx(()=> InputField(
                          readOnly: true,
                            contentPadding: const EdgeInsets.only(left: 18,top: 11,bottom: 11),
                            title: AppText.capture_or_upload_document.tr,
                            titleColor: Style.colors.secondary,
                            hintText: AppText.take_photo.tr,
                            validator: controller.validateDocument,
                            fillColor: Style.colors.white,
                            controller: controller.documentController,
                            // height: 60,
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if(controller.isShowDocument)
                                IconButton(icon: SvgPicture.asset("assets/icons/eye_slim.svg", width: 18,),onPressed:controller.showDocument,),
                                IconButton(icon: SvgPicture.asset("assets/icons/camera.svg"),onPressed:()=> Get.bottomSheet(_bottomSheet()),),
                              ],
                            ),
                            onSaved: controller.onOrganizationSave),
                      ),

                      InputField(
                          contentPadding: const EdgeInsets.only(left: 18,top: 13,bottom: 15),
                          title: AppText.description.tr,
                          controller: controller.descriptionController,
                          hintText: AppText.description.tr,
                          titleColor: Style.colors.secondary,
                          fillColor: Style.colors.white,
                          onSaved: controller.onDescriptionSaved),

                      InputField(
                        readOnly: true,
                          contentPadding: const EdgeInsets.only(left: 18,top: 11,bottom: 11),
                          title: AppText.expense_date.tr,
                          titleColor: Style.colors.secondary,
                          hintText: "dd/mm/yyyy",
                          validator: controller.validateExpenseDate,
                          fillColor: Style.colors.white,
                          controller: controller.expenseDateController,
                          suffixIcon: IconButton(icon: SvgPicture.asset("assets/icons/calendar.svg"),onPressed:()=> controller.onExpenseDatePressed(context),),
                          onSaved: controller.onExpenseDateSave),

                      InputField(
                        readOnly: false,
                          controller: controller.addressController,
                          contentPadding: const EdgeInsets.only(left: 18,top: 11,bottom: 11),
                          title: AppText.address.tr,
                          titleColor: Style.colors.secondary,
                          hintText: "Enter address",
                          validator: controller.validateAddress,
                          fillColor: Style.colors.white,
                          suffixIcon: IconButton(icon: SvgPicture.asset("assets/icons/location_picker.svg"),onPressed: (){},),
                          onSaved: controller.onAddressSave),

                      Obx(()=> DropdownInputField(
                          titleColor: Style.colors.secondary,
                          title: AppText.company.tr,
                          hintText: AppText.please_select_a_company.tr,
                          validator: controller.validateCompany,
                          onSaved: controller.onCompanySave,
                          items: controller.companies,
                          value: controller.getCompany,
                          onChanged: (value) {
                            // Handle the selected value
                          },
                        ),
                      ),
                      InputField(
                          title: AppText.customer_or_vendor.tr,
                          controller: controller.vendorController,
                          contentPadding: const EdgeInsets.only(left: 18,top: 14,bottom: 14),
                          titleColor: Style.colors.secondary,
                          hintText: AppText.vendor.tr,
                          validator: controller.validateVendor,
                          fillColor: Style.colors.white,
                          onSaved: controller.onVendorSave),

                      const SizedBox(height: 24),

                      InkWell(
                        onTap: controller.onNextTap,
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child:  Text(
                            AppText.next.tr,
                            textAlign: TextAlign.center,
                            style: Style.fonts.w500s18.copyWith(color: Style.colors.white, height: null),
                          ),
                        ),
                      ),
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

  Widget _bottomSheet() {
    return SizedBox(
      height: 272,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                MaterialButton(
                  elevation: 0,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onPressed: controller.onPressedGallery,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Chose from gallery",
                      style: Style.fonts.w500s16.copyWith(color: Style.colors.secondary),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                MaterialButton(
                  elevation: 0,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onPressed: controller.onPressedCapture,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Capture by camera",
                      style: Style.fonts.w500s16.copyWith(color: Style.colors.secondary),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: MaterialButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () => Get.back(),
                child: Text(
                  "Cancel",
                  style: Style.fonts.w400s16
                      .copyWith(color: Colors.red),
                )),
          ),
        ],
      ),
    );
  }

  void onReferenceFieldTap() {
    Get.dialog(
        dialog(_reportList(controller.referenceList))
    );
  }

  Widget dialog(Widget child,{String? title, IconData? icon, EdgeInsets? padding}){
    return Padding(
      padding: padding??const EdgeInsets.symmetric(horizontal: 34.0, vertical: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Scaffold(
          backgroundColor: Style.colors.offWhite,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Style.colors.primary,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(onPressed: Get.back, icon: Icon(icon??Icons.close, color: Colors.white,)),
              )
            ],
            title: Text(title??"Select a reference expense", style: Style.fonts.w500s16.copyWith(color: Style.colors.white),),
          ),
          body: child
        ),
      ),
    );
  }

  Widget _reportList(List<Expense> data) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: controller.referenceList.length,
        itemBuilder: (_, index) => InkWell(
            onTap: () => controller.onReferenceItemClick(index),
            child: Container(
                decoration: BoxDecoration(
                    color: Style.colors.white,
                    borderRadius: BorderRadius.circular(5)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(controller.getExpenseType(index),
                            style: Style.fonts.w500s18
                                .copyWith(color: AppColors().secondary)),
                      ],
                    ),
                    // _textRow(title: AppText.employee_name.tr, value: "Abdullah Al Mamun"),
                    _textRow(
                        title: AppText.vendor.tr,
                        value: data[index].vendor ?? ""),
                    _textRow(
                        title: AppText.total_bill.tr,
                        value: data[index].totalBill ?? ""),
                    _textRow(
                        title: AppText.attachment.tr,
                        value:
                            Utils.shortFileName(data[index].documentName ?? ""),
                        attachment: true,
                        onPressed: () {
                          print("object");
                        }),
                  ],
                ))));
  }

  Widget _textRow({
    String title = "",
    String value = "",
    bool attachment = false,
    String? currency = "\$",
    VoidCallback? onPressed

  }){
    return Row(
      children: [
        Expanded(flex: 2,
            child: Text(title, style: Style.fonts.w400s12)),
        Text(":   ", style: Style.fonts.w400s12),
        Expanded(
            flex: 3,
            child: attachment ?
            InkWell(
                onTap: onPressed,

                child: Text(value, style: Style.fonts.w300s12.copyWith(color: Style.colors.primary)))
                : Text(value, style: Style.fonts.w300s12))
      ],
    );
  }

}
