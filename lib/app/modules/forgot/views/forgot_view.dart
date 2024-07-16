import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/widgets/app_button.dart';

import '../../../const/style.dart';
import '../../../widgets/input_field.dart';
import '../controllers/forgot_controller.dart';

class ForgotView extends GetView<ForgotController> {
  const ForgotView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.emailFormKey,
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
                          child: SvgPicture.asset("assets/images/circual_shadwo_lock.svg"),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 54),
                  child: Text(AppText.forgot_password.tr, style: Style.fonts.w600s28,),
                ),
                Text(AppText.please_enter_your_email_to_reset.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),),

                const SizedBox(height: 50),
                InputField(
                    title: AppText.email_address.tr,
                    titleColor: Style.colors.secondary,
                    hintText: 'example@gmail.com',
                    validator: controller.emailValidation,
                    fillColor: Style.colors.offWhite,
                    onSaved: controller.onEmailSave),
                const SizedBox(height: 28),

                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: AppButton(text: AppText.send_otp.tr, onPressed: controller.onSendOtpPressed,))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
