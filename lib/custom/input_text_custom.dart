import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
class InputTextCustom extends StatelessWidget{
  final TextEditingController controller;
  final IconData icon;
  final String hinttext;
  InputTextCustom({
       Key? key,
       required this.controller,
       required this.hinttext,
       required this.icon,
   }): super(key:key);
   @override
   Widget build(BuildContext context) {
       return Container(
              margin: EdgeInsets.only(left: AppDimention.size20,right: AppDimention.size20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimention.size30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: AppDimention.size10,
                    spreadRadius: 7,
                    offset: Offset(1, 10),
                    color: Colors.grey.withOpacity(0.2)
                  )
                ]
              ),
              child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hinttext,
                    hintStyle: TextStyle(
                              color: Colors.black26
                            ),
                    prefixIcon: Icon(icon,color: AppColor.yellowColor,),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Colors.white
                      )
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: Colors.white
                      )
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      
                    ),
                  ),
              ),
            );
   }
}