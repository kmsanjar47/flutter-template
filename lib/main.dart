import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/Messages.dart';

import 'app/routes/app_pages.dart';
import 'app/widgets/otp_input_field.dart';

Future<void> main() async {


  await GetStorage.init();



  runApp(
    GetMaterialApp(
      theme: ThemeData(
        primaryColor: Style.colors.primary,
      ),
      debugShowCheckedModeBanner: false,
      translations: Messages(),
      locale: const Locale('en', 'UK'),
      // locale: const Locale('du', 'DU'),
      // locale: const Locale('bn', 'BD'),
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );

  // runApp(MaterialApp(
  //   home: MyWidget(),
  // ));

  
}

class MyWidget extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Input Field'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: OTPInputField(
                length: 6, // Set the length of OTP here
                controller: otpController,
              ),
            ),

            MaterialButton(onPressed: (){
              otpController.text = "123456";
            }, child: const Text("Tap me"),)
          ],
        ),
      ),
    );
  }
}
