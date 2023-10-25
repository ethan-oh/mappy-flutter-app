import 'package:final_main_project/viewmodel/card_obs.dart';
import 'package:final_main_project/viewmodel/card_vm.dart';
import 'package:final_main_project/widget/more/cardRegister_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 카드 번호 관리
    final cardobs = Get.put(CardGet());
    // 카드 firebase
    final cardVm = Get.put(CardVm());
    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(
                () => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cardVm.cardDataList.length,
                  itemBuilder: (context, index) {
                    var data = cardVm.cardDataList[index];
                    // 카드 색상
                    List<Color> colors = [
                      Colors.grey,
                      Colors.blue,
                      Colors.green
                    ];
                    Color cardColor = colors[index % colors.length];
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        // Firebase 삭제
                        await cardVm.deleteCard(cardVm.cardDataList[index]);
                      },
                      background: Container(color: Colors.red),
                      child: CreditCardWidget(
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        cardNumber: data.number,
                        expiryDate: data.date,
                        cardHolderName: 'CARD',
                        cvvCode: data.cvc,
                        chipColor: Colors.amber,
                        cardBgColor: cardColor,
                        showBackView: false,
                        onCreditCardWidgetChange: (CreditCardBrand) {},
                      ),
                    );
                  },
                ),
              ),
              if (cardVm.cardDataList.length <
                  3) // 카드 데이터가 3개 미만일 때만 Container 표시
                InkWell(
                  onTap: () {
                    // 카드내역 삭제
                    cardobs.remove();
                    // 카드 등록
                    Get.bottomSheet(
                      Container(
                        height: 420.h,
                        color: Theme.of(context).colorScheme.background,
                        child: cardwidget(context, cardVm.cardDataList.length),
                      ),
                      isScrollControlled: true,
                      isDismissible: false,
                    );
                  },
                  child: Container(
                    width: 310.w,
                    height: 150.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_card,
                        size: 40,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}