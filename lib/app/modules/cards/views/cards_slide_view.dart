import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:m_expense/app/models/card.dart' as model;
import 'package:get/get.dart';
import 'package:m_expense/app/localization/app_text.dart';

import '../../../const/style.dart';
import '../controllers/cards_controller.dart';

class CardsSlideView extends GetView<CardsController> {
  const CardsSlideView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.my_cards.tr, style: Style.fonts.w500s22.copyWith(color: AppColors().secondary),),
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
      ),
      body: Column(
        children: [
          Obx(()=>controller.cardList.isEmpty? SvgPicture.asset("assets/images/no_data.svg"):  SizedBox(
            height: size.width*.62,
            child: PageView.builder(
                  itemCount: controller.cardList.length,
                onPageChanged: controller.onPageChange,
                itemBuilder: (_, index){
                   model.Card  data = controller.cardList.elementAt(index);
                return InkWell(
                  onTap:()=>controller.onCardItemTap(controller.cardList[index]),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0,left: 24, right: 24, top: 24),
                    child: cardWidget(
                        size,
                        name: data.name??"",
                        expiryDate: "MM/YY",
                        number: "${data.number1} XXXX XXXX ${data.number2}",
                      cardIcon:data.cardType!=null
                          ? data.cardType == 38 ? "assets/icons/master_card_logo.svg"
                          :data.cardType == 39 ? "assets/icons/visa.svg"
                          :data.cardType == 40 ? "assets/icons/american_express.svg"
                          :"assets/icons/debit-card-credit.svg"
                          : "assets/icons/debit-card-credit.svg"
                    ),
                  ),
                );}),
          ) ),
          Obx(()=> Container(
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: DotsIndicator(
              dotsCount: controller.cardList.isEmpty?1:controller.cardList.length,
              position: controller.currentIndexPage.value.toDouble(),
              decorator: const DotsDecorator(activeSize: Size(10,10), size: Size(6,6), spacing: EdgeInsets.only(left: 6)),
            ),
          ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: controller.onAddNewButtonPressed,
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Text(
                  AppText.add_new_card.tr,
                  textAlign: TextAlign.center,
                  style: Style.fonts.w500s18.copyWith(
                      color: Style.colors.white, height: null),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardWidget(Size size, {String number = "1234-5678-8978-4321", String expiryDate = "12/28", String name = "Abdullah Al Mamun", String bgImagePath = "assets/images/card_bg.svg", String cardIcon = "assets/icons/master_card_logo.svg"}) => Container(
      alignment: Alignment.bottomLeft,
      padding:  EdgeInsets.only(left: 26, bottom: 27, right: 32, top: size.width*.14),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: svg.Svg(bgImagePath),
              fit: BoxFit.fitHeight
          ),
          borderRadius: BorderRadius.circular(10)
      ),
      height: size.width*.48,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if(number.length<3)
            Text(number, style: Style.fonts.w500s24)
          else
            FittedBox(fit: BoxFit.scaleDown, child: Text(number, style: Style.fonts.w500s24)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expiryDate, style: Style.fonts.w500s14),
                  SizedBox(height: size.width*.03 ,),

                  if(name.length<3)
                    Text(name.toUpperCase(), style: Style.fonts.w500s16)
                  else
                    Container(
                      alignment: Alignment.centerLeft,
                      width: size.width*.6,
                        child: FittedBox(fit: BoxFit.scaleDown, child: Text(name.toUpperCase(), style: Style.fonts.w500s16))),
                ],
              ),
              const Spacer(),
              SvgPicture.asset(cardIcon, width: 60, height: 40,)
            ],
          )
        ],
      ),
    );
}
