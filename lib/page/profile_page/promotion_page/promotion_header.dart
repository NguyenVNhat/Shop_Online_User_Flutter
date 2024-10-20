
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromotionHeader extends StatefulWidget {
  const PromotionHeader({
    Key? key,
  }) : super(key: key);
  @override
  _PromotionHeaderState createState() => _PromotionHeaderState();
}

class _PromotionHeaderState extends State<PromotionHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimention.screenWidth,
      height: AppDimention.size70,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Colors.black26))
      ),
      child: Row(
        
        children: [
          SizedBox(width: AppDimention.size10,),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              size: AppDimention.size20,
              color: Colors.black,
            ),
          ),
         Container(
          width: AppDimention.size100 * 3.5,
          child: Center(
            child:  Text("Khuyến mãi",
              style: TextStyle(
                  fontSize: AppDimention.size25,
                  color: Colors.black,
            )),
          ),
         )
         
        ],
      ),
    );
  }
}
