import 'dart:convert';
import 'dart:io';

import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Dto/RegisterShipperDto.dart';
import 'package:flutter_user_github/page/profile_page/profile_setup_page/shipper_register/shipper_register_finish.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ShipperRegisterBody extends StatefulWidget {
  const ShipperRegisterBody({
    Key? key,
  }) : super(key: key);
  @override
  _ShipperRegisterBodyState createState() => _ShipperRegisterBodyState();
}

class _ShipperRegisterBodyState extends State<ShipperRegisterBody> {
  List<String> title = ["Thông tin", " Xác thực", "Hoàn thành"];
  int titleSelected = 0;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  TextEditingController currentProvinceController = TextEditingController();
  TextEditingController currentDistrictController = TextEditingController();
  TextEditingController currentHomeNumberController = TextEditingController();

  TextEditingController ProvinceController = TextEditingController();
  TextEditingController DistrictController = TextEditingController();
  TextEditingController HomeNumberController = TextEditingController();

  TextEditingController VehicleNumberController = TextEditingController();
  TextEditingController VehicleLicenseController = TextEditingController();
  TextEditingController VehicleStyleController = TextEditingController();

  File? _imageCCCD1;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _imageCCCD1 = imageFile;
      });
    }
  }

  File? _imageCCCD2;
  Future<void> _pickImageCCCD2() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      setState(() {
        _imageCCCD2 = imageFile;
      });
    }
  }

  bool _isChecked = false;

  String annountfirst = "";
  String annountsecond = "";
  String annountthird = "";

  bool checkValidate_first() {
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        birthdayController.text.isEmpty ||
        currentDistrictController.text.isEmpty ||
        currentDistrictController.text.isEmpty ||
        currentHomeNumberController.text.isEmpty ||
        ProvinceController.text.isEmpty ||
        DistrictController.text.isEmpty ||
        HomeNumberController.text.isEmpty) {
      setState(() {
        annountfirst = "Vui lòng nhập đủ thông tin";
      });
      return false;
    }
    return true;
  }

  bool checkValidate_second() {
    if (_imageCCCD1 == null ||
        _imageCCCD2 == null ||
        VehicleNumberController.text.isEmpty || VehicleLicenseController.text.isEmpty || VehicleStyleController.text.isEmpty) {
      setState(() {
        annountsecond = "Vui lòng nhập đủ thông tin";
      });
      return false;
    }
    return true;
  }
  Future<String> convertImageToBase64(File imageFile) async {
  List<int> imageBytes = await imageFile.readAsBytes(); 
  String base64Image = base64Encode(imageBytes); 
  return base64Image;
}
  void _register() async{
    if (!_isChecked) {
      setState(() {
        annountthird = "Vui lòng xác nhận điều khoản";
      });
    } else {
      
      String fullName =
          firstnameController.text + " " + lastnameController.text;
      String phone = phoneController.text;
      String email = emailController.text;
      String birthday = birthdayController.text;
      String currentaddress = currentHomeNumberController.text +
          " - " +
          currentDistrictController.text +
          " - " +
          currentProvinceController.text;
      String address = HomeNumberController.text +
          " - " +
          DistrictController.text +
          " - " +
          ProvinceController.text;

      String vehilclenumber = VehicleNumberController.text;
      String vehiclelicense = VehicleLicenseController.text;
      String vehiclestyle = VehicleStyleController.text;

      File? image1 = _imageCCCD1!;
      String imageFront = "";
      if (image1 != null) {
        imageFront = await convertImageToBase64(image1); 
      } else {
        print("Không có hình ảnh để chuyển đổi.");
      }
      File? image2 = _imageCCCD2!;
        String imageBack = "";
      if (image2 != null) {
         imageBack = await convertImageToBase64(image2); 
      } else {
        print("Không có hình ảnh để chuyển đổi.");
      }
    
      print(fullName);
      Registershipperdto dto = Registershipperdto(name: fullName, imageCitizenFront: imageFront, imageCitizenBack: imageBack, email: email, phone: phone, currentaddress: currentaddress, address: address, birthday: birthday, vehicle: vehiclestyle, licensePlate: vehilclenumber, DriverLicense: vehiclelicense);
      UserController userController = Get.find<UserController>();
      userController.registershipper(dto).then((status){
        if(status){
            Get.to(ShipperRegisterFinish());
        }
        else{
           Get.snackbar(
            "Thông báo",
            "Đăng kí thất bại",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.white,
            colorText: Colors.black,
            icon: Icon(Icons.warning_rounded, color: Colors.red),
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            duration: Duration(seconds: 1),
            isDismissible: true,
            
          );
        }
      }
    );

      
    }
  }

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

  List<int> listfinish = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimention.screenWidth,
      child: Column(
        children: [
          Container(
              width: AppDimention.screenWidth,
              height: AppDimention.size70,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 36,
                    left: 0,
                    child: Container(
                      width: AppDimention.screenWidth,
                      height: AppDimention.size10,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(104, 255, 193, 7),
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10)),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: AppDimention.screenWidth,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(title.length, (index) {
                              return GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Container(
                                        width: AppDimention.size50,
                                        height: AppDimention.size50,
                                        margin: EdgeInsets.only(
                                            left: AppDimention.size10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: listfinish.contains(index)
                                              ? Colors.greenAccent
                                              : Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size30),
                                        ),
                                        child: Center(
                                          child: index == titleSelected
                                              ? Icon(Icons.check_circle_outline)
                                              : listfinish.contains(index)
                                                  ? Icon(Icons.check)
                                                  : null,
                                        ),
                                      ),
                                      Text(title[index]),
                                    ],
                                  ));
                            })),
                      ))
                ],
              )),
          if (titleSelected == 0)
            Container(
              width: AppDimention.screenWidth,
              padding: EdgeInsets.all(AppDimention.size10),
              margin: EdgeInsets.only(top: AppDimention.size10),
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Họ",
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            width: AppDimention.screenWidth / 2.2,
                            height: AppDimention.size50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black26))),
                            child: TextField(
                              controller: firstnameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintStyle: TextStyle(color: Colors.black26),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tên",
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            width: AppDimention.screenWidth / 2.2,
                            height: AppDimention.size50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black26))),
                            child: TextField(
                              controller: lastnameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                hintStyle: TextStyle(color: Colors.black26),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
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
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Số điện thoại",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintStyle: TextStyle(color: Colors.black26),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Text(
                    "Địa chỉ hiện tại",
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppDimention.screenWidth / 2.1,
                            height: AppDimention.size50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black26))),
                            child: DropdownButtonFormField<String>(
                              value: provinces
                                      .contains(currentProvinceController.text)
                                  ? currentProvinceController.text
                                  : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    currentProvinceController.text = newValue;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Tỉnh",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                ),
                               
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size10),
                                ),
                              ),
                              items: provinces.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppDimention.screenWidth / 2.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black26),
                              ),
                            ),
                            child: TextField(
                              controller: currentDistrictController,
                              decoration: InputDecoration(
                                hintText: "Quận/ huyện",
                                prefixIcon:
                                    Icon(Icons.location_searching_sharp),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: TextField(
                          controller: currentHomeNumberController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on_outlined),
                            hintText: "Số nhà / đường",
                            hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Text(
                    "Quê quán",
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppDimention.screenWidth / 2.2,
                            height: AppDimention.size50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black26))),
                            child: DropdownButtonFormField<String>(
                              value: provinces.contains(ProvinceController.text)
                                  ? ProvinceController.text
                                  : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    ProvinceController.text = newValue;
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Tỉnh",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                ),
                               
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size10),
                                ),
                              ),
                              items: provinces.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: AppDimention.screenWidth / 2.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                bottom:
                                    BorderSide(width: 1, color: Colors.black26),
                              ),
                            ),
                            child: TextField(
                              controller: DistrictController,
                              decoration: InputDecoration(
                                hintText: "Quận/ huyện",
                                prefixIcon:
                                    Icon(Icons.location_searching_sharp),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 14,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: TextField(
                          controller: HomeNumberController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_on_outlined),
                            hintText: "Số nhà / đường",
                            hintStyle: TextStyle(color: Colors.black26,fontSize: 14,),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ngày sinh",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Colors.black26))),
                        child: GestureDetector(
                          onTap: () async {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                birthdayController.text =
                                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: birthdayController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.date_range),
                                hintStyle: TextStyle(color: Colors.black26),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size10,
                                  horizontal: AppDimention.size10,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                      width: 1.0, color: Colors.white),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  if (annountfirst.isNotEmpty)
                    Center(
                      child: Text(
                        annountfirst,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (checkValidate_first()) {
                           if (!listfinish.contains(titleSelected))
                          listfinish.add(titleSelected);
                          titleSelected = titleSelected + 1;
                        }
                       
                      });
                    },
                    child: Container(
                      width: AppDimention.screenWidth,
                      child: Center(
                          child: Icon(
                        Icons.arrow_circle_right_outlined,
                        size: AppDimention.size30,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                ],
              ),
            )
          else if (titleSelected == 1)
            Container(
              width: AppDimention.screenWidth,
              padding: EdgeInsets.all(AppDimention.size10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100 * 3,
                    padding: EdgeInsets.all(AppDimention.size10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mặt trước căn cước công dân"),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size100 * 2.4,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _imageCCCD1 == null
                                        ? AssetImage("assets/image/upload.png")
                                        : FileImage(_imageCCCD1!))),
                          ),
                        )
                      ],
                    ),
                  ),
                 
                  Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size100 * 3,
                    padding: EdgeInsets.all(AppDimention.size10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mặt sau căn cước công dân"),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickImageCCCD2();
                          },
                          child: Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size100 * 2.4,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _imageCCCD2 == null
                                        ? AssetImage("assets/image/upload.png")
                                        : FileImage(_imageCCCD2!))),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Biển số xe"),
                      Container(
                        width: AppDimention.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black26),
                          ),
                        ),
                        child: TextField(
                          controller: VehicleNumberController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_searching_sharp),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
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
                                  BorderRadius.circular(AppDimention.size30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(
                    height: AppDimention.size20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Loại bằng lái xe"),
                      Container(
                        width: AppDimention.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black26),
                          ),
                        ),
                        child: TextField(
                          controller: VehicleLicenseController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_searching_sharp),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
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
                                  BorderRadius.circular(AppDimention.size30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(
                    height: AppDimention.size20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Loại xe"),
                      Container(
                        width: AppDimention.screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black26),
                          ),
                        ),
                        child: TextField(
                          controller: VehicleStyleController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_searching_sharp),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: AppDimention.size10,
                              horizontal: AppDimention.size10,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 15,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size30),
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
                                  BorderRadius.circular(AppDimention.size30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  if (!annountsecond.isEmpty)
                    Center(
                      child: Text(
                        annountsecond,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              titleSelected = titleSelected - 1;
                            });
                          },
                          child: Icon(
                            Icons.arrow_circle_left_outlined,
                            size: AppDimention.size30,
                          )),
                      SizedBox(
                        width: AppDimention.size20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (checkValidate_second()) {
                              setState(() {
                                if (!listfinish.contains(titleSelected))
                                listfinish.add(titleSelected);
                                titleSelected = titleSelected + 1;
                              });
                            }
                          },
                          child: Icon(
                            Icons.arrow_circle_right_outlined,
                            size: AppDimention.size30,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                ],
              ),
            )
          else
            Container(
              width: AppDimention.screenWidth,
              padding: EdgeInsets.all(AppDimention.size10),
              child: Column(
                children: [
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Text(
                    "Điều khoản cần biết",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Điều khoản sử dụng dịch vụ",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Người dùng cần tuân thủ các quy định và chính sách của nền tảng khi sử dụng dịch vụ.Không sử dụng tài khoản vào các hoạt động bất hợp pháp hoặc vi phạm quyền lợi của bên thứ ba.Tài khoản shipper chỉ dành riêng cho mục đích giao hàng và các công việc liên quan đến dịch vụ.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trách nhiệm của shipper",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Bảo đảm tính chính xác của thông tin cá nhân cung cấp khi đăng ký.Thực hiện các đơn hàng một cách an toàn, đúng thời gian và tuân thủ các quy định về giao thông và pháp luật hiện hành. Chịu trách nhiệm về sự mất mát hoặc hư hỏng hàng hóa trong quá trình giao nhận nếu do lỗi cá nhân.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Quyền lợi của nền tảng",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Nền tảng có quyền thay đổi, bổ sung hoặc tạm dừng dịch vụ mà không cần thông báo trước. Nền tảng có thể khóa hoặc xóa tài khoản nếu phát hiện vi phạm điều khoản sử dụng, như gian lận, hành vi bất hợp pháp.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chính sách bảo mật",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Thông tin cá nhân của shipper sẽ được bảo mật theo quy định của nền tảng và chỉ được sử dụng trong phạm vi cung cấp dịch vụ. Nền tảng cam kết không chia sẻ thông tin của shipper với bên thứ ba trừ khi có yêu cầu từ cơ quan có thẩm quyền.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Chính sách thanh toán",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Quy định về mức phí hoa hồng, thời gian thanh toán và phương thức nhận tiền đối với shipper. Các khoản phí phát sinh như xăng xe, tiền ăn, tiền điện thoại đều do shipper tự chi trả.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hủy đơn hàng và phạt",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Quy định về việc hủy đơn hàng sau khi đã nhận. Phí phạt nếu shipper vi phạm các quy định như giao hàng trễ hoặc làm hư hỏng hàng hóa.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                      width: AppDimention.screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Giới hạn trách nhiệm pháp lý",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: AppDimention.size10,
                          ),
                          Text(
                            "Nền tảng không chịu trách nhiệm cho các sự cố xảy ra ngoài ý muốn hoặc do sự cố kỹ thuật khi sử dụng dịch vụ.",
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = !_isChecked;
                          });
                        },
                      ),
                      Text(
                        "Tôi đã đọc hết điều khoản",
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!annountthird.isEmpty)
                        Text(
                          annountthird,
                          style: TextStyle(color: AppColor.mainColor),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            titleSelected = titleSelected - 1;
                          });
                        },
                        child: Icon(
                          Icons.arrow_circle_left_outlined,
                          size: AppDimention.size30,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            _register();
                          },
                          child: Container(
                            width: AppDimention.size150,
                            height: AppDimention.size50,
                            decoration: BoxDecoration(
                                color: AppColor.mainColor,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5)),
                            child: Center(
                              child: Text(
                                "Đăng kí",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppDimention.size20,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
