import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/page/profile_page/promotion_page/promotion_header.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  return controller.getloadPromotionOfUser
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: controller.getlistuserpromotion.map((item) {
                            Storesitem? storesitem = storecontroller.getStoreById(item.storeId!);
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
                                  Text("Mã code : ${item.promotionCode}"),
                                  Text("Giá trị : ${item.percent!.toInt()} %"),
                                  Container(
                                    width: AppDimention.screenWidth,
                                    
                                    margin: EdgeInsets.only(top: AppDimention.size10),
                                    padding: EdgeInsets.all(AppDimention.size10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(AppDimention.size5)
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Text("${storesitem!.storeName!}"),
                                          Text("Địa chỉ : ${storesitem.location!}"),
                                          GestureDetector(
                                            onTap: (){
                                              Get.toNamed(AppRoute.get_store_detail(storesitem.storeId!));
                                            },
                                            child: Center(
                                              child: Container(
                                                width: AppDimention.size100,
                                                height: AppDimention.size40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1,color: Colors.green),
                                                  borderRadius: BorderRadius.circular(AppDimention.size5)
                                                ),
                                                child: Center(
                                                  child: Text("Chi tiết"),
                                                ),
                                              ),

                                            ),
                                          )
                                      ],
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
