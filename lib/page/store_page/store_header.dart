
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';

class StoreHeader extends StatefulWidget {
  const StoreHeader({Key? key}) : super(key: key);

  @override
  _StoreHeaderState createState() => _StoreHeaderState();
}

class _StoreHeaderState extends State<StoreHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        
      width: AppDimention.screenWidth,
      margin: EdgeInsets.only(top: AppDimention.size20),
      height: AppDimention.size60,
        child: Center(
          child: Text(
            "Cửa hàng",
            style: TextStyle(color: AppColor.mainColor, fontSize: 20),
          ),
        ));
  }
}
