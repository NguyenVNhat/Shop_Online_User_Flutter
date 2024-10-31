import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/models/Dto/OrderProductDto.dart';
import 'package:flutter_user_github/models/Model/UserPromotionModel.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/models/Model/ZaloModels.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/theme/app_color.dart';
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

  TextEditingController provinceController     = TextEditingController();
  TextEditingController DistrictController     = TextEditingController();
  TextEditingController HomenumberController   = TextEditingController();
  TextEditingController StreetController       = TextEditingController();
  TextEditingController noteController         = TextEditingController();
  TextEditingController searchRecommend        = TextEditingController();

  ProductController     productController      = Get.find<ProductController>();
  PromotionController   promotionController    = Get.find<PromotionController>();
  UserController        userController         = Get.find<UserController>();
  MapController         mapController          = MapController();
  LatLng                tappedPoint            = LatLng(16.0471, 108.2068);
  FunctionMap           functionmap            = FunctionMap();
  
  List<String>          listprovince = [];
  String?               selectedVoucherStr;
  String?               size;
  String?               selectedProvince;
  String?               selectedPayment;
  String?               announce = "";
  double                percentSelected = 0;
  double?               longitude;
  double?               latitude;
  double                zoomValue = 14;
  bool                  isChangePoint = false;
  bool?                 isLoadPoint = false;
  bool                  loadlocation = false;
  int?                  selectedSize = 1;
  int?                  quantity;
  int?                  storeid;
  Point?                currentPoint;
  Productitem?          productitem;

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
    loadData();
  }
  // Load data of product selected to order
  void loadData(){
    size = widget.size;
    quantity = widget.quantity;
    listprovince = functionmap.listProvinces();
    productitem = productController.getproductbyid(widget.idproduct);
  }
  // Get current position of user
  Future<void> getCurrentPosition() async {
    currentPoint = await functionmap.getCurrentLocation();
    setState(() {isLoadPoint = true;});
  }
  // Format price of product 
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),(Match match) => '${match[1]}.',
    );
  }
  // Select store of product
  void onChanged(String? value, int id) {
    promotionController.getUserPromotionWithStoreId(id);
    setState(() 
    {
      storeid = id;
    });
  }
  // Select payment method of order
  List<String> paymentMethod = ["CASH", "MOMO", "ZALOPAY"];
  void onChangedPayment(String? value) {
    setState(() 
    {
      selectedPayment = value;
    });
  }
  // Select voucher of product
  void onChangedVoucher(double percentPromotion, String promotionCode) {
    setState(() 
    {
      selectedVoucherStr = promotionCode;
      percentSelected = percentPromotion;
    });
  }
  // Get coordinate from address of user
  Future<bool> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) 
      {
        setState(() 
        {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        });
        return true;
      }
    } 
    catch (e) 
    { 
      print('Error: $e'); 
    }
    return false;
  }
  // Get address of user
  void _getaddress() {
    User user = userController.userprofile!;
    setState(() {
      String address = user.address!;
      List<String> listaddress = address.split(",");
      getCoordinatesFromAddress(address);
      
      setState(() {
        HomenumberController.text = listaddress[0];
        StreetController.text = listaddress[1];
        DistrictController.text = listaddress[2];
        String provinceFromAddress = listaddress[3].trim().toLowerCase();
        if (listprovince.map((p) => p.toLowerCase().trim()).contains(provinceFromAddress)) 
        {
          setState(() 
          {
            selectedProvince = listaddress[3].trim();
          });
        } 
        else 
        {
          print("Province not found in the list.");
        }
      });
    });
  }
  // Order function 
  void _order() async {
    if (HomenumberController.text.isEmpty || DistrictController.text.isEmpty || StreetController.text.isEmpty ||
        selectedProvince!.isEmpty || storeid == null || longitude == null || latitude == null || selectedPayment == null) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin"; });
    } else {
      setState(() {announce = "";});
      int     productid     = productitem!.productId!;
      String  sizeOrder     = size!;
      int     quantityOrder = quantity!;
      int     storeId       = storeid!;
      String  promotionCode = "";
      String  address       = HomenumberController.text +
                              " " +  StreetController.text +
                              ", " + DistrictController.text +
                              ", " + selectedProvince!;
      if(selectedVoucherStr != null)
      {
        promotionCode = selectedVoucherStr!;
      }   
      if (isChangePoint) 
      {
        longitude = tappedPoint.longitude;
        latitude = tappedPoint.latitude;
      }

      Orderproductdto dto = Orderproductdto(
          productId: productid,
          quantity: quantityOrder,
          deliveryAddress: address,
          paymentMethod: selectedPayment,
          size: sizeOrder,
          storeId: storeId,
          latitude: latitude,
          longitude: longitude);

      await productController.order(dto);
      while (productController.getloadingOrder) 
      {
        await Future.delayed(const Duration(microseconds: 100)); 
      }
      if (selectedPayment == "MOMO") 
      {
        var payUrl = productController.qrcode.payUrl;
        final Uri _url = Uri.parse(payUrl!);
        if (!await launchUrl(_url)) 
        {
          throw Exception('Could not launch $_url'); 
        }
      } 
      else if (selectedPayment == "ZALOPAY") 
      {
        ZaloData zalo = productController.qrcodeZalo;
        String payUrl = zalo.orderurl!;
        if (await canLaunchUrl(Uri.parse(payUrl)))
        {  
          await launchUrl(Uri.parse(payUrl));
        } 
        else 
        {
          throw 'Could not launch $payUrl'; 
        }
      }
    }
  }
  // Show dropdown of map
  void _showDropdown() async {
    if (selectedProvince == null || selectedProvince!.isEmpty || HomenumberController.text.isEmpty || StreetController.text.isEmpty || DistrictController.text.isEmpty) 
    {
      Point mypoint = await functionmap.getCurrentLocation() as Point;
      setState(() 
      {
        tappedPoint = LatLng(mypoint.latitude!, mypoint.longtitude!);
        loadlocation = true;
        isChangePoint = true;
      });
    } 
    else 
    {
      Point addresspoint = await functionmap.getCoordinatesFromAddress(
          HomenumberController.text + " " +StreetController.text + ", " +
          DistrictController.text + ", " +selectedProvince!) as Point;
      setState(() 
      {
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppDimention.screenWidth,
                  margin: EdgeInsets.only(top: AppDimention.size20),
                  padding: EdgeInsets.only(left: AppDimention.size10, right: AppDimention.size10),
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
                              width:AppDimention.screenWidth * 0.25,
                              height:AppDimention.screenWidth * 0.25,
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
                                  Text(
                                          "đ${productitem!.discountedPrice!.toInt() != 0 ?
                                          _formatNumber((((productitem!.discountedPrice!.toInt() + (selectedSize! - 1) * 10000) * quantity!) * (1 - percentSelected / 100)).toInt()) :
                                          _formatNumber((((productitem!.price!.toInt() + (selectedSize! - 1) * 10000) * quantity!) * (1 - percentSelected / 100)).toInt())}",
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
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              size = item.name!;
                                              selectedSize = item.id;
                                            });
                                          },
                                          child: Container(
                                            width: AppDimention.size25,
                                            height: AppDimention.size25,
                                            margin: EdgeInsets.only(right: 10),
                                            decoration: BoxDecoration(
                                              color: item.name == size
                                                  ? Colors.greenAccent
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(item.name!),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }),
                                  Container(
                                    width:  AppDimention.screenWidth * 0.55,
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
                                            setState(() {
                                              if (quantity! > 1)
                                                quantity = quantity! - 1;
                                            });
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppDimention.size10,
                                        ),
                                        Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: AppColor.mainColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: AppDimention.size10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (quantity! < 20)
                                                quantity = quantity! + 1;
                                            });
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
                                      listprovince.contains(selectedProvince)
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
                              items: listprovince.map<DropdownMenuItem<String>>(
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
                // Get store select field
                Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.all(AppDimention.size10),
                  decoration: BoxDecoration(),
                  child: DropdownButtonFormField(
                    dropdownColor: Colors.amber,
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
                                    padding:
                                        EdgeInsets.all(AppDimention.size10),
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
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Sđt :" +
                                              item.numberPhone!.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          "Thời gian : " +
                                              functionmap.formatTime(
                                                  item.openingTime!) +
                                              " - " +
                                              functionmap.formatTime(
                                                  item.closingTime!),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
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
                    return controller.getloadingStoreId!
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : controller.listpromotionByStoreId.length == 0
                            ? Center(
                                child: Text(
                                  "Cửa hàng này không có đơn hàng cho sản phẩm",
                                  style: TextStyle(color: Colors.black45),
                                ),
                              )
                            : Container(
                                width: AppDimention.screenWidth,
                                padding: EdgeInsets.all(AppDimention.size10),
                                decoration: BoxDecoration(),
                                child: DropdownButtonFormField(
                                  hint: Text(
                                    "Chọn mã giảm giá",
                                    style: TextStyle(
                                        color: Colors.black26, fontSize: 12),
                                  ),
                                  items: controller.getlistuserpromotion
                                      .map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Container(
                                        width: AppDimention.size100 * 3.8,
                                        margin: EdgeInsets.only(
                                            top: AppDimention.size10,
                                            bottom: AppDimention.size10),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: AppDimention.screenWidth,
                                              height: AppDimention.size130,
                                              margin: EdgeInsets.only(
                                                  left: AppDimention.size10,
                                                  right: AppDimention.size10,
                                                  bottom: AppDimention.size10),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        "assets/image/Voucher0.png",
                                                      )),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppDimention.size10)),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: AppDimention.size60,
                                                    height:
                                                        AppDimention.size130,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                width: 5,
                                                                color: Colors
                                                                    .black12))),
                                                    child: Center(
                                                      child: Text(
                                                        "${item.percent!.toInt()}%",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        AppDimention.size100 *
                                                            2.5,
                                                    height:
                                                        AppDimention.size130,
                                                    padding: EdgeInsets.all(
                                                        AppDimention.size10),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: AppDimention
                                                                    .size100 *
                                                                2.5,
                                                            height: AppDimention
                                                                    .size130 *
                                                                0.6,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width: AppDimention
                                                                          .size100,
                                                                      child: Text(
                                                                          "${item.promotionCode}",
                                                                          maxLines:
                                                                              2,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16,
                                                                              color: Colors.white)),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            )),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    var selectedVoucher =
                                        value as UserPromotionData;
                                    onChangedVoucher(selectedVoucher.percent!,
                                        selectedVoucher.promotionCode!);
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
                                    return controller.listuserpromotion
                                        .map((item) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        height: 60,
                                        width: AppDimention.size100 * 3,
                                        child: Text(item.promotionCode!,
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
