import 'package:flutter_user_github/pages/profile_page/profile_footer.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
class ShipperRegisterFinish extends StatefulWidget{
   const ShipperRegisterFinish({
       Key? key,
   }): super(key:key);
   @override
   _ShipperRegisterFinishState createState() => _ShipperRegisterFinishState();
}
class _ShipperRegisterFinishState extends State<ShipperRegisterFinish>{
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      body: Column(
        children: [
           Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: AppDimention.screenWidth,
                      height: AppDimention.screenHeight,
                      padding: EdgeInsets.all(AppDimention.size30),
                      decoration: BoxDecoration(
                        color: AppColor.mainColor
                      ),
                      child:Column(
                          children: [
                            SizedBox(height: AppDimention.size100 * 1.5,),
                             Text("Thông tin đăng kí đang chờ xác nhận",style: TextStyle(fontSize: AppDimention.size20,color: Colors.white),textAlign: TextAlign.center,),
                             SizedBox(height: AppDimention.size10,),
                             Text("Hệ thống sẽ gửi thông tin phản hồi cho bạn sau 3-5 ngày thông qua gmail đã đăng kí.",style: TextStyle(color: Colors.white),),
                             SizedBox(height: AppDimention.size40,),
                             Container(
                              width: AppDimention.size100 * 3,
                              height: AppDimention.size100 * 3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    'assets/image/logo.png'
                                  )
                                )
                              ),
                             )
                          ],
                        
                      ),
                    )
                  ],
                ),
              )
          ),
          ProfileFooter(),
        ],
      ),
    );
  }
}