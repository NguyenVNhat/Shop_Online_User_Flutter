import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
class SelectProfileCustom extends StatelessWidget{
  final IconData icon;
  final String title;
  final String smalltext;
   SelectProfileCustom({
       Key? key,
       required this.icon,
       required this.title,
       required this.smalltext,
   }): super(key:key);
   @override
   Widget build(BuildContext context) {
       return Container(
        margin: EdgeInsets.only(top:AppDimention.size10),
          child: Row(
            children: [
              SizedBox(width: AppDimention.size10,),
              Icon(icon,size: 40,color: AppColor.mainColor,),
              SizedBox(width: AppDimention.size20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimention.size20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    smalltext,
                    style: TextStyle(
                      fontSize: AppDimention.size15
                    ),
                  )
                ],
              ),

            ],
          ),
       );
   }
}