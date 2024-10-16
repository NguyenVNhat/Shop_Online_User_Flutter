import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
class IconTextCustom extends StatelessWidget{
  IconData iconData;
  String text;
  Color color;
  Color colorIcon;
  double width;
  double height;
   IconTextCustom({
      required this.iconData,
      required this.text,
      required this.color,
      required this.colorIcon,
      required this.width,
      required this.height,
       Key? key,
   }): super(key:key);
   @override
   Widget build(BuildContext context) {
       return Container(
          child: Column(
            children: [
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.all(Radius.circular(AppDimention.size30))
                ),
                child: Icon(iconData,color: colorIcon,),
              ),
              SizedBox(height: AppDimention.size10,),
              Text(text,style: TextStyle(fontSize: 12),)
            ],
          ),
       );
   }
}