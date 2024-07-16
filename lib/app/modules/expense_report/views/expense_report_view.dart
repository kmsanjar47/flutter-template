import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:m_expense/app/const/style.dart';
import 'package:m_expense/app/localization/app_text.dart';
import 'package:m_expense/app/models/expense.dart';
import 'package:m_expense/app/utils/utils.dart';
import 'package:m_expense/app/widgets/app_button.dart';

import '../controllers/expense_report_controller.dart';

class ExpenseReportView extends GetView<ExpenseReportController> {
  const ExpenseReportView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Style.colors.offWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Style.colors.primary,
        title: Text(AppText.expenses.tr, style: Style.fonts.w500s22.copyWith(color: AppColors().white),),
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
          Positioned(
            top: 0,
            child: Container(
              color: Style.colors.primary,
              height: 200,
              width: size.width
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: size.width,
              height: size.height-AppBar().preferredSize.height,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              decoration: ShapeDecoration(
                color: Style.colors.offWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              child:  Column(
                children: [
                  const SizedBox(height: 16),
                  // Obx(()=> Visibility(
                  //   visible: controller.isStuff,
                  //   child: Row(
                  //       children: [
                  //         Expanded(child: _underlineFilterButton(size, isActive:controller.isSubmitted, title: AppText.submitted.tr, onTap: controller.onSubmittedFilterTap)),
                  //         const SizedBox(width: 20),
                  //         Expanded(child: _underlineFilterButton(size, isActive:!controller.isSubmitted, title: AppText.drafted.tr, onTap: controller.onDraftedFilterTap)),
                  //       ],
                  //     ),
                  // )),


                  Visibility(
                    visible: !controller.isStuff,
                    child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(top: 24, bottom: 8),
                          child: Text(AppText.employee_name.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),)),

                      TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: AppText.employee_name.tr,
                          prefixIcon: Padding(
                              padding: const EdgeInsets.all(14),
                              child: SvgPicture.asset("assets/icons/account.svg",color: Style.colors.secondary, width: 17 )),
                          isDense: true,
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                          hintStyle: Style.fonts.w400s14.copyWith(color:  const Color(0xFFBDBDBD)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ),
                    ],
                  ),),
                  // Container(
                  //     alignment: Alignment.centerLeft,
                  //     padding: const EdgeInsets.only(top: 24, bottom: 8),
                  //     child: Text(AppText.select_date.tr, style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary),)),


                  // InkWell(
                  //   onTap: controller.onShowReportTap,
                  //   child: Container(
                  //     margin: const EdgeInsets.only(top: 20),
                  //     width: double.infinity,
                  //     height: 60,
                  //     alignment: Alignment.center,
                  //     decoration: ShapeDecoration(
                  //       gradient: const LinearGradient(
                  //         begin: Alignment(-0.07, -1.00),
                  //         end: Alignment(0.07, 1),
                  //         colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                  //       ),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  //     ),
                  //     child:  Text(
                  //       AppText.show_report.tr,
                  //       textAlign: TextAlign.center,
                  //       style: Style.fonts.w500s18.copyWith(color: Style.colors.white, height: null),
                  //     ),
                  //   ),
                  // ),
                  Obx(()=>Visibility(
                    visible: controller.showReport,
                    child: Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 20),
                        width: size.width-48,
                        child: Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            _filterButton(title: AppText.all.tr, isActive: controller.getFilterType == "All", onTap: controller.onAllTap),
                            _filterButton(title: AppText.saved.tr, isActive: controller.getFilterType == "Drafted", onTap: controller.onSavedTap),
                            _filterButton(title: AppText.pending.tr, isActive: controller.getFilterType == "Pending", onTap: controller.onPendingTap),
                            _filterButton(title: AppText.archived.tr, isActive: controller.getFilterType == "Archived", onTap: controller.onArchivedTap),
                            _filterButton(title: AppText.declined.tr, isActive: controller.getFilterType == "Declined", onTap: controller.onDeclinedTap),
                          ],
                        ),
                      )),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _datePicker(size, context, onDatePicked: controller.onFromDatePicked, placeholder: AppText.from.tr),
                      _datePicker(size, context, onDatePicked: controller.onToDatePicked, placeholder: AppText.to.tr),
                      SizedBox(
                        child: InkWell(
                          onTap: controller.onShowReportTap,
                          child: Container(
                            width: size.width*.14,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(-0.07, -1.00),
                                end: Alignment(0.07, 1),
                                colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                            child:  const Icon(Icons.search_rounded, color: Colors.white,),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Obx((){
                     return SizedBox(height: controller.isSubmitted ? 0 : 20);
                   }),
                  Expanded(child: Obx(()=> Visibility(visible: controller.showReport, child:  controller.expenseList.isEmpty ? Container( alignment: Alignment.topCenter, child: SvgPicture.asset("assets/images/no_data.svg")) : _reportList(size, controller.expenseList)))),


                  // Expanded(child: Obx(()=> Visibility(visible: !controller.showReport && !controller.isSubmitted, child: _reportList(size)))),
                   // Obx(()=> Visibilitßy(visible: controller.showReport, child: _reportTable(size))),
                   // Obx(()=> Visibility(visible: !controller.showReport && !controller.isSubmitted, child: _reportTable(size))),

                ],
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: Obx(
        ()=> Visibility(
          visible: controller.getFilterType == "Drafted",
          child: SafeArea(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                width: double.infinity,
                height: 60,
                child: AppButton(onPressed: controller.onSubmitAllTap,text: AppText.submit_all.tr,)),
          ),
        ),
      ),
    );
  }

  Widget _filterButton({String title = "", bool isActive = false, bool margin = false, GestureTapCallback? onTap}){
    return InkWell(
      onTap: onTap,
      child: UnconstrainedBox(
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            gradient: isActive ?  const LinearGradient(
              begin: Alignment(-0.07, -1.00),
              end: Alignment(0.07, 1),
              colors: [Color(0xFF85C1F9), Color(0xFF25B1EA)],
            ) : null,
            color: isActive ?  null :Style.colors.white ,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child:  Text(
            title,
            textAlign: TextAlign.center,
            style:  isActive ? Style.fonts.w500s18.copyWith(color:Style.colors.white)
                :Style.fonts.w400s16.copyWith(color: Style.colors.secondary) ,
          ),
        ),
      ),
    );
  }
  _underlineFilterButton(Size size, {bool isActive = false, String title = "", GestureTapCallback? onTap}) {
    return SizedBox(
      width: size.width/2-68,
      child: InkWell(
        onTap: onTap, child: Column(
          children: [
            Text( title, style: Style.fonts.w500s18,),
            Container(
              height: 2,
              width: double.infinity,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: isActive?Style.colors.primary:Color(0x2649536a)
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _reportTable(Size size) {


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // child: Container(width: 2000, color: Colors.green, child:Text("lfksadflkasfj asflkjas fjk"),),
      child: SizedBox(
          height: size.height*.44,
          width: 885,
          child: Column(children: [
            _tableHeading(),
            Expanded(child: Container(
              color: Style.colors.white,
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 6.5),
                  itemCount: 15,
                  itemBuilder: (_,index){
                    return
                    Container(
                      height: 60,
                      width: 875,
                      decoration: BoxDecoration(
                          color: index%2!=0?Style.colors.offWhite:Style.colors.white,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))
                      ),
                      child: Row(
                        children: [
                          Container(alignment:Alignment.center, width: 163, child: Text(AppText.employee_name.tr,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary)),),
                          VerticalDivider(),
                          Container(alignment:Alignment.center, width: 147, child: Text(AppText.expense_type.tr,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary)),),
                          VerticalDivider(),
                          Container(alignment:Alignment.center, width: 136, child: Text(AppText.organization.tr,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary)),),
                          VerticalDivider(),
                          Container(alignment:Alignment.center, width: 100 , child: Text(AppText.total_bill.tr,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary)),),
                          VerticalDivider(),
                          Container(alignment:Alignment.center, width: 127 , child: Text(AppText.attachment.tr,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary)),),
                          VerticalDivider(),
                          Container(alignment:Alignment.center, width: 106 , child: Text(AppText.action.tr,style: Style.fonts.w400s16.copyWith(color: Style.colors.secondary)),),
                        ],
                      ),
                    );
                  }
              ),
            ))
          ],))
    );
  }


  Widget _textWidget({double width = 0, String text = ""}){
    return Container(alignment:Alignment.center, width: width, child: Text(text,style: Style.fonts.w500s18.copyWith(color: Style.colors.white)),);
  }

  Widget _tableHeading(){
    return Container(
      height: 60,
      width: 885,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF25B1EA), Color(0xFF85C1F9)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6))),
      ),
      child: Row(
        children: [
          _textWidget(width: 170, text: AppText.employee_name.tr),
          const VerticalDivider(),
          _textWidget(width: 147, text: AppText.expense_type.tr),
          const VerticalDivider(),
          _textWidget(width: 136, text: AppText.organization.tr),
          const VerticalDivider(),
          _textWidget(width: 100, text: AppText.total_bill.tr),
          const VerticalDivider(),
          _textWidget(width: 127, text: AppText.attachment.tr),
          const VerticalDivider(),
          _textWidget(width: 106,text: AppText.action.tr),
        ],
      ),
    );
  }

  _datePicker(Size size, BuildContext context, {Function(String)? onDatePicked, String placeholder = "From"}) {
    RxString dateTx = placeholder.obs;
    return Container(
      width: size.width*.43-34,
      height: 50,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Style.colors.white),
      child: MaterialButton(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        splashColor: Style.colors.primary.withOpacity(.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)),
        onPressed: () async {
          final DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(DateTime.now().year-1, DateTime.now().month, DateTime.now().day),
              lastDate: DateTime(DateTime.now().year + 2),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                          onPrimary: Colors.white, // selected text color
                          onSurface: Colors.white, // default text color
                          primary: Style.colors.primary // circle color
                      ),
                      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontFamily: 'Quicksand'),
                              foregroundColor: Colors.white, // color of button's letters
                              backgroundColor: Style.colors.primary, // Background color
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.transparent,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(50))))),
                  child: child!,
                );
              });
          if(selectedDate!=null && onDatePicked!=null){
            dateTx.value = DateFormat("dd-MM-yyyy").format(selectedDate);
            onDatePicked(DateFormat("yyyy-MM-dd").format(selectedDate));
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(()=> Text(dateTx.value, style: Style.fonts.w400s14.copyWith(color: Style.colors.secondary))),
            SvgPicture.asset("assets/icons/calendar.svg")
          ],
        ),
      ),
    );
  }

  Widget _reportList(Size size, List<Expense> data) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: controller.getFilterType == "Drafted"?160:80),
      itemCount: data.length,
      itemBuilder: (_, index){
      return Container(
        decoration: BoxDecoration(
          color: Style.colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [

            Row(
              children: [
                Text(controller.getExpenseType(index), style: Style.fonts.w500s18.copyWith(color: AppColors().secondary)),
                const Spacer(),
                if(data[index].status=="ARCHIVED")
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffe4f4f9),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Archived", style: Style.fonts.w400s12.copyWith(color: Style.colors.primary),),
                  )
                else if(data[index].status=="SUBMITTED")
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffe5f9e4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Submitted", style: Style.fonts.w400s12.copyWith(color: Colors.green),),
                  )
                else if(data[index].status=="DECLINED")
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffffe2e2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Declined", style: Style.fonts.w400s12.copyWith(color: Colors.redAccent),),
                  )
                else
                  Row(
                    children: [
                      IconButton(onPressed: ()=> controller.onItemDeleteTap(index), icon: SvgPicture.asset("assets/icons/delete.svg")),
                      IconButton(onPressed: ()=> controller.onItemEditTap(index), icon: SvgPicture.asset("assets/icons/edit.svg")),
                      if(data[index].status=="DRAFTED")
                        IconButton(onPressed: ()=> controller.onItemSubmitTap(index), icon: SvgPicture.asset("assets/icons/checked_round.svg")),
                    ],
                  )

              ],
            ),
            _textRow(title: AppText.employee_name.tr, value: data[index].userName??""),
            _textRow(title: AppText.customer_or_vendor.tr, value: data[index].vendor??""),
            _textRow(title: AppText.total_bill.tr, value: "${controller.getCurrencySymbol(index)} ${data[index].totalBill??""}"),
            _textRow(title: AppText.attachment.tr, value: Utils.shortFileName(data[index].documentName??""), attachment: true, onPressed: ()=> controller.onPreviewAttachmentTap(index)),
            if(data[index].comment!=null && data[index].comment!.isNotEmpty) _textRow(title: AppText.comment.tr, value: data[index].comment??""),
          ],
        )
      );
    },);
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
