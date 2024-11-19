import 'package:flutter_user_github/custom/clippath_customer.dart';
import 'package:flutter_user_github/custom/input_text_custom.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/page/register_page/register_page.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController repasswordcontroller = TextEditingController();
  bool _isHidden = true;
  bool _isvalidEmail = false;
  String announce = "";
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _sendotp() {
      var auth_controller = Get.find<AuthController>();
      String email = emailController.text.trim();
      String password = passwordcontroller.text;
      String repassword = repasswordcontroller.text;

      String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\W).{9,}$';
      RegExp regExp = RegExp(pattern);
      bool isValid = regExp.hasMatch(password);

      if (email.isEmpty || password.isEmpty || repassword.isEmpty) {
        setState(() {
          announce = "Vui lòng nhập đủ thông tin";
        });
      } else if (!isValid) {
        setState(() {
          announce =
              "Mật khẩu phải trên 8 kí tự gồm in hoa , in thường và kí tự đặc biệt";
        });
      } else {
        auth_controller.sendotp(email).then((status) {
          if (status) {
            setState(() {
              announce = "Mã xác nhận được gửi qua email của bạn gồm 6 số";
              _isvalidEmail = true;
            });
          } else {
            setState(() {
              announce = Get.find<AuthController>().getvalidatesendotp;
              _isvalidEmail = false;
            });
          }
        });
      }
    }

    void _verifyotp() {
      var auth_controller = Get.find<AuthController>();
      String otp = otpcontroller.text.trim();
      String email = emailController.text.trim();
      String password = passwordcontroller.text;
      if (otp.isEmpty) {
        announce = "Vui lòng nhập mã otp";
      } else {
        auth_controller.verifyotp(email, otp, password).then((status) {
          if (status) {
            setState(() {
              announce = "Thay đổi mật khẩu thành công";
              otpcontroller.text = "";
              emailController.text = "";
              passwordcontroller.text = "";
              repasswordcontroller.text = "";
              _isvalidEmail = false;
            });
          } else {
            setState(() {
              announce = "Mã xác nhận không chính xác";
              otpcontroller.text = "";
              _isvalidEmail = true;
            });
          }
        });
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Form login
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              top: 250,
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: AppColor.mainColor),
                    image: DecorationImage(
                        image: AssetImage('assets/image/LoadingBg.png'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    _isvalidEmail
                        ? Column(
                            children: [
                              InputTextCustom(
                                controller: otpcontroller,
                                hinttext: "Otp",
                                icon: Icons.account_tree_rounded,
                              ),
                              SizedBox(
                                height: AppDimention.size10,
                              ),
                              Container(
                                width: AppDimention.screenWidth,
                                padding: EdgeInsets.only(
                                    left: AppDimention.size20,
                                    right: AppDimention.size20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _sendotp();
                                      },
                                      child: Text("Gửi lại"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              InputTextCustom(
                                controller: emailController,
                                hinttext: "Email",
                                icon: Icons.email,
                              ),
                              SizedBox(
                                height: AppDimention.size10,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: AppDimention.size20,
                                    right: AppDimention.size20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: AppDimention.size10,
                                          spreadRadius: 7,
                                          offset: Offset(1, 10),
                                          color: Colors.grey.withOpacity(0.2))
                                    ]),
                                child: TextField(
                                  controller: passwordcontroller,
                                  obscureText: _isHidden,
                                  decoration: InputDecoration(
                                    hintText: "Mật khẩu",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    prefixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isHidden = !_isHidden;
                                        });
                                      },
                                      child: Icon(
                                        _isHidden
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColor.yellowColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size30),
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size30),
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.white)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size30),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppDimention.size10,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: AppDimention.size20,
                                    right: AppDimention.size20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        AppDimention.size30),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: AppDimention.size10,
                                          spreadRadius: 7,
                                          offset: Offset(1, 10),
                                          color: Colors.grey.withOpacity(0.2))
                                    ]),
                                child: TextField(
                                  controller: repasswordcontroller,
                                  obscureText: _isHidden,
                                  decoration: InputDecoration(
                                    hintText: "Xác nhận mật khẩu",
                                    hintStyle: TextStyle(color: Colors.black26),
                                    prefixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isHidden = !_isHidden;
                                        });
                                      },
                                      child: Icon(
                                        _isHidden
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppColor.yellowColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size30),
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.white)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size30),
                                        borderSide: BorderSide(
                                            width: 1.0, color: Colors.white)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size30),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: AppDimention.size40,
                    ),
                    Container(
                      width: AppDimention.screenWidth,
                      padding: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      child: Center(
                        child: Text(
                          announce,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppDimention.size10,
                    ),
                    if (!_isvalidEmail)
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          _sendotp();
                        },
                        child: Container(
                          width: AppDimention.screenWidth / 2,
                          height: AppDimention.screenHeight / 14,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: AppColor.mainColor),
                          child: Center(
                            child: Text(
                              "Nhận mã",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppDimention.size20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ))
                    else
                      Center(
                          child: GestureDetector(
                        onTap: () {
                          _verifyotp();
                        },
                        child: Container(
                          width: AppDimention.screenWidth / 2,
                          height: AppDimention.screenHeight / 14,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: AppColor.mainColor),
                          child: Center(
                            child: Text(
                              "Xác nhận",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppDimention.size20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                    SizedBox(
                      height: AppDimention.size40,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Bạn chưa có tài khoản ?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => RegisterPage(),
                                    transition: Transition.fade),
                              text: " Đăng kí",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: AppDimention.size10,
                    ),
                    Center(
                        child: Container(
                      width: AppDimention.screenWidth / 2,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.snackbar(
                                  "Thông báo",
                                  "Tính năng đang phát triển",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  icon: Icon(Icons.card_giftcard_sharp,
                                      color: const Color.fromARGB(255, 168, 175, 76)),
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(milliseconds: 800),
                                  isDismissible: true,
                                );
                              },
                              child: Icon(
                                Icons.facebook,
                                color: Colors.blue,
                                size: AppDimention.size40,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.snackbar(
                                  "Thông báo",
                                  "Tính năng đang phát triển",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  icon: Icon(Icons.card_giftcard_sharp,
                                      color: const Color.fromARGB(255, 168, 175, 76)),
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(milliseconds: 800),
                                  isDismissible: true,
                                );
                              },
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                                size: AppDimention.size40,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.snackbar(
                                  "Thông báo",
                                  "Tính năng đang phát triển",
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.white,
                                  colorText: Colors.black,
                                  icon: Icon(Icons.card_giftcard_sharp,
                                      color: const Color.fromARGB(255, 168, 175, 76)),
                                  borderRadius: 10,
                                  margin: EdgeInsets.all(10),
                                  duration: Duration(milliseconds: 800),
                                  isDismissible: true,
                                );
                              },
                              child: Icon(
                                Icons.phone,
                                color: Colors.yellow,
                                size: AppDimention.size40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            // LOGO
            Positioned(
              top: AppDimention.size30,
              left: AppDimention.size110,
              width: AppDimention.size170,
              height: AppDimention.size170,
              child: Container(
                child: ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 5, color: AppColor.mainColor),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/image/logo.png"),
                        )),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
