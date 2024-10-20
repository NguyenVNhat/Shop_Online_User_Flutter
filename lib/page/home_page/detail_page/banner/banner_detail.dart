import 'dart:convert';

import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerDetail extends StatelessWidget {
  final int pageId;
  BannerDetail({
    required this.pageId,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var product = Get.find<ComboController>().comboList[pageId];

    return Scaffold(
        body: Stack(
      children: [
        // Image container
        Positioned(
          top: 0,
          left: 0,
          height: AppDimention.screenWidth - AppDimention.size40,
          width: AppDimention.screenWidth,
          child: Container(
            decoration: BoxDecoration(
              color: AppColor.mainColor,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(
                  base64Decode(product.image!),
                ),
              ),
            ),
          ),
        ),

        // Infomation Container
        Positioned(
          top: 250,
          width: AppDimention.screenWidth,
          height: AppDimention.screenHeight - 250,
          child: Container(
            decoration: BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimention.size40),
                    topRight: Radius.circular(AppDimention.size40))),
          ),
        ),
        // Footer Container
        Positioned(
          bottom: 0,
          width: AppDimention.screenWidth,
          height: AppDimention.size60,
          child: Container(
            decoration: BoxDecoration(color: AppColor.yellowColor),
          ),
        ),
        //Announce container
        Container(),
      ],
    ));
  }
}
