import 'dart:async';
import 'dart:convert';

import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/custom/input_text_custom.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Dto/UserUpdateDto.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
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
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  User? user;

  String? selectedProvince;
  List<String> provinces = [];
  String? selectedDistrict;
  List<String> districts = [];
  FunctionMap functionMap = FunctionMap();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadProvince();
  }

  void loadProvince() async {
    provinces = await functionMap.listProvinces();
    loadData();
    setState(() {});
  }

  void loadDistrict() async {
    while (selectedProvince == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    districts = await functionMap.listDistrict(selectedProvince!);
    setState(() {});
  }

  void loadData() async {
    while (provinces.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    user = userController.userprofile;

    emailcontroller.text = user!.email!;
    phonecontroller.text = user!.phoneNumber!;
    fullnamecontroller.text = user!.fullName!;
    List<String> listaddress = user!.address!.split("|@##@|");
    addresscontroller.text = listaddress[2];
    for (String item in provinces) {
      if (item.trim().toLowerCase() == listaddress[0].toLowerCase().trim()) {
        selectedProvince = item;
      }
    }
    loadDistrict();
    while (districts.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    for (String item in districts) {
      if (item.trim().toLowerCase() == listaddress[1].toLowerCase().trim()) {
        setState(() {
          selectedDistrict = item;
        });
      }
    }
  }

  void _changePassword() {
    String password = passwordcontroller.text;
    String newpassword = newpasswordcontroller.text;
    String repassword = repasswordcontroller.text;
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

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
      authController.changepassword(password, newpassword);
    }
    setState(() {});
  }

  void _updateProfile() {
    String? avatar = Get.find<UserController>().base64Image != null &&
            Get.find<UserController>().base64Image!.isNotEmpty
        ? Get.find<UserController>().base64Image
        : "";

    String fullName = fullnamecontroller.text;
    String address = selectedProvince.toString() +
        "|@##@|" +
        selectedDistrict.toString() +
        "|@##@|" +
        addresscontroller.text;
    String email = emailcontroller.text;
    Userupdatedto userupdatedto = Userupdatedto(
        fullName: fullName, avatar: avatar!, email: email, address: address);
    Get.find<UserController>().updateprofile(userupdatedto);
    Get.toNamed(AppRoute.PROFILE_PAGE);
  }

  void showDiaLogChangePassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool hiddenPassword = true;
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.all(10),
              child: Container(
                width: AppDimention.screenWidth,
                height: 450,
                padding: EdgeInsets.all(10),
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
                          obscureText: hiddenPassword,
                          controller: passwordcontroller,
                          decoration: InputDecoration(
                            hintText: "Mật khẩu cũ ...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hiddenPassword = !hiddenPassword;
                                });
                              },
                              child: Icon(
                                Icons.password,
                                color: AppColor.yellowColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.white)),
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
                          obscureText: hiddenPassword,
                          controller: newpasswordcontroller,
                          decoration: InputDecoration(
                            hintText: "Mật khẩu mới ...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hiddenPassword = !hiddenPassword;
                                });
                              },
                              child: Icon(
                                Icons.password,
                                color: AppColor.yellowColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.white)),
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
                          obscureText: hiddenPassword,
                          controller: repasswordcontroller,
                          decoration: InputDecoration(
                            hintText: "Xác nhận mật khẩu ...",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  hiddenPassword = !hiddenPassword;
                                });
                              },
                              child: Icon(
                                Icons.password,
                                color: AppColor.yellowColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.white)),
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
                            borderRadius:
                                BorderRadius.circular(AppDimention.size10)),
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
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image/LoadingBg.png'),
                          fit: BoxFit.cover)),
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
                                        image: Get.find<UserController>().base64Image ==null || Get.find<UserController>().base64Image == ""
                                            ? userController.userprofile?.avatar == null || userController.userprofile?.avatar ==""
                                                ? AssetImage("assets/image/avatar.jpg")
                                                : MemoryImage(base64Decode(userController.userprofile!.avatar!))
                                            : MemoryImage(base64Decode(Get.find<UserController>().base64Image!)))),
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
                  margin: EdgeInsets.only(
                      left: AppDimention.size20, right: AppDimention.size20),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        blurRadius: AppDimention.size10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2))
                  ]),
                  child: TextField(
                    controller: fullnamecontroller,
                    decoration: InputDecoration(
                      hintText: "Họ tên",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppColor.yellowColor,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
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
                ),
                SizedBox(
                  height: AppDimention.size20,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: AppDimention.size20, right: AppDimention.size20),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        blurRadius: AppDimention.size10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2))
                  ]),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColor.yellowColor,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
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
                ),
                SizedBox(
                  height: AppDimention.size20,
                ),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size60,
                  margin: EdgeInsets.only(
                    left: AppDimention.size20,
                    right: AppDimention.size20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: AppDimention.size10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedProvince,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProvince = newValue;
                        selectedDistrict = null;
                        loadDistrict();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Tỉnh",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: AppColor.yellowColor,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10),
                      ),
                    ),
                    items:
                        provinces.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size60,
                  margin: EdgeInsets.only(
                    left: AppDimention.size20,
                    right: AppDimention.size20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: AppDimention.size10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Quận / huyện",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: AppColor.yellowColor,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                        borderSide: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimention.size10),
                      ),
                    ),
                    items:
                        districts.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: AppDimention.size10,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: AppDimention.size20, right: AppDimention.size20),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        blurRadius: AppDimention.size10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2))
                  ]),
                  child: TextField(
                    controller: addresscontroller,
                    decoration: InputDecoration(
                      hintText: "Số nhà , đường ...",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.roundabout_left_outlined,
                        color: AppColor.yellowColor,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
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
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: AppDimention.size20, right: AppDimention.size20),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        blurRadius: AppDimention.size10,
                        spreadRadius: 7,
                        offset: Offset(1, 10),
                        color: Colors.grey.withOpacity(0.2))
                  ]),
                  child: TextField(
                    controller: phonecontroller,
                    decoration: InputDecoration(
                      enabled: false,
                      hintText: "Số điện thoại",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: AppColor.yellowColor,
                        size: AppDimention.size25,
                      ),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: AppDimention.size15),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.0, color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 0.0, color: Colors.transparent)),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 0, color: Colors.transparent)),
                    ),
                  ),
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
                          showDiaLogChangePassword();
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
              ],
            ),
          )),
          ProfileSettingFooter()
        ],
      ),
    );
  }
}
