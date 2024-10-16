import 'package:flutter_user_github/custom/icon_text_custom.dart';
import 'package:flutter_user_github/data/controller/Order_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';

import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileControll extends StatefulWidget {
  const ProfileControll({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileControllState createState() => _ProfileControllState();
}

class _ProfileControllState extends State<ProfileControll> {
  PageController pageController = PageController(viewportFraction: 0.96);
  double currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        if (pageController.page != null) {
          currentPageValue = pageController.page!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.size100,
        padding: EdgeInsets.all(AppDimention.size10),
        margin: EdgeInsets.all(AppDimention.size10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(AppDimention.size10),
            border: Border.all(width: 1, color: Colors.grey.withOpacity(0.2))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.ORDER_PAGE);
              },
              child: Container(
                width: AppDimention.size80,
                height: AppDimention.size80,
                padding: EdgeInsets.all(AppDimention.size5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimention.size10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.food_bank_outlined,
                      size: 27,
                      color: Colors.black54,
                    ),
                    Text(
                      "Đơn hàng",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.toNamed(AppRoute.PROMOTION_PAGE);
              },
              child: Container(
              width: AppDimention.size80,
              height: AppDimention.size80,
              padding: EdgeInsets.all(AppDimention.size5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimention.size10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.airplane_ticket,
                    size: 27,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    height: AppDimention.size5,
                  ),
                  Text(
                    "Giảm giá",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.CHART_PAGE);
              },
              child: Container(
                width: AppDimention.size80,
                height: AppDimention.size80,
                padding: EdgeInsets.all(AppDimention.size5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimention.size10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_outlined,
                      size: 27,
                      color: Colors.black54,
                    ),
                    SizedBox(
                      height: AppDimention.size5,
                    ),
                    Text(
                      "Tin nhắn",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
