import 'dart:convert';

import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Dto/OrderComboDto.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentCombo extends StatefulWidget {
  final int idcombo;
  final int iddrink;
  const PaymentCombo({
    required this.idcombo,
    required this.iddrink,
    Key? key,
  }) : super(key: key);
  @override
  _PaymentComboState createState() => _PaymentComboState();
}

class _PaymentComboState extends State<PaymentCombo> {
  TextEditingController provinceController = TextEditingController();
  TextEditingController DistrictController = TextEditingController();
  TextEditingController HomenumberController = TextEditingController();
  TextEditingController StreetController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  ComboController combocontroller = Get.find<ComboController>();
  ProductController productController = Get.find<ProductController>();
  FunctionMap functionmap = FunctionMap();
  Comboitem? comboitem;
  Productitem? productitem;
  int? selectSize = 1;
  Point? currentPoint;
  bool? isLoadPoint = false;
  bool? isload = false;
  bool? haveDrink = false;
  String? selectedValue;
  int? storeid;

  String? selectedPayment;
  List<String> paymentMethod = ["CASH", "MOMO", "ZALOPAY"];
  String? selectedVoucher;
  List<String> paymentVoucher = ["1110NVV", "2010NGVN", "2011PHVN"];
  String? announce = "";

  @override
  void initState() {
    super.initState();
    loadingData();
    getCurrentPosition();
  }

  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('hh:mm').format(dateTime);
  }


  

  Future<void> getCurrentPosition() async {
    currentPoint = await functionmap.getCurrentLocation();
    setState(() {
      isLoadPoint = true;
    });
  }

  void loadingData() async {
    if (widget.iddrink != 0) {
      productitem = productController.getproductbyid(widget.iddrink);
      haveDrink = true;
    }
    comboitem = combocontroller.getcombobyId(widget.idcombo);

    setState(() {
      isload = true;
    });
  }

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

  void _getaddress() {
    User user = Get.find<UserController>().userprofile!;
    setState(() {
      String address = user.address!;
      List<String> listaddress = address.split(",");
      print(listaddress);

      setState(() {
        HomenumberController.text = listaddress[0];
        StreetController.text = listaddress[1];
        DistrictController.text = listaddress[2];
        print(listaddress[3].trim());
        String provinceFromAddress = listaddress[3].trim().toLowerCase();

        if (provinces
            .map((p) => p.toLowerCase().trim())
            .contains(provinceFromAddress)) {
          setState(() {
            selectedProvince = listaddress[3].trim();
          });
        } else {
          print("Province not found in the list.");
        }
      });
    });
  }

  void onChanged(String? value, int id) {
    setState(() {
      selectedValue = value;
      storeid = id;
    });
  }

  void onChangedPayment(String? value) {
    setState(() {
      selectedPayment = value;
      print(selectedPayment);
    });
  }

  void onChangedVoucher(String? value) {
    setState(() {
      selectedVoucher = value;
    });
  }
   double zoomValue = 14;
  MapController mapController = MapController();
  LatLng tappedPoint = LatLng(16.0471, 108.2068);
  bool loadlocation = false;

  void _showDropdown() async {
      if (selectedProvince== null || selectedProvince!.isEmpty || HomenumberController.text.isEmpty ||StreetController.text.isEmpty || DistrictController.text.isEmpty ) {
        Point mypoint = await functionmap.getCurrentLocation() as Point;
      setState(() {
        tappedPoint = LatLng(mypoint.latitude!, mypoint.longtitude!);
        loadlocation = true;
        print(2);
      });
      }
      else{
         Point addresspoint = await functionmap.getCoordinatesFromAddress(
          HomenumberController.text +
              " " +
              StreetController.text +
              ", " +
              DistrictController.text +
              ", " +
              selectedProvince!) as Point;

      setState(() {
        tappedPoint = LatLng(addresspoint.latitude!, addresspoint.longtitude!);
        loadlocation = true;
        print(1);
      });
      }
     

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size100 * 5,
            decoration: BoxDecoration(color: Colors.amber),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Stack(
                  children: [
                    loadlocation
                        ? FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              initialCenter: tappedPoint,
                              initialZoom: zoomValue,
                              onTap: (tapPosition, LatLng latlng) {
                                setState(() {
                                  tappedPoint = latlng;
                                  mapController.move(tappedPoint, zoomValue);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Tọa độ: ${latlng.latitude}, ${latlng.longitude}',
                                    ),
                                  ),
                                );
                              },
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 100.0,
                                    height: 80.0,
                                    point: tappedPoint,
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : CircularProgressIndicator(),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          mapController.move(tappedPoint, zoomValue);
                        },
                        child: Container(
                          width: AppDimention.size40,
                          height: AppDimention.size40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              border:
                                  Border.all(width: 1, color: Colors.black26)),
                          child: Center(
                            child: Icon(
                              Icons.my_location,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            mapController.move(tappedPoint, zoomValue);
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.my_location,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 10,
                        left: 10,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              zoomValue = zoomValue + 1;
                            });
                            mapController.move(tappedPoint, zoomValue);
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.zoom_out_map_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                    Positioned(
                        top: 10,
                        left: 60,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              zoomValue = zoomValue - 1;
                            });
                            mapController.move(tappedPoint, zoomValue);
                          },
                          child: Container(
                            width: AppDimention.size40,
                            height: AppDimention.size40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(AppDimention.size5),
                                border: Border.all(
                                    width: 1, color: Colors.black26)),
                            child: Center(
                              child: Icon(
                                Icons.zoom_in_map_outlined,
                                size: 20,
                              ),
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _ordercombo() async {
    if (HomenumberController.text.isEmpty ||
        DistrictController.text.isEmpty ||
        StreetController.text.isEmpty ||
        selectedProvince!.isEmpty ||
        storeid == null ||
        selectedPayment!.isEmpty) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin";
      });
    } else {
      int idcombo = comboitem!.comboId!;
      int? drinkid;
      try {
        drinkid = productitem!.productId!;
      } catch (e) {
        drinkid = null;
      }

      String address = HomenumberController.text +
        " " +
        StreetController.text +
        ", " +
        DistrictController.text +
        ", " +
       selectedProvince!;
      int storeId = storeid!;
      String paymentMethod = selectedPayment!;
      int quantity = 1;
      await Get.find<SizeController>().getbyidl(selectSize!);
      String sizename = Get.find<SizeController>().sizename;

      // String voucher = selectedVoucher != null ? selectedVoucher! : "";


      Ordercombodto dto = Ordercombodto(
          paymentMethod: paymentMethod,
          comboId: idcombo,
          drinkId: drinkid,
          storeId: storeId,
          quantity: quantity,
          size: sizename,
          deliveryAddress: address,
          latitude: tappedPoint.latitude,
          longitude: tappedPoint.longitude);
      await combocontroller.order(dto);
      if (paymentMethod == "MOMO") {
        var payUrl = combocontroller.qrcode.payUrl;
      final Uri _url = Uri.parse(payUrl!);
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            width: AppDimention.screenWidth,
            height: AppDimention.size70,
            padding: EdgeInsets.only(
                left: AppDimention.size20, right: AppDimention.size20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black26))),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: AppDimention.size25,
                  ),
                ),
                SizedBox(
                  width: AppDimention.size20,
                ),
                Text(
                  "Thanh toán đơn hàng",
                  style: TextStyle(
                    fontSize: AppDimention.size20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(top: AppDimention.size20),
                  padding: EdgeInsets.only(
                      left: AppDimention.size10, right: AppDimention.size10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sản phẩm đã chọn"),
                      isload!
                          ? Container(
                              width: AppDimention.screenWidth,
                              padding:
                                  EdgeInsets.only(top: AppDimention.size10),
                              margin: EdgeInsets.only(top: AppDimention.size10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: 1, color: Colors.black26))),
                              child: Row(
                                children: [
                                  Container(
                                    width: AppDimention.size100,
                                    height: AppDimention.size100,
                                    margin: EdgeInsets.only(
                                        right: AppDimention.size20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size5),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: AppDimention.size10,
                                              spreadRadius: 7,
                                              offset: Offset(1, 10),
                                              color:
                                                  Colors.black.withOpacity(0.2))
                                        ],
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(base64Decode(
                                                comboitem!.image!)))),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.all(AppDimention.size10),
                                    constraints: BoxConstraints(
                                      minHeight: AppDimention.size100,
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: AppDimention.size10,
                                            spreadRadius: 7,
                                            offset: Offset(1, 10),
                                            color: Colors.red.withOpacity(0.2))
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: AppDimention.size100 * 2.3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(comboitem!.comboName!),
                                              Text(comboitem!.price!
                                                      .toInt()
                                                      .toString() +
                                                  " vnđ"),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: AppDimention.size10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: comboitem!.products!
                                              .map((item) => Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 6,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            AppDimention.size10,
                                                      ),
                                                      Text(item.productName!)
                                                    ],
                                                  ))
                                              .toList(),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : CircularProgressIndicator()
                    ],
                  ),
                ),
                if (haveDrink!)
                  Container(
                    width: AppDimention.screenWidth,
                    margin: EdgeInsets.only(top: AppDimention.size60),
                    padding: EdgeInsets.only(
                        left: AppDimention.size10, right: AppDimention.size10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nước uống đã chọn"),
                        isload!
                            ? Container(
                                width: AppDimention.screenWidth,
                                padding:
                                    EdgeInsets.only(top: AppDimention.size10),
                                margin:
                                    EdgeInsets.only(top: AppDimention.size10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            width: 1, color: Colors.black26))),
                                child: Row(
                                  children: [
                                    Container(
                                      width: AppDimention.size100,
                                      height: AppDimention.size100,
                                      margin: EdgeInsets.only(
                                          right: AppDimention.size20),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppDimention.size5),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: AppDimention.size10,
                                                spreadRadius: 7,
                                                offset: Offset(1, 10),
                                                color:
                                                    Colors.red.withOpacity(0.2))
                                          ],
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: MemoryImage(base64Decode(
                                                  productitem!.image!)))),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.all(AppDimention.size10),
                                      constraints: BoxConstraints(
                                        minHeight: AppDimention.size100,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: AppDimention.size10,
                                              spreadRadius: 7,
                                              offset: Offset(1, 10),
                                              color:
                                                  Colors.red.withOpacity(0.2))
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: AppDimention.size100 * 2.3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(productitem!.productName!),
                                                Text(productitem!.price!
                                                        .toInt()
                                                        .toString() +
                                                    " vnđ"),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: AppDimention.size10,
                                          ),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Wrap(
                                                      children: List.generate(
                                                          5,
                                                          (index) => Icon(
                                                                Icons.star,
                                                                color: AppColor
                                                                    .mainColor,
                                                                size:
                                                                    AppDimention
                                                                        .size15,
                                                              )),
                                                    ),
                                                    Text(
                                                        "( ${productitem!.averageRate} )")
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: AppDimention.size10,
                                                ),
                                                GetBuilder<SizeController>(
                                                    builder: (sizecontroller) {
                                                  return Row(
                                                    children: sizecontroller
                                                        .sizelist
                                                        .map((item) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectSize =
                                                                item.id!;
                                                          });
                                                        },
                                                        child: Container(
                                                          width: AppDimention
                                                              .size25,
                                                          height: AppDimention
                                                              .size25,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: item.id ==
                                                                    selectSize
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .grey[200],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    AppDimention
                                                                        .size5),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                                item.name!),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  );
                                                }),
                                              ])
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : CircularProgressIndicator()
                      ],
                    ),
                  ),
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(top: AppDimention.size50),
                  padding: EdgeInsets.only(
                      left: AppDimention.size10, right: AppDimention.size10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: AppDimention.screenWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Địa chỉ giao hàng"),
                            GestureDetector(
                              onTap: () {
                                _getaddress();
                              },
                              child: Text(
                                "Lấy địa chỉ của bạn",
                                style: TextStyle(color: Colors.black38),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: AppDimention.screenWidth / 2.15,
                            height: AppDimention.size50,
                            padding: EdgeInsets.only(
                              left: AppDimention.size10,
                              right: AppDimention.size10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedProvince != null &&
                                      provinces.contains(selectedProvince)
                                  ? selectedProvince
                                  : null,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedProvince = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Tỉnh ...",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 13,
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: AppDimention.size15,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppDimention.size5),
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.white,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                  borderSide: BorderSide(
                                    width: 1.0,
                                    color: Colors.white,
                                  ),
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
                          Container(
                            width: AppDimention.screenWidth / 2.15,
                            height: AppDimention.size50,
                            padding: EdgeInsets.only(
                                left: AppDimention.size10,
                                right: AppDimention.size10),
                            decoration: BoxDecoration(
                                color: Colors.white, boxShadow: []),
                            child: TextField(
                              controller: DistrictController,
                              decoration: InputDecoration(
                                hintText: "Quận / huyện ...",
                                hintStyle: TextStyle(
                                    color: Colors.black26, fontSize: 13),
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
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                right: AppDimention.size10,
                                left: AppDimention.size10),
                            width: AppDimention.screenWidth / 3.8,
                            decoration: BoxDecoration(
                                color: Colors.white, boxShadow: []),
                            child: TextField(
                              controller: HomenumberController,
                              decoration: InputDecoration(
                                hintText: "Số nhà ...",
                                hintStyle: TextStyle(
                                    color: Colors.black26, fontSize: 13),
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
                                  borderRadius: BorderRadius.circular(
                                      AppDimention.size30),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                right: AppDimention.size10,
                                left: AppDimention.size10),
                            width: AppDimention.screenWidth / 1.5,
                            decoration: BoxDecoration(color: Colors.white),
                            child: TextField(
                              controller: StreetController,
                              decoration: InputDecoration(
                                hintText: "Tên đường ...",
                                hintStyle: TextStyle(
                                    color: Colors.black26, fontSize: 13),
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
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showDropdown();
                      },
                      child: Text(
                        "Gim map",
                        style: TextStyle(color: Colors.black38),
                      ),
                    ),
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                  ],
                ),
                SizedBox(
                  height: AppDimention.size15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text("Cửa hàng"),
                  ],
                ),
                isload!
                    ? Container(
                        width: AppDimention.screenWidth,
                        padding: EdgeInsets.all(AppDimention.size10),
                        decoration: BoxDecoration(),
                        child: DropdownButtonFormField(
                          dropdownColor: Colors.amber,
                          hint: Text(
                            "Chọn cửa hàng",
                            style:
                                TextStyle(color: Colors.black26, fontSize: 12),
                          ),
                          items: comboitem!.products![0].stores!.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Container(
                                width: AppDimention.size100 * 3.8,
                                margin: EdgeInsets.only(
                                    top: AppDimention.size10,
                                    bottom: AppDimention.size10),
                                padding: EdgeInsets.all(AppDimention.size10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: AppDimention.size100 * 3.8,
                                      child: Text(
                                        item.storeName!,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: AppDimention.size50,
                                              height: AppDimention.size50,
                                              // decoration: BoxDecoration(
                                              //     image: DecorationImage(
                                              //         fit: BoxFit.contain,
                                              //         image: MemoryImage(
                                              //             base64Decode(
                                              //                 item.image!)))),
                                            ),
                                            SizedBox(
                                              height: AppDimention.size10,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 10,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  "${(functionmap.calculateDistance(item.latitude!, item.longitude!, isLoadPoint! ? currentPoint!.latitude! : 0, isLoadPoint! ? currentPoint!.longtitude! : 0) / 1000).toInt()} km",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          width: AppDimention.size100 * 2.7,
                                          padding: EdgeInsets.all(
                                              AppDimention.size10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Địa chỉ :" + item.location!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                "Sđt :" +
                                                    item.numberPhone!
                                                        .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                "Thời gian : " +
                                                    formatTime(
                                                        item.openingTime!) +
                                                    " - " +
                                                    formatTime(
                                                        item.closingTime!),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            var selectedStore = value as Storesitem;
                            onChanged(selectedStore.storeName!,
                                selectedStore.storeId!);
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size5),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 1.0,
                              ),
                            ),
                          ),
                          selectedItemBuilder: (BuildContext context) {
                            return comboitem!.products![0].stores!.map((item) {
                              return Container(
                                alignment: Alignment.centerLeft,
                                height: 60,
                                width: AppDimention.size100 * 3,
                                child: Text(item.storeName!,
                                    style: TextStyle(fontSize: 16)),
                              );
                            }).toList();
                          },
                        ),
                      )
                    : CircularProgressIndicator(),
                SizedBox(
                  height: AppDimention.size15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text("Phương thức thanh toán"),
                  ],
                ),
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.amber,
                    hint: Text(
                      "Chọn phương thức thanh toán",
                      style: TextStyle(color: Colors.black26, fontSize: 12),
                    ),
                    items: paymentMethod.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Container(
                          width: AppDimention.size100 * 3.8,
                          margin: EdgeInsets.only(
                              top: AppDimention.size10,
                              bottom: AppDimention.size10),
                          padding: EdgeInsets.all(AppDimention.size10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: AppDimention.size100 * 3.8,
                                child: Text(
                                  item,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      var selectedMethod = value as String;
                      onChangedPayment(selectedMethod);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return paymentMethod.map((item) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          width: AppDimention.size100 * 3,
                          child: Text(item, style: TextStyle(fontSize: 16)),
                        );
                      }).toList();
                    },
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text("Mã giảm giá"),
                  ],
                ),
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.amber,
                    hint: Text(
                      "Chọn mã giảm giá",
                      style: TextStyle(color: Colors.black26, fontSize: 12),
                    ),
                    items: paymentVoucher.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Container(
                          width: AppDimention.size100 * 3.8,
                          margin: EdgeInsets.only(
                              top: AppDimention.size10,
                              bottom: AppDimention.size10),
                          padding: EdgeInsets.all(AppDimention.size10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            children: [
                              Container(
                                  width: AppDimention.size100 * 3.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item,
                                      ),
                                      Text("10000 vnđ")
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      var selectedMethod = value as String;
                      onChangedVoucher(selectedMethod);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return paymentVoucher.map((item) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          width: AppDimention.size100 * 3,
                          child: Text(item, style: TextStyle(fontSize: 16)),
                        );
                      }).toList();
                    },
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text("Ghi chú"),
                  ],
                ),
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.all(AppDimention.size10),
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimention.size5),
                      border: Border.all(width: 1, color: Colors.black26)),
                  child: TextField(
                    maxLines: 5,
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: ".........",
                      hintStyle: TextStyle(color: Colors.black26),
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
                Center(
                  child: Text(
                    announce!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      _ordercombo();
                    },
                    child: Container(
                      width: AppDimention.size150,
                      height: AppDimention.size50,
                      margin: EdgeInsets.only(
                          top: AppDimention.size10,
                          bottom: AppDimention.size50),
                      decoration: BoxDecoration(
                          color: AppColor.mainColor,
                          borderRadius:
                              BorderRadius.circular(AppDimention.size5)),
                      child: Center(
                        child: Text(
                          "Đặt hàng",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
