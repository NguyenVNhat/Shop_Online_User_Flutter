import 'dart:math';

import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/models/Dto/PromotionDto.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:flutter_user_github/models/Model/PromotionOfStoreModel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
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
  PromotionController promotionController = Get.find<PromotionController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    promotionController.getAllPromotionOfStore();
    promotionController.getListPromotionOfUer();
  }

  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm').format(dateTime);
  }
  void _checkPromotion(int storeId,int promotionId){
    
    Promotiondto dto = Promotiondto(storeId: storeId,promotionId: promotionId);
      promotionController.savepromotion(dto);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PromotionController>(builder: (controller) {
      return controller.getloadingDisplay!
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.listPromotionOfStore.length,
              itemBuilder: (context, index) {
                Storesitem storesitem =
                    controller.listPromotionOfStore[index].storesitem!;
                List<PromotionDataOfStore> listpromotion = controller
                    .listPromotionOfStore[index].promotionDataOfStore!;
                return Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.all(AppDimention.size10),
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppDimention.size10)),
                  child: Column(
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size100 * 2,
                        padding: EdgeInsets.all(AppDimention.size10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppDimention.size10),
                                topRight: Radius.circular(AppDimention.size10)),
                            color: Colors.white,
                            border:
                                Border.all(width: 1, color: Colors.black12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${storesitem.storeName}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: AppDimention.size10,
                            ),
                            Text("Địa chỉ : ${storesitem.location}"),
                            SizedBox(
                              height: AppDimention.size5,
                            ),
                            Text(
                              "Thời gian hoạt động : " +
                                  formatTime(storesitem.openingTime!) +
                                  " - " +
                                  formatTime(storesitem.closingTime!),
                            ),
                            SizedBox(
                              height: AppDimention.size10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoute.get_store_detail(
                                      storesitem.storeId!));
                                },
                                child: Container(
                                  width: AppDimention.size120,
                                  height: AppDimention.size40,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: AppColor.mainColor),
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size5),
                                  ),
                                  child: Center(
                                    child: Text("Chi tết"),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: listpromotion
                            .map((item) => Container(
                                  width: AppDimention.screenWidth * 0.9,
                                  height: AppDimention.size100,
                                  margin: EdgeInsets.only(
                                    top: AppDimention.size10,
                                  ),
                                  decoration: BoxDecoration(
                                    image:  DecorationImage(
                                        fit: BoxFit.cover,
                                        image: promotionController.checkPromotion(item.name!) ? AssetImage(
                                          "assets/image/Voucher0.png",
                                        ) :
                                         AssetImage(
                                          "assets/image/Voucher2.png",
                                        )
                                        ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            (AppDimention.screenWidth) * 0.25,
                                        height: AppDimention.size130,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    width: 5,
                                                    color: Colors.black12))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${item.discountPercentage!.toInt()}%",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            promotionController.checkPromotion(item.name!) ?
                                            GestureDetector(
                                              onTap: (){
                                                  _checkPromotion(storesitem.storeId!,item.id! );
                                              },
                                              child: Text("Lưu",style: TextStyle(color: Colors.white,fontSize: 13)),
                                            ) : 
                                            GestureDetector(
                                              onTap: (){
                                                  
                                              },
                                              child: Text("Đã sở hữu",style: TextStyle(color: Colors.white,fontSize: 13)),
                                            ) 
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width:
                                            (AppDimention.screenWidth * 0.9) *
                                                0.65,
                                        height: AppDimention.size130,
                                        padding:
                                            EdgeInsets.all(AppDimention.size10),
                                        child: Column(
                                          children: [
                                            Container(
                                                width:
                                                    (AppDimention.screenWidth *
                                                            0.9) *
                                                        0.75,
                                                height:
                                                    AppDimention.size100 * 0.6,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item.startDate != null
                                                          ? "${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.startDate!))}"
                                                          : "Ngày bắt đầu không hợp lệ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text("${item.name}",
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                )),
                                            Container(
                                                width:
                                                    (AppDimention.screenWidth *
                                                            0.9) *
                                                        0.4,
                                                height:
                                                    AppDimention.size100 * 0.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      item.startDate != null
                                                          ? "${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.endDate!))}"
                                                          : "Ngày hết hạn không hợp lệ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                );
              });
    });
  }
}
