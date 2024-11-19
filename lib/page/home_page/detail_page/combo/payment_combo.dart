import 'package:flutter_user_github/data/controller/Promotion_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Combo_controller.dart';
import 'package:flutter_user_github/data/controller/Store_Controller.dart';
import 'package:flutter_user_github/data/controller/User_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/PromotionModel.dart';
import 'package:flutter_user_github/models/Model/Item/ComboItem.dart';
import 'package:flutter_user_github/models/Dto/OrderComboDto.dart';
import 'package:flutter_user_github/models/Model/ZaloModels.dart';
import 'package:flutter_user_github/models/Model/UserModel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter_user_github/blocs/QuantityBlocs.dart';
import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/blocs/SizeBlocs.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'dart:convert';

class PaymentCombo extends StatefulWidget {
  final List<int> iddrink;
  final int quantity;
  final int idcombo;
  const PaymentCombo({
    required this.quantity,
    required this.idcombo,
    required this.iddrink,
    Key? key,
  }) : super(key: key);
  @override
  _PaymentComboState createState() => _PaymentComboState();
}

class _PaymentComboState extends State<PaymentCombo> {
  TextEditingController HomenumberController = TextEditingController();
  ProductController productController = Get.find<ProductController>();
  TextEditingController provinceController = TextEditingController();
  TextEditingController DistrictController = TextEditingController();
  TextEditingController StreetController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  ComboController combocontroller = Get.find<ComboController>();
  Storecontroller storecontroller = Get.find<Storecontroller>();
  List<String> paymentMethod = ["CASH", "MOMO", "ZALOPAY"];
  LatLng tappedPoint = LatLng(16.0471, 108.2068);
  MapController mapController = MapController();
  QuantityBloc quantityBloc = QuantityBloc();
  FunctionMap functionmap = FunctionMap();
  List<Productitem> productitem = [];
  Sizeblocs sizeblocs = Sizeblocs();
  String? selectedVoucherStr = "";
  bool ischangePoint = false;
  double percentSelected = 0;
  bool loadlocation = false;
  bool? isLoadPoint = false;
  String? selectedPayment;
  bool? haveDrink = false;
  String? selectedValue;
  String? announce = "";
  double zoomValue = 14;
  Comboitem? comboitem;
  bool? isload = false;
  int? selectSize = 1;
  Point? currentPoint;
  double? longitude;
  double? latitude;
  int? storeid;

  String? selectedProvince;
  List<String> provinces = [];
  String? selectedDistrict;
  List<String> districts = [];
  FunctionMap functionMap = FunctionMap();
  @override
  void initState() {
    super.initState();
    loadingData();
    getCurrentPosition();
    quantityBloc.setQuantity(widget.quantity);
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
    if (widget.iddrink[0] != 0) {
      for (int id in widget.iddrink) {
        productitem.add(productController.getproductbyid(id)!);
      }
      haveDrink = true;
    }
    comboitem = combocontroller.getcombobyId(widget.idcombo);

    setState(() {
      isload = true;
    });
  }

  void _getaddress() async {
    while (provinces.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    User user = Get.find<UserController>().userprofile!;
    List<String> listaddress = user.address!.split("|@##@|");
    getCoordinatesFromAddress(
        listaddress[2] + ", " + listaddress[1] + ", " + listaddress[0]);
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

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
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

  void onChangedVoucher(double percentPromotion, String promotionCode) {
    setState(() {
      selectedVoucherStr = promotionCode;
      percentSelected = percentPromotion;
    });
  }

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

  void _showDropdown() async {
    if (selectedProvince == null || selectedDistrict == null ||
        HomenumberController.text.isEmpty) {
      Point mypoint = await functionmap.getCurrentLocation() as Point;
      setState(() {
        tappedPoint = LatLng(mypoint.latitude!, mypoint.longtitude!);
        loadlocation = true;
        ischangePoint = true;
      });
    } else {
      User user = Get.find<UserController>().userprofile!;
      List<String> listaddress = user.address!.split("|@##@|");
      Point addresspoint = await functionmap.getCoordinatesFromAddress(
              selectedProvince.toString() + ", " + selectedDistrict.toString() + ", " + HomenumberController.text)
          as Point;

      setState(() {
        tappedPoint = LatLng(addresspoint.latitude!, addresspoint.longtitude!);
        loadlocation = true;
        ischangePoint = true;
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
        selectedDistrict == null ||
        selectedProvince == null ||
        storeid == null ||
        selectedPayment!.isEmpty) {
      setState(() {
        announce = "Vui lòng nhập đủ thông tin";
      });
    } else {
      String address = selectedProvince.toString() + ", " +  selectedDistrict.toString() +", " + HomenumberController.text;
      await Get.find<SizeController>().getbyidl(sizeblocs.getSize());
      String sizename = Get.find<SizeController>().sizename;
      int quantity = quantityBloc.getQuantity();
      String paymentMethod = selectedPayment!;
      int idcombo = comboitem!.comboId!;
      int storeId = storeid!;
      if (ischangePoint) {
        longitude = tappedPoint.longitude;
        latitude = tappedPoint.latitude;
      }

      Ordercombodto dto;
      if (selectedVoucherStr != "") {
        if (widget.iddrink[0] == 0) {
          dto = Ordercombodto(
              paymentMethod: paymentMethod,
              comboId: idcombo,
              drinkIds: [],
              storeId: storeId,
              quantity: quantity,
              size: sizename,
              deliveryAddress: address,
              latitude: latitude,
              longitude: longitude,
              discountCode: selectedVoucherStr);
        } else {
          dto = Ordercombodto(
              paymentMethod: paymentMethod,
              comboId: idcombo,
              drinkIds: widget.iddrink,
              storeId: storeId,
              quantity: quantity,
              size: sizename,
              deliveryAddress: address,
              latitude: latitude,
              longitude: longitude,
              discountCode: selectedVoucherStr);
        }
      } else {
        if (widget.iddrink[0] == 0) {
          dto = Ordercombodto(
              paymentMethod: paymentMethod,
              comboId: idcombo,
              drinkIds: [],
              storeId: storeId,
              quantity: quantity,
              size: sizename,
              deliveryAddress: address,
              latitude: latitude,
              longitude: longitude);
        } else {
          dto = Ordercombodto(
              paymentMethod: paymentMethod,
              comboId: idcombo,
              drinkIds: widget.iddrink,
              storeId: storeId,
              quantity: quantity,
              size: sizename,
              deliveryAddress: address,
              latitude: latitude,
              longitude: longitude);
        }
      }
      await combocontroller.order(dto);
      while (combocontroller.getordering) {
        await Future.delayed(const Duration(microseconds: 100));
      }
      if (paymentMethod == "MOMO") {
        var payUrl = combocontroller.qrcode.payUrl;
        final Uri _url = Uri.parse(payUrl!);
        if (!await launchUrl(_url)) {
          throw Exception('Could not launch $_url');
        }
      } else if (selectedPayment == "ZALOPAY") {
        ZaloData zalo = combocontroller.qrcodeZalo;
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: AppDimention.size20,
                                              height: AppDimention.size20,
                                              margin: EdgeInsets.only(right: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/image/combo.jpg"))),
                                            ),
                                            Text("${comboitem!.comboName}")
                                          ],
                                        ),
                                        StreamBuilder(
                                            stream: quantityBloc.quantityStream,
                                            builder: (context, snapshot) {
                                              int quantity = widget.quantity;
                                              if (snapshot.hasData) {
                                                quantity = snapshot.data!;
                                              }
                                              return StreamBuilder(
                                                  stream: sizeblocs.sizeStream,
                                                  builder:
                                                      (context, sizesnapshot) {
                                                    int sizeId = 1;
                                                    if (sizesnapshot.hasData) {
                                                      sizeId =
                                                          sizesnapshot.data!;
                                                    }
                                                    return Row(
                                                      children: [
                                                        Icon(
                                                          Icons.money,
                                                          color: AppColor
                                                              .mainColor,
                                                          size: 16,
                                                        ),
                                                        SizedBox(
                                                          width: AppDimention
                                                              .size10,
                                                        ),
                                                        Text(
                                                          "${_formatNumber((comboitem!.price!.toInt() + (sizeId - 1) * 10000) * quantity)}đ",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            }),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                quantityBloc.decrement();
                                              },
                                              child: Icon(
                                                Icons
                                                    .remove_circle_outline_outlined,
                                                color: AppColor.mainColor,
                                                size: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppDimention.size10,
                                            ),
                                            StreamBuilder(
                                                stream:
                                                    quantityBloc.quantityStream,
                                                builder: (context, snapshot) {
                                                  int quantity =
                                                      widget.quantity;
                                                  if (snapshot.hasData) {
                                                    quantity = snapshot.data!;
                                                  }
                                                  return Text(
                                                    " ${quantity}",
                                                    style:
                                                        TextStyle(fontSize: 12),
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
                                                Icons.control_point_outlined,
                                                color: AppColor.mainColor,
                                                size: 16,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: AppDimention.size10,
                                        ),
                                        GetBuilder<SizeController>(
                                            builder: (sizecontroller) {
                                          return Row(
                                            children: sizecontroller.sizelist
                                                .map((item) {
                                              return StreamBuilder(
                                                  stream: sizeblocs.sizeStream,
                                                  builder: (context, snapshot) {
                                                    int sizeId = 1;
                                                    if (snapshot.hasData) {
                                                      sizeId = snapshot.data!;
                                                    }
                                                    return GestureDetector(
                                                      onTap: () {
                                                        sizeblocs
                                                            .setSize(item.id!);
                                                      },
                                                      child: Container(
                                                        width:
                                                            AppDimention.size25,
                                                        height:
                                                            AppDimention.size25,
                                                        margin: EdgeInsets.only(
                                                            right: 20),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: item
                                                                      .id ==
                                                                  sizeId
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
                                                          child:
                                                              Text(item.name!),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }).toList(),
                                          );
                                        }),
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
                            ? Column(
                                children: productitem
                                    .map((item) => Container(
                                          width: AppDimention.screenWidth,
                                          padding: EdgeInsets.only(
                                              top: AppDimention.size10),
                                          margin: EdgeInsets.only(
                                              top: AppDimention.size10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1,
                                                      color: Colors.black26))),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: AppDimention.size60,
                                                height: AppDimention.size60,
                                                margin: EdgeInsets.only(
                                                    right: AppDimention.size20),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppDimention.size5),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: MemoryImage(
                                                            base64Decode(
                                                                item.image!)))),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    AppDimention.size10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(item.productName!),
                                                    Text(
                                                        "${_formatNumber(item.price!.toInt() + (selectSize! - 1) * 10000)}đ"),
                                                    SizedBox(
                                                      height:
                                                          AppDimention.size10,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                    .toList(),
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
                isload!
                    ? Container(
                        width: AppDimention.screenWidth,
                        padding: EdgeInsets.all(AppDimention.size10),
                        decoration: BoxDecoration(),
                        child: DropdownButtonFormField(
                          dropdownColor: Colors.amber.withOpacity(0.5),
                          hint: Text(
                            "Chọn cửa hàng",
                            style:
                                TextStyle(color: Colors.black26, fontSize: 12),
                          ),
                          items: storecontroller
                              .getCommonStores(comboitem!.products!)
                              .map((item) {
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
                                                      image: MemoryImage(
                                                          base64Decode(
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
                                          padding: EdgeInsets.all(
                                              AppDimention.size10),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColor.mainColor),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppColor.mainColor),
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
                                                    width: AppDimention
                                                            .screenWidth *
                                                        0.58,
                                                    child: Text(
                                                      "${item.location!}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColor
                                                              .mainColor),
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
                            return storecontroller
                                .getCommonStores(comboitem!.products!)
                                .map((item) {
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
                Row(
                  children: [
                    SizedBox(
                      width: AppDimention.size10,
                    ),
                    Text("Mã giảm giá"),
                  ],
                ),
                if (storeid != null)
                  GetBuilder<PromotionController>(builder: (controller) {
                    controller.getbystoreid(storeid!);
                    return
                        // controller.getloadingStoreId!
                        // ? Center(
                        //     child: CircularProgressIndicator(),
                        //   )
                        // :
                        controller.listpromotionByStoreId.length == 0
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
                                  items: controller.getlistpromotionByUser
                                      .where((item) =>
                                          item.storeId!.contains(storeid))
                                      .where((item) => item.used == false)
                                      .map((item) {
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
