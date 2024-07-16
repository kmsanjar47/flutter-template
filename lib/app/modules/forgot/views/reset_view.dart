import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/widgets/app_button.dart';
import 'package:m_expense/app/widgets/input_field.dart';

import '../controllers/forgot_controller.dart';

class ResetView extends GetView<ForgotController> {
  const ResetView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.passwordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                height: 264,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.05,
                        child: Container(
                          width: 264,
                          height: 264,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              gradient: const LinearGradient(
                                begin: Alignment(-0.07, -1.00),
                                end: Alignment(0.07, 1),
                                colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                              )),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.05,
                        child: Container(
                          width: 202.91,
                          height: 202.91,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(300),
                              gradient: const LinearGradient(
                                begin: Alignment(-0.07, -1.00),
                                end: Alignment(0.07, 1),
                                colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                              )),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox( height: 127, width: 106,
                        child: SvgPicture.asset("assets/images/lock_secret.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 35),
                child: Text(AppText.reset_password.tr, style: Style.fonts.w600s28,),
              ),
              Text(AppText.please_enter_your_new_pass.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),),

              const SizedBox(height: 15),
              Obx(
                  ()=> InputField(

                    suffixIcon: IconButton(
                        onPressed: ()=>controller.newObscure.value=!controller.newObscure.value,
                        icon: SvgPicture.asset(controller.newObscure.value?"assets/icons/eye_slim.svg":"assets/icons/eye_hidden.svg")),
                    title: AppText.new_password.tr,
                    titleColor: Style.colors.secondary,
                    obscureText: controller.newObscure.value,
                    validator: controller.validateNewPass,
                    fillColor: Style.colors.offWhite),
              ),
              Obx(
                    ()=>  InputField(
                    suffixIcon: IconButton(
                        onPressed: ()=>controller.confirmedObscure.value=!controller.confirmedObscure.value,
                        icon: SvgPicture.asset(controller.confirmedObscure.value?"assets/icons/eye_slim.svg":"assets/icons/eye_hidden.svg")),
                    title: AppText.confirm_password.tr,
                    titleColor: Style.colors.secondary,
                    obscureText: controller.confirmedObscure.value,
                    validator: controller.validateRePass,
                    fillColor: Style.colors.offWhite,
                    onSaved: controller.onPasswordSave),
              ),
              const SizedBox(height: 28),

              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AppButton(text: AppText.change_password.tr, onPressed: controller.onChangePasswordPressed,))

            ],
          ),
        ),
      ),
    );
  }
}

