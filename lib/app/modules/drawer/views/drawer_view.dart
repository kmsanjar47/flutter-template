import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/utils/storage.dart';

import '../controllers/drawer_controller.dart';

class DrawerView extends GetView<AppDrawerController> {
  const DrawerView({Key? key}) : super(key: key);
  @override
  // TODO: implement controller
  AppDrawerController get controller => Get.put(AppDrawerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(Style.profilePhoto,
                height: 35,width: 35, fit: BoxFit.fill,),
            ),
            const SizedBox(width: 12),
            Text(AppStorage().userProfileName.val, style: Style.fonts.w500s18.copyWith(color: Style.colors.secondary),),
            const Spacer(),
            IconButton(onPressed: controller.onCloseClick,
                icon:Icon(Icons.close, color: Style.colors.secondary,)
                // icon: SvgPicture.asset("assets/icons/menu.svg", color: Style.colors.secondary, height: 20,width: 26,)
            )

          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: controller.onChangeLanguageTap,
            child: Container(
                color: Style.colors.offWhite,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: controller.onLogOutClick, icon: SvgPicture.asset("assets/icons/translate.svg", height: 20,width: 26,)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(AppText.switch_to_dutch.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),)),
                  ],
                )
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Style.colors.secondary,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(AppStorage().userProfileName.val, style: Style.fonts.w500s18.copyWith(color: Style.colors.white),),
            const Spacer(),
            IconButton(onPressed: controller.onLogOutClick, icon: SvgPicture.asset("assets/icons/logout_squre.svg", color: Style.colors.white, height: 20,width: 26,))
          ],
        )
      ),
    );
  }


}
