import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/modules/forgot/controllers/forgot_controller.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../const/style.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/input_field.dart';

class OtpView extends GetView<ForgotController> {
  const OtpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return KeyboardDismisser(
      gestures: const [GestureType.onTap, GestureType.onPanUpdateDownDirection],
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                padding: const EdgeInsets.only(bottom: 10.0, top: 54),
                child: Text(AppText.verify_otp.tr, style: Style.fonts.w600s28,),
              ),
              Text(AppText.please_enter_code.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),),
              const SizedBox(height: 50),
              Container(
                height: size.width/4-25,
                child: PinFieldAutoFill(
                  controller: controller.otpController,
                  decoration: BoxLooseDecoration(strokeColorBuilder: const FixedColorBuilder(Color(0xFFD5DADE)),bgColorBuilder: FixedColorBuilder(Colors.white)),
                  // decoration: // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/controller.pin_input_text_field for more info,
                  currentCode: controller.otp,//code submitted callback
                  onCodeChanged: controller.onCodeChange,//code changed callback
                  codeLength:  4,
                ),
               ),
              const SizedBox(height: 28),

              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AppButton(text: AppText.verify.tr, onPressed: controller.onVerifyOtpPressed,))

            ],
          ),
        ),
      ),
    );
  }
}
