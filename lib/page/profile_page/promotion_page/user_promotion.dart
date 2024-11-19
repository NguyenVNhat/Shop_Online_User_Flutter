import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/page/profile_page/promotion_page/promotion_header.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserPromotion extends StatefulWidget {
  const UserPromotion({
    Key? key,
  }) : super(key: key);
  @override
  _UserPromotionState createState() => _UserPromotionState();
}

class _UserPromotionState extends State<UserPromotion> {
  PromotionController promotionController = Get.find();
  Storecontroller storecontroller = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    promotionController.getbyUser();
  }

  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          PromotionHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  child: Text("Dành cho bạn"),
                ),
                GetBuilder<PromotionController>(builder: (controller) {
                  return controller.loadingByUser!
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
                          children: controller.listpromotionByUser.map((item) {
                            return Container(
                              width: AppDimention.screenWidth,
                              padding: EdgeInsets.all(AppDimention.size10),
                              margin: EdgeInsets.all(AppDimention.size10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size10),
                                  color: item.used!
                                      ? Colors.grey[200]
                                      : Colors.green),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mã code : ${item.code}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "Giá trị : ${item.discountPercent!.toInt()} %",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${formatTime(item.startDate!)}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "${formatTime(item.endDate!)}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: AppDimention.screenWidth,
                                    margin: EdgeInsets.only(
                                        top: AppDimention.size10),
                                    padding:
                                        EdgeInsets.all(AppDimention.size10),
                                    child: Column(
                                      children: item.storeId!.map((item) {
                                        Storesitem? storeitem =
                                            storecontroller.getStoreById(item);
                                        return GestureDetector(
                                          onTap: () {
                                            Get.toNamed(AppRoute.get_store_detail(storeitem.storeId!));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        AppDimention.size5)),
                                            width: AppDimention.screenWidth,
                                            padding: EdgeInsets.all(
                                                AppDimention.size10),
                                            margin: EdgeInsets.only(
                                                bottom: AppDimention.size10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("${storeitem!.storeName}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                                Text("${storeitem.location}"),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        );
                })
              ],
            ),
          )),
        ],
      ),
    );
  }
}
