import 'package:flutter/material.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/models/Dto/UserDto.dart';
import 'package:flutter_user_github/pages/login_page/component/login_textfield.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  String announce = "";
  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _login() {
      var auth_controller = Get.find<AuthController>();
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      if (username.isEmpty && !password.isEmpty) {
        setState(() {
          announce = "Vui lòng nhập số điện thoại";
        });
      } else if (password.isEmpty && !username.isEmpty) {
        setState(() {
          announce = "Vui lòng nhập mật khẩu";
        });
      } else if (username.isEmpty && password.isEmpty) {
        setState(() {
          announce = "Vui lòng nhập đầy đủ thông tin";
        });
      } else {
        Userdto userdto = Userdto(password: password, username: username);
        auth_controller.login(userdto).then((status) {
          if (status) {
            Get.toNamed(AppRoute.HOME_PAGE);
          } else {
            setState(() {
              announce = Get.find<AuthController>().getvalidateLogin;
            });
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              width: AppDimention.screenWidth,
              height: AppDimention.screenHeight * 0.35,
              child: Center(
                child: Container(
                  width: AppDimention.size100 * 2.5,
                  height: (AppDimention.screenHeight * 0.4) * 0.8,
                  child: Column(
                    children: [
                      Container(
                        width: (AppDimention.screenHeight * 0.4) * 0.8 * 0.65,
                        height: (AppDimention.screenHeight * 0.4) * 0.8 * 0.65,
                        margin: EdgeInsets.only(bottom: AppDimention.size10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: AppDimention.size10,
                                  spreadRadius: 7,
                                  offset: Offset(1, 10),
                                  color: Colors.red.withOpacity(0.2))
                            ],
                            borderRadius:
                                BorderRadius.circular(AppDimention.size100),
                            image: DecorationImage(
                                image: AssetImage("assets/image/logo.png"))),
                      ),
                      Text(
                        "Welcome to our",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "F-FUS",
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColor.mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            LoginTextfield(
              controller: usernameController,
              title: "Số điện thoại",
              type: 1,
            ),
            SizedBox(
              height: AppDimention.size20,
            ),
            LoginTextfield(
              controller: passwordController,
              title: "Mật khẩu",
              type: 2,
            ),
            Container(
              width: AppDimention.screenWidth,
              padding: EdgeInsets.all(AppDimention.size20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: AppDimention.size10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoute.FORGET_PASSWORD_PAGE);
                    },
                    child: Text("Quên mật khẩu ?"),
                  )
                ],
              ),
            ),
            if (announce != "")
              Column(
                children: [
                  Center(
                    child: Text(
                      announce,
                      style: TextStyle(color: AppColor.mainColor),
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  )
                ],
              ),
            Container(
              width: AppDimention.screenWidth,
              padding: EdgeInsets.only(
                  left: AppDimention.size20, right: AppDimention.size20),
              child: Center(
                  child: GestureDetector(
                onTap: () {
                  _login();
                },
                child: Container(
                  width: AppDimention.size150,
                  height: AppDimention.size50,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColor.mainColor),
                      borderRadius: BorderRadius.circular(AppDimention.size10)),
                  child: Center(
                    child: Text(
                      "Đăng nhập",
                      style: TextStyle(color: AppColor.mainColor),
                    ),
                  ),
                ),
              )),
            ),
            Container(
              width: AppDimention.screenWidth,
              padding: EdgeInsets.all(AppDimention.size20),
              child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                Container(
                  width: AppDimention.size150,
                  height: AppDimention.size50,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(AppDimention.size10)),
                  child: Center(
                    child: Text(
                      "Google",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: AppDimention.size150,
                  height: AppDimention.size50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                      
                      borderRadius: BorderRadius.circular(AppDimention.size10)),
                  child: Center(
                    child: Text(
                      "Facebook",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ])),
            ),
            Container(
              width: AppDimention.screenWidth,
              child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bạn chưa có tài khoản ? "),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoute.REGISTER_PAGE);
                    },
                    child: Text("Đăng kí",style: TextStyle(fontWeight: FontWeight.w500),),
                  )
                ],
              ),
            ),
            )
          ],
        ));
  }
}
