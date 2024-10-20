import 'package:flutter_user_github/data/controller/Chart_controller.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartHeader extends StatefulWidget {
  const ChartHeader({
    Key? key,
  }) : super(key: key);
  @override
  _ChartHeaderState createState() => _ChartHeaderState();
}

class _ChartHeaderState extends State<ChartHeader> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartController>(builder: (chartController) {
      return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.size70,
        padding: EdgeInsets.only(
            left: AppDimention.size10, right: AppDimention.size10),
        decoration: BoxDecoration(color: AppColor.mainColor),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                chartController.ChangeShow();
              },
              child: Icon(
                Icons.view_list,
                color: Colors.white,
                size: AppDimention.size40,
              ),
            ),
            SizedBox(
              width: AppDimention.size20,
            ),
            Text(Get.find<ChartController>().getchartname,
                style: TextStyle(
                    fontSize: AppDimention.size20, color: Colors.white))
          ],
        ),
      );
    });
  }
}
