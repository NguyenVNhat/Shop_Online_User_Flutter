import 'dart:convert';

import 'package:flutter_user_github/custom/clippath_customer.dart';
import 'package:flutter_user_github/custom/input_text_custom.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/models/Dto/UserDto.dart';
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
import 'package:http/http.dart' as http;

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
  final CaptchaController _captchaController = CaptchaController(length: 6);
  final TextEditingController capchaController = TextEditingController();
  bool page = true;

  String announce = "";

  String? selectedProvince;
  List<String> provinces = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Hải Phòng',
    'Cần Thơ',
    'Nghệ An',
    'Thanh Hóa',
    'Đồng Nai',
    'Bình Dương',
    'Khánh Hòa',
    'Thừa Thiên Huế',
    'An Giang',
    'Bà Rịa-Vũng Tàu',
    'Bắc Ninh',
    'Nam Định',
    'Vĩnh Long',
    'Bắc Giang',
    'Hưng Yên',
    'Hà Nam',
    'Quảng Ninh',
    'Đắk Lắk',
    'Gia Lai',
    'Ninh Bình',
    ' Hà Tĩnh',
    'Quảng Nam',
    'Thái Bình',
    'Kiên Giang',
    'Sóc Trăng',
    'Lâm Đồng',
    'Tây Ninh',
    'Bến Tre',
    'Long An',
    'Bình Thuận',
    'Hòa Bình',
    'Lạng Sơn',
    'Yên Bái',
    'Cao Bằng',
    'Điện Biên',
    'Lào Cai',
    'Sơn La',
    'Tuyên Quang',
    'Thái Nguyên',
    'Hà Giang',
    'Quảng Trị',
    'Kon Tum',
    'Ninh Thuận',
    'Bắc Kạn',
    'Hà Tĩnh',
    'Đắk Nông',
    'Hải Dương',
    'Hưng Yên',
    'Phú Thọ',
    'Vĩnh Phúc',
    'Nam Định',
    'Thái Bình',
    'Bắc Giang',
    'Đồng Tháp',
    'Hậu Giang',
    'Trà Vinh',
    'Bạc Liêu',
    'Cà Mau',
  ];
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

  @override
  Widget build(BuildContext context) {
    void _register() async{
      String keycapcha = _captchaController.value;
      String fillcapcha = capchaController.text;
      if(keycapcha != fillcapcha){
          setState(() {
             _captchaController.changeCaptcha();
            announce = "Mã xác nhận không chính xác";
            
          });
      }
      else{
        var auth_controller = Get.find<AuthController>();
        String fullname = fullnameController.text.trim();
        String password = passwordController.text.trim();
        String repassword = repasswordController.text.trim();
        String phonenumber = phoneNumberController.text.trim();
        String email = emailController.text.trim();
        String address = selectedProvince.toString() +", "+district.text+", "+homenumber.text;

        String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\W).{9,}$';
        RegExp regExp = RegExp(pattern);
        bool isValid = regExp.hasMatch(password);

        if (fullname.isEmpty || password.isEmpty || repassword.isEmpty || phonenumber.isEmpty || email.isEmpty || selectedProvince.toString().isEmpty || district.text.isEmpty || homenumber.text.isEmpty ) {
          setState(() {
            announce = "Vui lòng nhập đủ thông tin";
          });
        }
        else if( password != repassword){
          setState(() {
            announce = "Mật khẩu xác nhận chưa chính xác ";
          });
        } 
        else if(!isValid){
          setState(() {
            announce = "Mật khẩu phải hơn 8 kí tự. Có in hoa, in thường, kí tự đặc biệt";
          });
        }
        else {
          if(!await getCoordinatesFromAddress(address)){
            setState(() {
            announce = "Địa chỉ không chính xác";
          });
          }
          else{
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
    }

    return Scaffold(
        body: Stack(
      children: [
        // Background blue
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: AppDimention.size380,
          child: ClipPath(
            clipper: ClippathCustomer(
              svgPath:
                  "M1.97472e-05 -18.394H392.162C392.162 -18.394 451.502 274.651 384.001 194.575C316.5 114.5 6.41783e-05 577.567 1.97472e-05 194.575C-2.4684e-05 -188.416 1.97472e-05 -18.394 1.97472e-05 -18.394Z",
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.mainColor,
              ),
            ),
          ),
        ),
        // Background blue
        Positioned(
          bottom: 0,
          left: 0,
          right: -1,
          height: AppDimention.size320,
          child: ClipPath(
            clipper: ClippathCustomer(
              svgPath:
                  "M0 75.0047C197.38 292.88 367.66 -173.226 407 75.0047V320H0V75.0047Z",
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.mainColor,
              ),
            ),
          ),
        ),
        // Form login
        Positioned(
          left: AppDimention.size20,
          top: AppDimention.size110,
          width: AppDimention.size310 + AppDimention.size40,
          height: AppDimention.size630,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: AppColor.mainColor),
            ),
            child: Column(
              children: [
                 SizedBox(
                      height: AppDimention.size110,
                    ),
                page ? Column(
                  children: [
                   
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AppColor.yellowColor,
                            size: AppDimention.size25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size15),
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
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColor.yellowColor,
                            size: AppDimention.size25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size15),
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
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppColor.yellowColor,
                            size: AppDimention.size25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size15),
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
                    Row(
                      children: [
                        Container(
                          width: AppDimention.screenWidth / 2.4,
                          height: AppDimention.size50,
                          margin: EdgeInsets.only(
                            left: AppDimention.size20,
                            right: AppDimention.size10,
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
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Tỉnh",
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 13),
                              prefixIcon: Icon(
                                Icons.location_city,
                                color: AppColor.yellowColor,
                                size: AppDimention.size25,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                borderSide:
                                    BorderSide(width: 1.0, color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                                borderSide:
                                    BorderSide(width: 1.0, color: Colors.white),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size10),
                              ),
                            ),
                            items: provinces
                                .map<DropdownMenuItem<String>>((String value) {
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
                        Container(
                          width: AppDimention.screenWidth / 2.9,
                          height: AppDimention.size50,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                blurRadius: AppDimention.size10,
                                spreadRadius: 7,
                                offset: Offset(1, 10),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                          child: TextField(
                            controller: district,
                            decoration: InputDecoration(
                              hintText: "Quận / huyện",
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 13),
                              prefixIcon: Icon(
                                Icons.location_city,
                                color: AppColor.yellowColor,
                                size: AppDimention.size25,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size15),
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
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size30),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: AppDimention.size20,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
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
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.roundabout_left_outlined,
                            color: AppColor.yellowColor,
                            size: AppDimention.size25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size15),
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
                  ],
                ): Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            blurRadius: AppDimention.size10,
                            spreadRadius: 7,
                            offset: Offset(1, 10),
                            color: Colors.grey.withOpacity(0.2))
                      ]),
                      child: TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Mật khẩu",
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.visibility_outlined,
                            color: AppColor.yellowColor,
                            size: AppDimention.size25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size15),
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
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            blurRadius: AppDimention.size10,
                            spreadRadius: 7,
                            offset: Offset(1, 10),
                            color: Colors.grey.withOpacity(0.2))
                      ]),
                      child: TextField(
                        controller: repasswordController,
                        decoration: InputDecoration(
                          hintText: "Xác nhận mật khẩu",
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 13),
                          prefixIcon: Icon(
                            Icons.visibility_outlined,
                            color: AppColor.yellowColor,
                            size: AppDimention.size25,
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size15),
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
                    SizedBox(height: AppDimention.size20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            width: AppDimention.size150,
                            margin: EdgeInsets.only(
                                left: AppDimention.size20,
                                right: AppDimention.size20),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  blurRadius: AppDimention.size10,
                                  spreadRadius: 7,
                                  offset: Offset(1, 10),
                                  color: Colors.grey.withOpacity(0.2))
                            ]),
                            child: TextField(
                              controller: capchaController,
                              decoration: InputDecoration(
                                hintText: "Capcha",
                                hintStyle:
                                    TextStyle(color: Colors.black26, fontSize: 13),
                                prefixIcon: Icon(
                                  Icons.visibility_outlined,
                                  color: AppColor.yellowColor,
                                  size: AppDimention.size25,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: AppDimention.size15),
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
                        Container(
                          width: AppDimention.size110,
                          height: AppDimention.size50,
                          decoration: BoxDecoration(
                            color: Colors.black26
                          ),
                          child: Captcha(
                            fontSize: 20,
                            controller: _captchaController,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _captchaController.changeCaptcha();
                            });
                          },
                          child: Container(
                            width: AppDimention.size50,
                            height: AppDimention.size50,
                            child: Center(
                              child: Icon(Icons.refresh),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimention.size20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          page = true;
                        });
                      },
                      child: Icon(
                        Icons.circle,
                        size: 15,
                        color: page ? AppColor.mainColor : Colors.grey[500],
                      ),
                    ),
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          page = false;
                        });
                      },
                      child: Icon(
                        Icons.circle,
                        size: 15,
                        color: !page ? AppColor.mainColor : Colors.grey[500],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: AppDimention.size20,
                ),
                 Container(
                  width: AppDimention.size290,
                  child: Center(
                    child: Text(announce,style: TextStyle(color: Colors.red,),textAlign: TextAlign.center,),
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
                        border: Border.all(width: 1, color: AppColor.mainColor),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _register();
                        },
                        child: Center(
                          child: Text(
                            "Đăng kí",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: AppDimention.size20,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  height: AppDimention.size20,
                ),
                
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
        ),
        Positioned(
            top: 112,
            left: 48,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.LOGIN_PAGE);
              },
              child: Icon(
                Icons.arrow_circle_left,
                color: AppColor.mainColor,
                size: 40,
              ),
            ))
      ],
    ));
  }
}
