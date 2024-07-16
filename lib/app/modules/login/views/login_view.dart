import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/routes/app_pages.dart';
import 'package:m_expense/app/widgets/input_field.dart';

import '../../../widgets/app_button.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LogInController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return KeyboardDismisser(
      gestures: [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        backgroundColor: Style.colors.offWhite,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    height: size.height * .35,
                    width: size.width,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 10, end: 80),
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 800),
                      builder: (BuildContext context, double value,
                          Widget? child) {
                        return SvgPicture.asset(
                          "assets/images/logo_x.svg",
                          height: value,
                          width: value * 3,
                        );
                      },
                      // child: SvgPicture.asset("assets/images/long_logo.svg", height: 38,width: 239,)),
                    ),
                  ),
                  SizedBox(
                    height: size.height,
                    width: size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: size.height, end: size.height * .35),
                            curve: Curves.easeOutCubic,
                            duration: const Duration(milliseconds: 800),
                            builder: (BuildContext context, double value, Widget? child) {
                              return SizedBox(height: value);
                            },
                            // child: SvgPicture.asset("assets/images/long_logo.svg", height: 38,width: 239,)),
                          ),
                          Container(
                            height: size.height * .65,
                            width: size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 38),
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-0.05, -1.00),
                                end: Alignment(0.05, 1),
                                colors: [
                                  Color(0xFF85A5F9),
                                  Color(0xFF1AADE9)
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    Text(
                                      AppText.welcome.tr,
                                      style: Style.fonts.w700s32,
                                    ),
                                    const SizedBox(height: 11),
                                    Text(
                                      AppText.please_login__with_your_credentials.tr,
                                      style: Style.fonts.w400s14,
                                    ),
                                    const SizedBox(height: 50),
                                    InputField(
                                        title: AppText.user_name.tr,
                                        hintText: 'example@gmail.com',
                                        validator: controller.emailValidation,
                                        onSaved: controller.onEmailSave),
                                    const SizedBox(height: 10),
                                    Obx(()=> InputField(
                                        suffixIcon: IconButton(
                                          onPressed: ()=>controller.obscure.value=!controller.obscure.value,
                                            icon: SvgPicture.asset(controller.obscure.value?"assets/icons/eye_slim.svg":"assets/icons/eye_hidden.svg")),
                                          title: AppText.password.tr,
                                          hintText: '********',
                                          obscureText: controller.obscure.value,
                                          validator: controller.emailValidation,
                                          onSaved: controller.onPasswordSave),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 22),
                                      child: Row(
                                        children: [

                                          Text(
                                            AppText.remember_me.tr,
                                            style: Style.fonts.w400s16,
                                          ),
                                          Obx(
                                                ()=> Checkbox(
                                                value: controller.remember.value,
                                                side: const BorderSide(
                                                    color: Colors.white),
                                                checkColor:
                                                Style.colors.primary,
                                                onChanged: controller
                                                    .onRememberMeClick),
                                          ),
                                          const Spacer(),
                                          TextButton(onPressed:()=> Get.toNamed(Routes.FORGOT), child: Text(
                                            AppText.forgot_password.tr,
                                            style: Style.fonts.w500s14,
                                          ),)
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: 50,
                                        width: double.infinity,
                                        child: AppButton(
                                          buttonColor: Style.colors.white,
                                          onPressed: controller.onLoginClick,
                                          text: AppText.log_in.tr,
                                          textColor: Style.colors.primary,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
