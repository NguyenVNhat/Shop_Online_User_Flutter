import 'dart:convert';

import 'package:flutter_user_github/custom/big_text.dart';
import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);
  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (usercontroller) {
      return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.size100 * 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.only(top: AppDimention.size20),
              width: AppDimention.screenWidth,
              child: Center(
                child: Text("Hồ sơ",style: TextStyle(fontSize: AppDimention.size25,color: Colors.white)),
              ),
            ),
            Row(
              children: [
                Container(
                  width: AppDimention.size80,
                  height: AppDimention.size80,
                  margin: EdgeInsets.only(
                      left: AppDimention.size30, top: AppDimention.size30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image:usercontroller.userprofile?.avatar == null? MemoryImage(base64Decode(usercontroller.userprofile!.avatar!)) : AssetImage("assets/image/avatar.jpg")
                          )
                          ),
                ),
                SizedBox(
                  width: AppDimention.size20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: AppDimention.size30,
                    ),
                    BigText(
                      text: usercontroller.userprofile?.fullName ??
                          'Default Name',
                      color: Colors.white,
                    ),
                    Text(
                      "ID: ${usercontroller.userprofile?.id}MA04990",
                      style: TextStyle(color: Colors.white),
                    ),
                    
                  ],
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
