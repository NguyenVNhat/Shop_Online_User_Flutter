import 'dart:math';

import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

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
    // return GetBuilder(builder: (comboController) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          int index = _random.nextInt(1);
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
                  )
                ),
                borderRadius: BorderRadius.circular(AppDimention.size10)),
            child: Row(
              children: [
                Container(
                  width: AppDimention.size120,
                  height: AppDimention.size130,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(width: 5, color: Colors.black12))),
                  child: Center(
                    child: Text("đ20.000",style: TextStyle(color: Colors.white),),
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
                                  Text("Mã : 38A49MD08",style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: AppDimention.size100,
                                    child: Text("BLACK FRIDAY",maxLines: 2,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.white)),
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
                              Text("Ngày hết hạn : 19/10/2024",style: TextStyle(color: Colors.white),),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
  //   );
  // }
}
