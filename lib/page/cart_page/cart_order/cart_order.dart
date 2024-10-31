import 'dart:convert';
import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Model/CartModel.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/MomoModel.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/models/Model/ZaloModels.dart';
import 'package:flutter_user_github/page/cart_page/cart_order/cart_order_header.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class CartOrder extends StatefulWidget {
  const CartOrder({Key? key}) : super(key: key);

  @override
  _CartOrderState createState() => _CartOrderState();
}

class _CartOrderState extends State<CartOrder> {
  TextEditingController provinceController = TextEditingController();
  TextEditingController DistrictController = TextEditingController();
  TextEditingController HomenumberController = TextEditingController();
  TextEditingController StreetController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  CartController cartController = Get.find<CartController>();
  ProductController productController = Get.find<ProductController>();
  List<int> listCategoryId = [];
  
  @override
  void initState() {
    super.initState();
    cartController.getlistcartorder();
  }

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

  double calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    print("Khoảng cách: $distanceInMeters mét");
    return distanceInMeters;
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
      getCoordinatesFromAddress(address);
      List<String> listaddress = address.split(",");


      setState(() {
        HomenumberController.text = listaddress[0];
        StreetController.text = listaddress[1];
        DistrictController.text = listaddress[2];
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

  String? selectedPayment;
  List<String> paymentMethod = ["CASH", "MOMO", "ZALOPAY"];
  void onChangedPayment(String? value) {
    setState(() {
      selectedPayment = value;
    });
  }

  String? selectedVoucher;
  List<String> paymentVoucher = ["1110NVV", "2010NGVN", "2011PHVN"];
  void onChangedVoucher(String? value) {
    setState(() {
      selectedVoucher = value;
    });
  }

  bool? isload = false;
  String? announce = "";
  Future<void> _order() async {
    String paymentMethod = selectedPayment!;
    if (paymentMethod.isEmpty ||
        HomenumberController.text.isEmpty ||
        StreetController.text.isEmpty ||
        DistrictController.text.isEmpty ||
        selectedProvince!.isEmpty) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin";
      });
    } else {
      String address = HomenumberController.text +
          " " +
          StreetController.text +
          ", " +
          DistrictController.text +
          ", " +
          selectedProvince!;
      if (ischangePoint == true) {
        longitude = tappedPoint.longitude;
        latitude = tappedPoint.latitude;
      } 

      cartController.orderall(address, paymentMethod, latitude!, longitude!);
      while (cartController.ordering!) {
        await Future.delayed(const Duration(microseconds: 100));
      }
      if (!cartController.ordering!) {
        if (paymentMethod == "MOMO") {
          MomoModels momo = cartController.qrcode;
          String payUrl = momo.payUrl!;

          if (await canLaunchUrl(Uri.parse(payUrl))) {
            await launchUrl(Uri.parse(payUrl));
          } else {
            throw 'Could not launch $payUrl';
          }
        } else if (paymentMethod == "ZALOPAY") {
          ZaloData zalo = cartController.qrcodeZalo;
          String payUrl = zalo.orderurl!;
          if (await canLaunchUrl(Uri.parse(payUrl))) {
            await launchUrl(Uri.parse(payUrl));
          } else {
            throw 'Could not launch $payUrl';
          }
        }
      }
    }
  }

  double zoomValue = 14;
  MapController mapController = MapController();
  LatLng tappedPoint = LatLng(16.0471, 108.2068);
  bool? ischangePoint = false;
  bool loadlocation = false;
  FunctionMap functionmap = FunctionMap();
  void _showDropdown() async {
    if (selectedProvince == null ||
        selectedProvince!.isEmpty ||
        HomenumberController.text.isEmpty ||
        StreetController.text.isEmpty ||
        DistrictController.text.isEmpty) {
      Point mypoint = await functionmap.getCurrentLocation() as Point;
      setState(() {
        tappedPoint = LatLng(mypoint.latitude!, mypoint.longtitude!);
        loadlocation = true;
        ischangePoint = true;
        print(2);
      });
    } else {
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
        ischangePoint = true;
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
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }
  // Show list water
  void _showDialogWater(List<int> listwater) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimention.size10),
              ),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Container(
                  width: AppDimention.screenWidth,
                  height: AppDimention.size100 * 2.5,
                  padding: EdgeInsets.all(AppDimention.size10),
                  child: Column(
                    children: listwater.map((item) {
                      Productitem? productitem =
                          productController.getproductbyid(item);
                      return Container(
                          width: AppDimention.screenWidth,
                          height: AppDimention.size100,
                          padding: EdgeInsets.all(AppDimention.size10),
                          margin: EdgeInsets.only(bottom: AppDimention.size10),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10),
                              image: DecorationImage(
                                  image: MemoryImage(
                                      base64Decode(productitem!.image!)),
                                  fit: BoxFit.cover)),
                          child: Container(
                            width: AppDimention.screenWidth,
                            height: AppDimention.size100,
                            padding: EdgeInsets.all(AppDimention.size10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius:
                                  BorderRadius.circular(AppDimention.size10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${productitem!.productName!}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "đ${_formatNumber(productitem.discountedPrice != null ? productitem.discountedPrice!.toInt() : productitem.price!.toInt())}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ));
                    }).toList(),
                  ),
                );
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          CartOrderHeader(),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                GetBuilder<CartController>(builder: (cartController) {
                  if (cartController.listcartinorder.isEmpty) {
                    return Container(
                      width: AppDimention.screenWidth,
                      height: AppDimention.size170 + AppDimention.size5,
                      child: Center(
                        child: Text("Bạn không có món ăn trong giỏ hàng"),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartController.listcartinorder.length,
                      itemBuilder: (context, index) {
                        for (CartData cart in cartController
                            .listcartinorder[index].cartdata!) {
                          listCategoryId.add(cart.cartId!);
                        }
                       
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: AppDimention.screenWidth,
                            margin: EdgeInsets.only(
                              bottom: AppDimention.size10,
                            ),
                            padding: EdgeInsets.only(
                              left: AppDimention.size10,
                              right: AppDimention.size10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: AppDimention.screenWidth,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: AppDimention.screenWidth,
                                        height: AppDimention.size50,
                                        padding: EdgeInsets.only(
                                            left: AppDimention.size20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5)),
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black26))),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: AppDimention.size100 * 3.3,
                                              child: Text(
                                                cartController
                                                    .listcartinorder[index]
                                                    .storeitem!
                                                    .storeName!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: AppDimention.screenWidth,
                                        padding: EdgeInsets.only(
                                            left: AppDimention.size20),
                                        margin: EdgeInsets.only(
                                            bottom: AppDimention.size10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                        ),
                                        child: Column(
                                          children: cartController.listcartinorder[index].cartdata!.asMap().entries.map((entry) {
                                            var item = entry.value;
                                            ProductInCart? productInCart;
                                            ComboInCart? comboInCart;
                                            bool? key;
                                            if (item.type == "product") {
                                              productInCart = item.product;
                                              key = true;
                                            } else {
                                              comboInCart = item.combo;
                                              key = false;
                                            }
                                            return Container(
                                              width: AppDimention.screenWidth,
                                              padding: EdgeInsets.only(
                                                  top: AppDimention.size10,
                                                  bottom: AppDimention.size10),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.toNamed(AppRoute
                                                          .get_product_detail(
                                                              item.product!
                                                                  .productId!));
                                                    },
                                                    child: Container(
                                                      width:
                                                          AppDimention.size70,
                                                      height:
                                                          AppDimention.size70,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: const Color.fromARGB(
                                                                  22, 0, 0, 0)),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  AppDimention
                                                                      .size5),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: MemoryImage(
                                                                  base64Decode(key
                                                                      ? productInCart!
                                                                          .image!
                                                                      : comboInCart!.image!)))),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: AppDimention.size20,
                                                  ),
                                                  Container(
                                                    width:
                                                        AppDimention.size100 *
                                                            2.3,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${key ? productInCart!.productName : comboInCart!.comboName}"),
                                                        Text(
                                                            "Size : ${key ? productInCart!.size : comboInCart!.size}"),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "đ${key ? _formatNumber(productInCart!.unitPrice!.toInt()) : _formatNumber(comboInCart!.unitPrice!.toInt())}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {},
                                                                  child:
                                                                      Container(
                                                                        padding: EdgeInsets.only(left: AppDimention.size10,right: AppDimention.size10),
                                                                        height: AppDimention.size30,
                                                                        decoration: BoxDecoration(
                                                                      color: Colors.grey,
                                                                      borderRadius: BorderRadius.circular(3)
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "SL : ${key ? productInCart!.quantity : comboInCart!.quantity}",
                                                                        style: TextStyle(
                                                                            fontSize:12,color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                if(!key)
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    _showDialogWater(comboInCart!.drinkId!);
                                                                  },
                                                                  child: Container(
                                                                    margin: EdgeInsets.only(left: AppDimention.size10),
                                                                    width: AppDimention.size30,
                                                                    height: AppDimention.size30,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey,
                                                                      borderRadius: BorderRadius.circular(3)
                                                                    ),
                                                                    child: Center(
                                                                      child: Icon(Icons.coffee_sharp,size: 18,color: Colors.white,),
                                                                    ),
                                                                  )
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
                 Container(
                  width: AppDimention.screenWidth,
                 
                  padding: EdgeInsets.only(
                      left: AppDimention.size10, right: AppDimention.size10),
                  child: Text("Tổng : đ${_formatNumber(cartController.totalprice)}"),      
                
                ),
                
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(top: AppDimention.size30),
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
                    Text("Phương thức thanh toán"),
                  ],
                ),
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.white,
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
                            color: Colors.grey[100],
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
                          color: const Color.fromARGB(57, 158, 158, 158),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimention.size5),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(57, 158, 158, 158),
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
                          decoration: BoxDecoration(),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppDimention.size5),
                      border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(57, 158, 158, 158),
                      )),
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
                  child: Text(announce!),
                ),
                Container(
                  width: AppDimention.screenWidth,
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      _order();
                    },
                    child: Container(
                      width: AppDimention.size150,
                      height: AppDimention.size50,
                      margin: EdgeInsets.only(
                          top: AppDimention.size10,
                          bottom: AppDimention.size20),
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
