import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ShipperRegisterHeader extends StatefulWidget{
   const ShipperRegisterHeader({
       Key? key,
   }): super(key:key);
   @override
   _ShipperRegisterHeaderState createState() => _ShipperRegisterHeaderState();
}
class _ShipperRegisterHeaderState extends State<ShipperRegisterHeader>{
   @override
   Widget build(BuildContext context) {
      return Container(
        width: AppDimention.screenWidth,
        height: AppDimention.size60,
        padding: EdgeInsets.only(left: AppDimention.size10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1,color: Colors.black26))
        ),
        child: Row(
          children: [
              GestureDetector(
                onTap: (){
                    Get.back();
                },
                child: Container(
                width: AppDimention.size30,
                height: AppDimention.size30,
               
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimention.size30),
                  color: AppColor.mainColor
                ),
                child: Center(
                  child: Icon(Icons.arrow_back_ios_new,size: AppDimention.size15,color: Colors.white,),
                ),
              ),
              ),
              SizedBox(width: AppDimention.size20,),
              Text("Đăng kí giao hàng",style: TextStyle(fontSize: AppDimention.size20),)
          ],
        ),
      );
   }
}