import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/modules/drawer/views/drawer_view.dart';
import 'package:m_expense/app/utils/storage.dart';
import 'package:m_expense/app/widgets/app_button.dart';

import '../controllers/home_controller.dart';

// NOTE: this is really important, it will make overscroll look the same on both platforms
class _ClampingScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();
}

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

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
      body: RefreshIndicator(
        color: Style.colors.primary,
        onRefresh: controller.onRefresh,
        child: SizedBox(
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
                    child: ScrollConfiguration(
                      behavior: _ClampingScrollBehavior(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _welcomeWidget(size),
                            _dateSlider(),
                            _counterItems(size),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 24),
                                width: double.infinity,
                                height: 60,
                                child: AppButton(
                                  onPressed: controller.onSubmitExpense,
                                  text: AppText.submit_expense.tr,
                                )),
                            TextButton(
                              onPressed: controller.onViewExpensePressed,
                              child: Text(
                                AppText.view_expense.tr,
                                style: Style.fonts.w400s16
                                    .copyWith(color: Style.colors.secondary),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.onCardsPressed,
                              child: Text(
                                AppText.cards.tr,
                                style: Style.fonts.w400s16
                                    .copyWith(color: Style.colors.secondary),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _welcomeWidget(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: SvgPicture.asset(
            "assets/images/logo_white.svg",
            height: 65,
            width: 65,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: size.width * .53,
                      height: 35,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${AppText.hey.tr}, ${AppStorage().userProfileName.val}",
                          style: Style.fonts.w500s22,
                        ),
                      )),
                  const Spacer(),
                  // Container(
                  //   height: 24,
                  //   decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(12)
                  //   ),
                  //   width: 45,
                  //   child: DropdownButtonFormField<String>(
                  //     isExpanded: false,
                  //     value: controller.selectedCurrency,
                  //     items: controller.currencyList.map<DropdownMenuItem<String>>((String item) {
                  //       return DropdownMenuItem<String>(
                  //         value: item,
                  //         child: Text(item, style: Style.fonts.w400s12.copyWith(color: Style.colors.secondary),),
                  //       );
                  //     }).toList(),
                  //     selectedItemBuilder: (context)=>controller.currencyList.map<Widget>((e) => Text(e.split(" ").last)).toList(),
                  //     // validator: validator,
                  //     // onSaved: onSaved,
                  //     style: Style.fonts.w400s12.copyWith(color: Style.colors.secondary),
                  //     decoration: InputDecoration(
                  //       contentPadding: const EdgeInsets.only(bottom: 0, left: 10),
                  //       isCollapsed: true,
                  //       hintStyle: Style.fonts.w400s14.copyWith(color: const Color(0xFFBDBDBD)),
                  //       border: InputBorder.none,
                  //     ), onChanged:controller.setCurrency,
                  //   ),
                  // ),
                  IconButton(
                      onPressed: controller.onOpenDrawerPressed,
                      icon: SvgPicture.asset(
                        "assets/icons/menu.svg",
                        height: 24,
                      )),
                ],
              ),
              Text(
                AppText.welcome_to_home_page.tr,
                style: Style.fonts.w400s16,
              )
            ],
          ),
        ),
      ],
    );
  }

  _dateSlider() {
    return Container(
      height: 52,
      margin: const EdgeInsets.only(top: 45, bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Style.colors.white),
      child: Row(
        children: [
          IconButton(
              onPressed: controller.onPreviousMonthPressed,
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
              )),
          Expanded(
            child: Center(
              child: Obx(() => Text(
                    controller.getSelectedMonth(),
                    style: Style.fonts.w400s14
                        .copyWith(color: Style.colors.secondary),
                  )),
            ),
          ),
          IconButton(
              onPressed: controller.onNextMonthPressed,
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ))
        ],
      ),
    );
  }

  _counterItems(Size size) {
    return Obx(
      () => Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          _counterCard(controller.dashboardResult.value.totalSubmitted,
              AppText.total_submitted.tr, size),
          _counterCard(controller.dashboardResult.value.totalArchived,
              AppText.total_archived.tr, size),
          _counterCard(controller.dashboardResult.value.totalPending,
              AppText.total_pending.tr, size),
          _counterCard(controller.dashboardResult.value.totalDeclined,
              AppText.total_declined.tr, size),
        ],
      ),
    );
  }

  _counterCard(int value, String title, Size size, {String? letter}) {
    return SizedBox(
      width: size.width / 2 - 34,
      height: (size.width / 2 - 40) * 1.01,
      child: Card(
        color: Style.colors.white,
        // color: const Color(0xffffffff),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: value.toDouble()),
              curve: Curves.easeIn,
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double value, Widget? child) {
                return Text(
                  "${value.toInt()}${letter ?? ""}",
                  style: Style.fonts.w600s48,
                );
              },
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style:
                  Style.fonts.w400s16.copyWith(color: Style.colors.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
