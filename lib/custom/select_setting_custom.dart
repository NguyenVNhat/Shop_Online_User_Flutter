import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
class SelectSettingCustom extends StatelessWidget{
  final IconData icon;
  final String title;
   SelectSettingCustom({
       Key? key,
       required this.icon,
       required this.title,
   }): super(key:key);
   @override
   Widget build(BuildContext context) {
       return Container(
          child: Row(
            children: [
              SizedBox(width: AppDimention.size10,),
              Icon(icon,size: 30,color: AppColor.mainColor,),
              SizedBox(width: AppDimention.size20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                 
                ],
              ),

            ],
          ),
       );
   }
}