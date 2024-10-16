import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';

class OrderHeader extends StatefulWidget {
  const OrderHeader({
    Key? key,
  }) : super(key: key);
  @override
  _OrderHeaderState createState() => _OrderHeaderState();
}

class _OrderHeaderState extends State<OrderHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        
      width: AppDimention.screenWidth,
      margin: EdgeInsets.only(top: AppDimention.size20),
      height: AppDimention.size60,
        child: Center(
          child: Text(
            "Đơn hàng của bạn",
            style: TextStyle(color: AppColor.mainColor, fontSize: 20),
          ),
        ));
  }
}
