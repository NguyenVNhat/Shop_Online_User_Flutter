import 'dart:convert';

import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/models/Model/RateModel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';

class ProductRate extends StatefulWidget {
  const ProductRate({
    Key? key,
  }) : super(key: key);
  @override
  _ProductRateState createState() => _ProductRateState();
}

class _ProductRateState extends State<ProductRate> {
  ProductController productController = Get.find<ProductController>();
  List<int>         listTitle         = [1, 2, 3, 4, 5];
  int               selected          = 1;
  // Show image of feed back
  void _showImage(item) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: AppDimention.screenWidth,
              height: AppDimention.size100 * 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimention.size20),
                image: DecorationImage(
                    image: MemoryImage(base64Decode(item)), fit: BoxFit.cover)),
          ));
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: AppDimention.size30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: AppDimention.size10,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                ),
              ),
              SizedBox(
                width: AppDimention.size20,
              ),
              Text(
                "Đánh giá sản phẩm",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          SizedBox(
            height: AppDimention.size20,
          ),
          // Header of feedback page
          Container(
            width: AppDimention.screenWidth,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[400]!))),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: listTitle
                    .map((item) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = item;
                            });
                          },
                          child: Container(
                            width: AppDimention.size150,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: selected == item
                                    ? Colors.amber
                                    : Colors.transparent),
                            child: Center(
                              child: Text("${item} sao"),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          // Container of feedback
          Expanded(
              child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: productController.getlistcomment.map((item) {
                  User user = User();
                  RateData rateData = RateData();
                  bool isStar = false;
                  if (item.rateData!.rate == selected) {
                    user = item.user!;
                    rateData = item.rateData!;
                    isStar = true;
                  }

                  return isStar ? Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.all(AppDimention.size20),
                    margin: EdgeInsets.only(
                        left: AppDimention.size10,
                        right: AppDimention.size10,
                        top: AppDimention.size10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${user.fullName}"),
                            Row(
                              children: [
                                Wrap(
                                  children: List.generate(
                                      rateData.rate!,
                                      (index) => Icon(Icons.star,
                                          color: AppColor.mainColor,
                                          size: AppDimention.size15)),
                                ),
                                SizedBox(
                                  width: AppDimention.size5,
                                ),
                                Text(
                                  "(${rateData.rate})",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.mainColor),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        if (!rateData.imageRatings!.isEmpty)
                          Wrap(
                            spacing: AppDimention.size10,
                            runSpacing: AppDimention.size5,
                            children: rateData.imageRatings!
                                .map((item) => GestureDetector(
                                      onTap: () {
                                        _showImage(item);
                                      },
                                      child: Container(
                                        width: AppDimention.size70,
                                        height: AppDimention.size70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size10),
                                          border: Border.all(
                                              width: 1, color: Colors.black12),
                                          image: DecorationImage(
                                            image:
                                                MemoryImage(base64Decode(item)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Container(
                            width: AppDimention.screenWidth,
                            color: Colors.white,
                            padding: EdgeInsets.all(AppDimention.size10),
                            child: Text("${rateData.comment}",
                                textAlign: TextAlign.justify,
                                style: TextStyle()))
                      ],
                    ),
                  ):Row();
                }).toList()),
          )),
        ],
      ),
    );
  }
}
