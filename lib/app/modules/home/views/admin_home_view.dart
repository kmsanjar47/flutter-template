import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/modules/drawer/views/drawer_view.dart';
import 'package:m_expense/app/modules/home/controllers/admin_home_controller.dart';
import 'package:m_expense/app/widgets/app_button.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: controller.getKey,
      backgroundColor: Style.colors.offWhite,
      endDrawer: const Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: DrawerView(),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 318,
                width: size.width,
                color: Style.colors.primary,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _welcomeWidget(),],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 266.5,
              child: Container(
                height: 103,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Style.colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppText.applied_expenses.tr, style: Style.fonts.w500s22.copyWith(color: Style.colors.primary),),
                        Text("${10} ${AppText.applied_expenses.tr}", style: Style.fonts.w400s14.copyWith(color: Style.colors.secondary),)
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 55,
                      height: 55,
                      child: MaterialButton(
                        onPressed: controller.onShowApplicationPressed,
                        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
                        color: const Color(0xfff0f7fb),
                          elevation: 0,
                          child: Icon(Icons.arrow_forward,color: Style.colors.primary),

                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _welcomeWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(Style.profilePhoto,
            height: 65,width: 65, fit: BoxFit.fill,),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${AppText.hey.tr}, ${"Shorful"}", style: Style.fonts.w500s22,),
            const SizedBox(height: 5),
            Text(AppText.welcome_to_home_page.tr, style: Style.fonts.w400s16,)
          ],
        ),
        const Spacer(),
        IconButton(onPressed: controller.onMenuIconClick, icon: SvgPicture.asset("assets/icons/menu.svg",height: 20,width: 26,))

      ],
    );
  }
}
