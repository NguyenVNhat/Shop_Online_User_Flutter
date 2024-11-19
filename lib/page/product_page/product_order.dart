import 'package:flutter_user_github/blocs/QuantityBlocs.dart';
import 'package:flutter_user_github/blocs/SizeBlocs.dart';
import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Dto/OrderProductDto.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/models/Model/ZaloModels.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:async';

class ProductOrder extends StatefulWidget {
  final int idproduct;
  final int quantity;
  final String size;
  const ProductOrder({
    required this.idproduct,
    required this.quantity,
    required this.size,
    Key? key,
  }) : super(key: key);
  @override
  _ProductOrderState createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {
  TextEditingController provinceController = TextEditingController();
  TextEditingController DistrictController = TextEditingController();
  TextEditingController HomenumberController = TextEditingController();
  TextEditingController StreetController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController searchRecommend = TextEditingController();

  ProductController productController = Get.find<ProductController>();
  PromotionController promotionController = Get.find<PromotionController>();
  UserController userController = Get.find<UserController>();
  MapController mapController = MapController();
  LatLng tappedPoint = LatLng(16.0471, 108.2068);
  FunctionMap functionmap = FunctionMap();

  List<String> listprovince = [];
  String? selectedVoucherStr;
  String? size;
  String? selectedProvince;
  String? selectedPayment;
  String? announce = "";
  double percentSelected = 0;
  double? longitude;
  double? latitude;
  double zoomValue = 14;
  bool isChangePoint = false;
  bool? isLoadPoint = false;
  bool loadlocation = false;
  int? selectedSize = 1;
  int? quantity;
  int? storeid;
  Point? currentPoint;
  Productitem? productitem;
  QuantityBloc quantityBloc = QuantityBloc();
  Sizeblocs sizeblocs = Sizeblocs();

  bool? loading = false;
  List<String> provinces = [];
  String? selectedDistrict;
  List<String> districts = [];
  FunctionMap functionMap = FunctionMap();

  @override
  void initState() {
    super.initState();
    
    quantityBloc.setQuantity(widget.quantity);
    sizeblocs.setSizeStr(widget.size);
    getCurrentPosition();
    loadData();
    loadProvince();
  }
  void loadProvince() async {
    provinces = await functionMap.listProvinces();
    setState(() {});
  }

  void loadDistrict() async {
    while (selectedProvince == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    districts = await functionMap.listDistrict(selectedProvince!);
    setState(() {});
  }
  
  void _getaddress() async {
    while (provinces.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    User user = Get.find<UserController>().userprofile!;
    List<String> listaddress = user.address!.split("|@##@|");
    getCoordinatesFromAddress(
        listaddress[2] + ", " + listaddress[1] + ", " + listaddress[0]);
    print(listaddress[2] + ", " + listaddress[1] + ", " + listaddress[0]);
    HomenumberController.text = listaddress[2];
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
        selectedDistrict = item;
      }
    }
  }

  // Load data of product selected to order
  void loadData()  async{
    loading = true;
    size = widget.size;
    quantity = widget.quantity;
    listprovince = await functionmap.listProvinces();
    promotionController.getbyUser();
    productitem = productController.getproductbyid(widget.idproduct);
    loading = false;
    setState(() {
      
    });
  }

  String formatTime(String isoDateTime) {
    DateTime dateTime = DateTime.parse(isoDateTime);
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  // Get current position of user
  Future<void> getCurrentPosition() async {
    currentPoint = await functionmap.getCurrentLocation();
    setState(() {
      isLoadPoint = true;
    });
  }

  // Format price of product
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  // Select store of product
  void onChanged(String? value, int id) {
    promotionController.getbystoreid(id);
    setState(() {
      storeid = id;
    });
  }

  // Select payment method of order
  List<String> paymentMethod = ["CASH", "MOMO", "ZALOPAY"];
  void onChangedPayment(String? value) {
    setState(() {
      selectedPayment = value;
    });
  }

  // Select voucher of product
  void onChangedVoucher(double percentPromotion, String promotionCode) {
    setState(() {
      selectedVoucherStr = promotionCode;
      percentSelected = percentPromotion;
    });
  }

  // Get coordinate from address of user
  Future<bool> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        print(locations.first);
        setState(() {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        });
        return true;
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  // Order function
  void _order() async {
    if (HomenumberController.text.isEmpty ||
        selectedDistrict == null ||
        selectedProvince == null ||
        storeid == null ||
        selectedPayment!.isEmpty) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin";
      });
    } else {
      setState(() {
        announce = "";
      });
      int productid = productitem!.productId!;
      String sizeOrder = size!;
      int quantityOrder = quantityBloc.getQuantity();
      int storeId = storeid!;
      String promotionCode = "";
     String address = selectedProvince.toString() + ", " +  selectedDistrict.toString() +", " + HomenumberController.text;
      if (selectedVoucherStr != null) {
        promotionCode = selectedVoucherStr!;
      }
      if (isChangePoint) {
        longitude = tappedPoint.longitude;
        latitude = tappedPoint.latitude;
      }
      Orderproductdto dto ;
      if(promotionCode != ""){
          dto = Orderproductdto(
          productId: productid,
          quantity: quantityOrder,
          deliveryAddress: address,
          paymentMethod: selectedPayment,
          size: sizeOrder,
          storeId: storeId,
          latitude: latitude,
          longitude: longitude,
          discountCode: promotionCode);
      }
      else{
        dto = Orderproductdto(
          productId: productid,
          quantity: quantityOrder,
          deliveryAddress: address,
          paymentMethod: selectedPayment,
          size: sizeOrder,
          storeId: storeId,
          latitude: latitude,
          longitude: longitude,);
      }

      
      await productController.order(dto);
      while (productController.getloadingOrder) {
        await Future.delayed(const Duration(microseconds: 100));
      }
      if (selectedPayment == "MOMO") {
        var payUrl = productController.qrcode.payUrl;
        final Uri _url = Uri.parse(payUrl!);
        if (!await launchUrl(_url)) {
          throw Exception('Could not launch $_url');
        }
      } else if (selectedPayment == "ZALOPAY") {
        ZaloData zalo = productController.qrcodeZalo;
        String payUrl = zalo.orderurl!;
        if (await canLaunchUrl(Uri.parse(payUrl))) {
          await launchUrl(Uri.parse(payUrl));
        } else {
          throw 'Could not launch $payUrl';
        }
      }
      Get.toNamed(AppRoute.ORDER_PAGE);
      
    }
    
  }

  // Show dropdown of map
  void _showDropdown() async {
    if (selectedProvince == null ||
        selectedDistrict == null ||
        HomenumberController.text == "") {
          print(1);
      Point mypoint = await functionmap.getCurrentLocation() as Point;
      setState(() {
        tappedPoint = LatLng(mypoint.latitude!, mypoint.longtitude!);
        loadlocation = true;
        isChangePoint = true;
      });
    } else {
      print(2);
      Point addresspoint = await functionmap.getCoordinatesFromAddress(
          HomenumberController.text +
              " " +
              selectedDistrict.toString() +
              ", " +
              selectedProvince!) as Point;
      setState(() {
        tappedPoint = LatLng(addresspoint.latitude!, addresspoint.longtitude!);
        loadlocation = true;
        isChangePoint = true;
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
                        // Show map of user position
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
                    // Show tapped point
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
                    // Zoom out map
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
                    // Zoom in map
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

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: true,
      body:  Column(
        children: [
          // Header of page
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
          // Body of page
          Expanded(
              child: SingleChildScrollView(
            child: loading! ? CircularProgressIndicator() : Column(
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
                      // Product selected to order
                      Container(
                        width: AppDimention.screenWidth,
                        padding: EdgeInsets.only(top: AppDimention.size10),
                        margin: EdgeInsets.only(top: AppDimention.size10),
                        decoration: BoxDecoration(
                            border: Border(
                                top:
                                    BorderSide(width: 1, color: Colors.black12),
                                bottom: BorderSide(
                                    width: 1, color: Colors.black12))),
                        child: Row(
                          children: [
                            Container(
                              width: AppDimention.screenWidth * 0.25,
                              height: AppDimention.screenWidth * 0.25,
                              margin:
                                  EdgeInsets.only(right: AppDimention.size20),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppDimention.size5),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(
                                          base64Decode(productitem!.image!)))),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  top: AppDimention.size10,
                                  left: AppDimention.size10,
                                  right: AppDimention.size10),
                              constraints: BoxConstraints(
                                minHeight: AppDimention.size100,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: AppDimention.screenWidth * 0.55,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(productitem!.productName!),
                                      ],
                                    ),
                                  ),
                                  StreamBuilder<int>(
                                    stream: quantityBloc.quantityStream,
                                    builder: (context, quantitySnapshot) {
                                      int quantitySN = widget.quantity;
                                      if(quantitySnapshot.hasData){
                                          quantitySN = quantitySnapshot.data!;
                                      }
                                      return StreamBuilder<int>(
                                        stream: sizeblocs.sizeStream,
                                        builder: (context, sizeSnapshot) {
                                          int sizeSN;
                                          if(widget.size == "M"){
                                            sizeSN = 1;
                                          }
                                          else if(widget.size == "L"){
                                            sizeSN = 2;
                                          }
                                          else{
                                            sizeSN = 3;
                                          }
                                          if(sizeSnapshot.hasData)
                                            sizeSN = sizeSnapshot.data!;
                                          
                                          final newPrice = productitem!.discountedPrice !=null 
                                              ? productitem!.discountedPrice!.toInt()
                                              : productitem!.price!.toInt();

                                          final calculatedPrice =(newPrice + (sizeSN - 1) * 10000) *quantitySN *(1 - percentSelected / 100);

                                          return Text(
                                            "đ${_formatNumber(calculatedPrice.toInt())}",
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    height: AppDimention.size10,
                                  ),
                                  GetBuilder<SizeController>(
                                      builder: (sizecontroller) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children:
                                          sizecontroller.sizelist.map((item) {
                                        return StreamBuilder(
                                            stream: sizeblocs.sizeStream,
                                            builder: (context, snapshot) {
                                              int sizeId = sizecontroller
                                                  .getbyname(widget.size)!;
                                              if (snapshot.hasData) {
                                                sizeId = snapshot.data!;
                                              }

                                              return GestureDetector(
                                                onTap: () {
                                                  sizeblocs.setSize(item.id!);
                                                  size = item.name;
                                                },
                                                child: Container(
                                                  width: AppDimention.size25,
                                                  height: AppDimention.size25,
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                    color: item.id == sizeId
                                                        ? Colors.greenAccent
                                                        : Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Center(
                                                    child: Text(item.name!),
                                                  ),
                                                ),
                                              );
                                            });
                                      }).toList(),
                                    );
                                  }),
                                  Container(
                                    width: AppDimention.screenWidth * 0.55,
                                    padding: EdgeInsets.all(AppDimention.size5),
                                    margin: EdgeInsets.only(
                                        top: AppDimention.size10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size5)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            quantityBloc.decrement();
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppDimention.size10,
                                        ),
                                        StreamBuilder(
                                            stream: quantityBloc.quantityStream,
                                            builder: (context, snapshot) {
                                              int quantityData = quantity!;
                                              if (snapshot.hasData) {
                                                quantityData = snapshot.data!;
                                              }
                                              return Text(
                                                "${quantityData}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: AppColor.mainColor,
                                                ),
                                              );
                                            }),
                                        SizedBox(
                                          width: AppDimention.size10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            quantityBloc.increment();
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // Get address of user field
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
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size60,
                        margin: EdgeInsets.only(
                          left: AppDimention.size5,
                          right: AppDimention.size5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            hintStyle:
                                TextStyle(color: Colors.black26, fontSize: 13),
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: AppDimention.screenWidth,
                        height: AppDimention.size60,
                        margin: EdgeInsets.only(
                          left: AppDimention.size5,
                          right: AppDimention.size5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                            hintStyle:
                                TextStyle(color: Colors.black26, fontSize: 13),
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
                          items: districts
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
                      SizedBox(
                        height: AppDimention.size10,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: AppDimention.size5,
                            right: AppDimention.size5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: HomenumberController,
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
                // Get store select field
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.amber.withOpacity(0.5),
                    hint: Text(
                      "Chọn cửa hàng",
                      style: TextStyle(color: Colors.black26, fontSize: 12),
                    ),
                    items: productitem!.stores!.map((item) {
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
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.contain,
                                                image: MemoryImage(base64Decode(
                                                    item.image!)))),
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
                                    width: AppDimention.screenWidth * 0.7,
                                    padding:
                                        EdgeInsets.all(AppDimention.size10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: AppColor.mainColor,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: AppDimention.size10,
                                            ),
                                            Text(
                                              "${item.numberPhone!}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.mainColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timelapse_rounded,
                                              color: AppColor.mainColor,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: AppDimention.size10,
                                            ),
                                            Text(
                                              "${functionmap.formatTime(item.openingTime!) + " AM - " + functionmap.formatTime(item.closingTime!)} PM",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.mainColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.store,
                                              color: AppColor.mainColor,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: AppDimention.size10,
                                            ),
                                            Container(
                                              width: AppDimention.screenWidth * 0.58,
                                              child: Text(
                                                "${item.location!}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColor.mainColor),
                                              ),
                                            )
                                          ],
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
                      onChanged(
                          selectedStore.storeName!, selectedStore.storeId!);
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
                      return productitem!.stores!.map((item) {
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
                // Get payment select field
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.amber.withOpacity(0.5),
                    hint: Text(
                      "Chọn phương thức thanh toán",
                      style: TextStyle(color: Colors.black26, fontSize: 12),
                    ),
                    items: paymentMethod.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Container(
                          width: AppDimention.screenWidth,
                          margin: EdgeInsets.only(
                              top: AppDimention.size10,
                              bottom: AppDimention.size10),
                          padding: EdgeInsets.all(AppDimention.size10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius:
                                BorderRadius.circular(AppDimention.size5),
                          ),
                          child: Container(
                              width: AppDimention.screenWidth,
                              child: Row(
                                children: [
                                  if (item == "ZALOPAY")
                                    Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/image/zalopay.jpg"),
                                              fit: BoxFit.cover)),
                                    ),
                                  if (item == "MOMO")
                                    Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/image/momo.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                  if (item == "CASH")
                                    Container(
                                      width: AppDimention.size40,
                                      height: AppDimention.size40,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/image/cash.png"),
                                              fit: BoxFit.cover)),
                                    ),
                                  SizedBox(
                                    width: AppDimention.size20,
                                  ),
                                  Text(
                                    "Thanh toán bằng ${item}",
                                  ),
                                ],
                              )),
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
                if (storeid != null)
                  Row(
                    children: [
                      SizedBox(
                        width: AppDimention.size10,
                      ),
                      Text("Mã giảm giá"),
                    ],
                  ),
                // Get voucher select field
                if (storeid != null)
                  GetBuilder<PromotionController>(builder: (controller) {
                    List<PromotionData> listvoucher = controller.getbystoreidanduser(storeid!);
                    return listvoucher.length == 0
                            ? Center(
                                child: Text(
                                  "Bạn không có mã giảm giá phù hợp",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              )
                            : Container(
                                width: AppDimention.screenWidth,
                                padding: EdgeInsets.all(AppDimention.size10),
                                decoration: BoxDecoration(),
                                child: DropdownButtonFormField(
                                  dropdownColor: Colors.amber.withOpacity(0.5),
                                  hint: Text(
                                    "Chọn mã giảm giá",
                                    style: TextStyle(
                                        color: Colors.black26, fontSize: 12),
                                  ),
                                  items: listvoucher.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Container(
                                        width: AppDimention.screenWidth,
                                        padding:
                                            EdgeInsets.all(AppDimention.size10),
                                        child: Column(
                                          children: [
                                            Container(
                                                width: AppDimention.screenWidth,
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        AppDimention.size10),
                                                padding: EdgeInsets.all(
                                                    AppDimention.size10),
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                          "assets/image/Voucher0.png",
                                                        )),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimention
                                                                .size10)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        "Mã giảm giá : ${item.code}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white)),
                                                    Text(
                                                        "Giá trị : ${item.discountPercent}%",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${formatTime(item.startDate!)}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          "${formatTime(item.endDate!)}",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    var selectedVoucher =
                                        value as PromotionData;
                                    onChangedVoucher(
                                        selectedVoucher.discountPercent!,
                                        selectedVoucher.code!);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimention.size5),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return controller.listpromotion.map((item) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        height: 60,
                                        width: AppDimention.size100 * 3,
                                        child: Text(item.code!,
                                            style: TextStyle(fontSize: 16)),
                                      );
                                    }).toList();
                                  },
                                ),
                              );
                  }),
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text("Ghi chú"),
                  ],
                ),
                // Note order field
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
                // Order button
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
