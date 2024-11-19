import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/custom/clippath_customer.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/models/Dto/UserRegisterDto.dart';

import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:clean_captcha/clean_captcha.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController homenumber = TextEditingController();
  bool page = true;

  String announce = "";

  String? selectedProvince;
  List<String> provinces = [];
  String? selectedDistrict;
  List<String> districts = [];
  bool? isHidden = true;

  double? latitude;
  double? longitude;
  Future<bool> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        });
        print('Latitude: $latitude, Longitude: $longitude');
        return true;
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  FunctionMap functionMap = FunctionMap();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProvince();
  }

  void loadProvince() async {
    provinces = await functionMap.listProvinces();
    setState(() {});
  }

  void loadDistrict() async {
    while(selectedProvince == null){
      await Future.delayed(const Duration(milliseconds: 50));
    }
    
    districts = await functionMap.listDistrict(selectedProvince!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _register() async {
      var auth_controller = Get.find<AuthController>();
      String fullname = fullnameController.text.trim();
      String password = passwordController.text.trim();
      String repassword = repasswordController.text.trim();
      String phonenumber = phoneNumberController.text.trim();
      String email = emailController.text.trim();
      String address = selectedProvince.toString() +
          "|@##@|"+
          selectedDistrict.toString() +
          "|@##@|" +
          homenumber.text;

      String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\W).{9,}$';
      RegExp regExp = RegExp(pattern);
      bool isValid = regExp.hasMatch(password);

      if (fullname.isEmpty ||
          password.isEmpty ||
          repassword.isEmpty ||
          phonenumber.isEmpty ||
          email.isEmpty ||
          selectedProvince.toString().isEmpty ||
          selectedDistrict.toString().isEmpty ||
          homenumber.text.isEmpty) {
        setState(() {
          announce = "Vui lòng nhập đủ thông tin";
        });
      } else if (password != repassword) {
        setState(() {
          announce = "Mật khẩu xác nhận chưa chính xác ";
        });
      } else if (!isValid) {
        setState(() {
          announce =
              "Mật khẩu phải hơn 8 kí tự. Có in hoa, in thường, kí tự đặc biệt";
        });
      } else {
        if (!await getCoordinatesFromAddress(address)) {
          setState(() {
            announce = "Địa chỉ không chính xác";
          });
        } else {
          Userregisterdto userdto = Userregisterdto(
              fullname: fullname,
              password: password,
              phonenumber: phonenumber,
              email: email,
              latitude: latitude!,
              longtitude: longitude!,
              address: address);
          auth_controller.register(userdto).then((status) {
            if (status) {
              setState(() {
                announce = "Đăng kí thành công";
              });
            } else {
              setState(() {
                announce = Get.find<AuthController>().getvalidateRegister;
              });
            }
          });
        }
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        
        body: Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/image/LoadingBg.png'),fit: BoxFit.cover)
          ),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                width: Get.width,
                height: 100,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back,color: Colors.white,),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        "Đăng kí",
                        style: TextStyle(
                          color: Colors.white,
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ))
                  ],
                ),
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
                  controller: phoneNumberController,
                  decoration: InputDecoration(
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
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
                  controller: fullnameController,
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
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
                  controller: emailController,
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppDimention.size20,
              ),
              Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size50,
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size10),
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
                height: 20,
              ),
              Container(
                width: AppDimention.screenWidth,
                height: AppDimention.size50,
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                      borderSide: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimention.size10),
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
                  controller: homenumber,
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
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
                  controller: passwordController,
                  obscureText: isHidden!,
                  decoration: InputDecoration(
                    hintText: "Mật khẩu",
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                    prefixIcon:GestureDetector(
                      onTap: (){
                        setState(() {
                          isHidden = !isHidden!;
                        });
                      },
                      child:  Icon(
                      Icons.visibility_outlined,
                      color: AppColor.yellowColor,
                      size: AppDimention.size25,
                    ),
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
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
                  controller: repasswordController,
                  obscureText: isHidden!,
                  decoration: InputDecoration(
                    hintText: "Xác nhận mật khẩu",
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 13),
                    prefixIcon: GestureDetector(
                      onTap: (){
                        setState(() {
                          isHidden = !isHidden!;
                        });
                      },
                      child: Icon(
                      Icons.visibility_outlined,
                      color: AppColor.yellowColor,
                      size: AppDimention.size25,
                    ),
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
                      borderRadius: BorderRadius.circular(AppDimention.size30),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppDimention.size20,
              ),
              Container(
                  width: AppDimention.size290,
                  child: Center(
                    child: Text(
                      announce,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 202, 189),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              SizedBox(
                height: AppDimention.size20,
              ),
              Center(
                child: Container(
                    width: AppDimention.screenWidth / 2.6,
                    height: AppDimention.screenHeight / 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: const Color.fromARGB(255, 255, 202, 189),),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _register();
                      },
                      child: Center(
                        child: Text(
                          "Đăng kí",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppDimention.size20,
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          )),
        ));
  }
}
