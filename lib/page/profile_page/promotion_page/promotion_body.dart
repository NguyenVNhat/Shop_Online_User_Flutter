import 'dart:math';

import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/route/app_route.dart';
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
  PromotionController promotionController = Get.find<PromotionController>();
  Storecontroller storecontroller = Get.find();
  @override
  void initState() {
    super.initState();
    promotionController.getall();
    promotionController.getbyUser();
  }

   String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionController>(builder: (controller) {
      return controller.getloading!
          ? Center(
              child: CircularProgressIndicator(),
            )
          :controller.listpromotion.length == 0 ? Container(
            width: Get.width,
            height: 100,
            child: Center(
              child: Text("Hiện không có mã giảm giá"),
            ),
          ) : Column(
              children:  controller.listpromotion.map((item) {
                return Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  margin: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimention.size10),
                      image: DecorationImage(
                          image: promotionController.checkVoucher(item.code!) ? AssetImage("assets/image/Voucher0.png") : AssetImage("assets/image/Voucher2.png"),fit: BoxFit.cover)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mã code : ${item.code}",
                        style: TextStyle(color:promotionController.checkVoucher(item.code!) ? Colors.white : Colors.black),
                      ),
                      Text(
                        "Giá trị : ${item.discountPercent!.toInt()} %",
                        style: TextStyle(color:promotionController.checkVoucher(item.code!) ? Colors.white : Colors.black),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${formatTime(item.startDate!)}",
                            style: TextStyle(color:promotionController.checkVoucher(item.code!) ? Colors.white : Colors.black),
                          ),
                          Text(
                            "${formatTime(item.endDate!)}",
                            style: TextStyle(color:promotionController.checkVoucher(item.code!) ? Colors.white : Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        margin: EdgeInsets.only(top: AppDimention.size10),
                        
                        child: Column(
                          children: item.storeId!.map((item) {
                            Storesitem? storeitem =
                                storecontroller.getStoreById(item);
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(AppRoute.get_store_detail(
                                    storeitem.storeId!));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size5)),
                                width: AppDimention.screenWidth,
                                padding: EdgeInsets.all(AppDimention.size10),
                                margin: EdgeInsets.only(
                                    bottom: AppDimention.size10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${storeitem!.storeName}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text("${storeitem.location}"),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if(promotionController.checkVoucher(item.code!))
                        GestureDetector(
                          onTap: (){
                              promotionController.savepromotion(item.voucherId!);
                          },
                          child: Container(
                          width: AppDimention.size100,
                          height: AppDimention.size40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppDimention.size5),
                          ),
                          child: Center(
                            child: Text("Lưu"),
                          ),
                        ),
                        )
                    ],
                  ),
                );
              }).toList(),
            );
    });
  }
}
