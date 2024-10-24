import 'dart:math';

import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PromotionBody extends StatefulWidget {
  const PromotionBody({
    Key? key,
  }) : super(key: key);
  @override
  _PromotionBodyState createState() => _PromotionBodyState();
}

class _PromotionBodyState extends State<PromotionBody> {
  final Random _random = Random();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionController>(builder: (controller) {
      return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.listpromotion.length,
          itemBuilder: (context, index) {
            int index = _random.nextInt(1);
            PromotionData item = controller.listpromotion[index];
            return Container(
              width: AppDimention.screenWidth,
              height: AppDimention.size130,
              margin: EdgeInsets.only(
                  left: AppDimention.size10,
                  right: AppDimention.size10,
                  bottom: AppDimention.size10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/image/Voucher$index.png",
                      )),
                  borderRadius: BorderRadius.circular(AppDimention.size10)),
              child: Row(
                children: [
                  Container(
                    width: AppDimention.size120,
                    height: AppDimention.size130,
                    decoration: BoxDecoration(
                        border: Border(
                            right:
                                BorderSide(width: 5, color: Colors.black12))),
                    child: Center(
                      child: Text(
                        "${item.discountPercentage!.toInt()}%",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: AppDimention.size100 * 2.5,
                    height: AppDimention.size130,
                    padding: EdgeInsets.all(AppDimention.size10),
                    child: Column(
                      children: [
                        Container(
                            width: AppDimention.size100 * 2.5,
                            height: AppDimention.size130 * 0.6,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.startDate != null
                                          ? "Ngày bắt đầu ${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.startDate!))}"
                                          : "Ngày bắt đầu không hợp lệ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: AppDimention.size100,
                                      child: Text("${item.name}",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.white)),
                                    )
                                  ],
                                )
                              ],
                            )),
                        Container(
                            width: AppDimention.size100 * 2.5,
                            height: AppDimention.size130 * 0.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                      item.startDate != null
                                          ? "Ngày hết hạn ${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.endDate!))}"
                                          : "Ngày hết hạn không hợp lệ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            );
          });
    });
  }
}
