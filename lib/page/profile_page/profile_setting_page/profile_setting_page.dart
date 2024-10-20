import 'dart:async';
import 'dart:convert';


import 'package:flutter_user_github/custom/input_text_custom.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Dto/UserUpdateDto.dart';
import 'package:flutter_user_github/page/profile_page/profile_setting_page/profile_setting_footer.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({
    Key? key,
  }) : super(key: key);
  @override
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  TextEditingController fullnamecontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();

  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController newpasswordcontroller = TextEditingController();
  TextEditingController repasswordcontroller = TextEditingController();
  bool _showFormChangePassword = false;
  bool _showValidateChangePasswordForm = false;
  String _validateChangePasswordValue = "";


  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static const LatLng sourceLocation = LatLng(105.83416, 21.027763);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  final Set<Polyline> _polylines = {};
  void _changePassword() {
    String password = passwordcontroller.text;
    String newpassword = newpasswordcontroller.text;
    String repassword = repasswordcontroller.text;
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    setState(() {
      if (password == "" || newpassword == "" || repassword == "") {
        _validateChangePasswordValue = "Vui lòng nhập đủ thông tin";
        _showValidateChangePasswordForm = true;
      } else if (newpassword.length < 8) {
        _validateChangePasswordValue = "Mật khẩu không ít hơn 8 kí tự";
        _showValidateChangePasswordForm = true;
      } else if (!passwordRegExp.hasMatch(newpassword)) {
        _validateChangePasswordValue =
            "Mật khẩu phải chứa ít nhất một ký tự viết thường, viết hoa, số và ký tự đặc biệt";
        _showValidateChangePasswordForm = true;
      } else if (newpassword != repassword) {
        _validateChangePasswordValue = "Mật khẩu không trùng khớp";
        _showValidateChangePasswordForm = true;
      } else {
        _validateChangePasswordValue = "";
        _showValidateChangePasswordForm = false;
      }
    });
  }

  void _updateProfile() {
    String? avatar = Get.find<UserController>().base64Image != null &&
            Get.find<UserController>().base64Image!.isNotEmpty
        ? Get.find<UserController>().base64Image
        : "";

    String fullName = fullnamecontroller.text;
    String address = addresscontroller.text;
    String email = emailcontroller.text;
    Userupdatedto userupdatedto = Userupdatedto(
        fullName: fullName, avatar: avatar!, email: email, address: address);
    Get.find<UserController>().updateprofile(userupdatedto);
  }

  void _showDropdown() {
    LatLng dynamicLocation = destination;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bản đồ"),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
              initialCameraPosition: CameraPosition(
                target: dynamicLocation,
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: MarkerId("source"),
                  position: dynamicLocation,
                ),
              },
              polylines: _polylines,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Đóng"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      fullnamecontroller.text = userController.userprofile!.fullName!;
      addresscontroller.text = userController.userprofile!.address!;
      emailcontroller.text = userController.userprofile!.email!;
      phonecontroller.text = userController.userprofile!.phoneNumber!;

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
                    height: AppDimention.size220,
                    decoration: BoxDecoration(color: Colors.grey[400]),
                    child: Column(
                      children: [
                        Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size130,
                          margin: EdgeInsets.only(top: AppDimention.size30),
                          child: Stack(
                            children: [
                              Positioned(
                                  child: Center(
                                child: Container(
                                  width: AppDimention.size130,
                                  height: AppDimention.size130,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size100),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:userController.userprofile?.avatar == null ||  userController.userprofile?.avatar == "" ? AssetImage("assets/image/default_avatar.jpg") : MemoryImage(base64Decode(userController.userprofile!.avatar!) ) )),
                                ),
                              )),
                              Positioned(
                                bottom: 0,
                                left: AppDimention.screenWidth / 2 +
                                    AppDimention.size20,
                                child: Container(
                                  width: AppDimention.size30,
                                  height: AppDimention.size30,
                                  child: Center(
                                      child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoute.PROFILE_CAMERA_PAGE);
                                    },
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: AppDimention.size30,
                                    ),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: AppDimention.size5,
                        ),
                        Container(
                          width: AppDimention.screenWidth,
                          child: Center(
                            child: Text(
                              userController.userprofile!.fullName!,
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size60,
                    child: Center(
                      child: InputTextCustom(
                        controller: fullnamecontroller,
                        hinttext: "Full name ...",
                        icon: Icons.person,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size60,
                    child: Center(
                      child: InputTextCustom(
                        controller: emailcontroller,
                        hinttext: "Email ...",
                        icon: Icons.email,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size60,
                    child: Center(
                        child: Container(
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppDimention.size30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: AppDimention.size10,
                                spreadRadius: 7,
                                offset: Offset(1, 10),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: TextField(
                        controller: addresscontroller,
                        decoration: InputDecoration(
                          hintText: "Địa chỉ ...",
                          prefixIcon: IconButton(
                              onPressed: () {
                                _showDropdown();
                              },
                              icon: Icon(
                                Icons.location_on,
                                color: AppColor.yellowColor,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                              borderSide:
                                  BorderSide(width: 1.0, color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                              borderSide:
                                  BorderSide(width: 1.0, color: Colors.white)),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimention.size30),
                          ),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size60,
                    child: Center(
                        child: Container(
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(AppDimention.size30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: AppDimention.size10,
                                spreadRadius: 7,
                                offset: Offset(1, 10),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: TextField(
                        controller: phonecontroller,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Số điện thoại ...",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColor.yellowColor,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                              borderSide:
                                  BorderSide(width: 1.0, color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
                              borderSide:
                                  BorderSide(width: 1.0, color: Colors.white)),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimention.size30),
                          ),
                        ),
                      ),
                    )),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showFormChangePassword =
                                  !_showFormChangePassword;
                            });
                          },
                          child: Text("Đổi mật khẩu"),
                        ),
                        GestureDetector(
                          onTap: () {
                            _updateProfile();
                          },
                          child: Text("Lưu thay đổi"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  if (_showFormChangePassword == true)
                    Container(
                      width: AppDimention.screenWidth,
                      height: AppDimention.size170 * 2 + AppDimention.size60,
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: AppDimention.size20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: AppDimention.size30),
                            child: Text("Mật khẩu cũ"),
                          ),
                          Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size60,
                            child: Center(
                                child: Container(
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
                                decoration: InputDecoration(
                                  hintText: "Mật khẩu cũ ...",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: AppColor.yellowColor,
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
                            )),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: AppDimention.size30),
                            child: Text("Mật khẩu mới"),
                          ),
                          Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size60,
                            child: Center(
                                child: Container(
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
                                controller: newpasswordcontroller,
                                decoration: InputDecoration(
                                  hintText: "Mật khẩu mới ...",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: AppColor.yellowColor,
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
                            )),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: AppDimention.size30),
                            child: Text("Xác nhận mật khẩu mới"),
                          ),
                          Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size60,
                            child: Center(
                                child: Container(
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
                                decoration: InputDecoration(
                                  hintText: "Xác nhận mật khẩu ...",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  prefixIcon: Icon(
                                    Icons.commit_sharp,
                                    color: AppColor.yellowColor,
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
                            )),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          if (_showValidateChangePasswordForm)
                            Container(
                              width: AppDimention.screenWidth,
                              margin: EdgeInsets.only(
                                left: AppDimention.size20,
                              ),
                              child: Center(
                                child: Text(
                                  _validateChangePasswordValue,
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ),
                          SizedBox(
                            height: AppDimention.size20,
                          ),
                          Center(
                              child: GestureDetector(
                            onTap: () {
                              _changePassword();
                            },
                            child: Container(
                              width: AppDimention.size130,
                              height: AppDimention.size40,
                              decoration: BoxDecoration(
                                  color: AppColor.mainColor,
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size10)),
                              child: Center(
                                child: Text(
                                  "Đổi mật khẩu",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                ],
              ),
            )),
            ProfileSettingFooter()
          ],
        ),
      );
    });
  }
}
