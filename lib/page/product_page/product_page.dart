import 'dart:convert';

import 'package:flutter_user_github/caculator/function.dart';
import 'package:flutter_user_github/data/controller/Auth_controller.dart';
import 'package:flutter_user_github/data/controller/Cart_controller.dart';
import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/data/controller/Size_controller.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
import 'package:flutter_user_github/models/Model/RateModel.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_color.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  ProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductController productController;
  Productitem? productitem;

  int quantity = 1;
  int productid = 0;
  int idstore = 0;
  bool showDescription = true;
  int selectSize = 1;
  AuthController authController = Get.find<AuthController>();
  FunctionMap functionmap = FunctionMap();
  Point? currentPoint ;
  bool? isLoadPoint = false;
  @override
  void initState() {
    super.initState();
    productController = Get.find();
    productid = widget.productId;
    productitem = productController.getproductbyid(widget.productId);
    productController.getcomment(widget.productId);
    
    getCurrentPosition();
  }
  Future<void> getCurrentPosition() async {
  currentPoint = await functionmap.getCurrentLocation();
  setState(() {
    isLoadPoint = true;
  });
}

  void _toggleContent(bool isDescription) {
    setState(() {
      showDescription = isDescription;
    });
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]}.',
        );
  }

  String selectSizeString = "M";
  void _order(int productId,String selectSizeStr,int quantity){
    Get.toNamed(AppRoute.order_product(productId, selectSizeStr, quantity));
  }

  void _showDropdown(List<Storesitem> items, Function(String) onItemSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey.withOpacity(0.2),
          height: 400,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  onItemSelected(items[index].storeName!);
                  Navigator.pop(context);
                },
                child: Container(
                  width: AppDimention.screenWidth,
                  padding: EdgeInsets.only(left: AppDimention.size10,right: AppDimention.size10,top: AppDimention.size20,bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(width: 1,color: Colors.black26))
                  ),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.location_on_outlined,color: Colors.blue,),
                          Text("${(functionmap.calculateDistance(items[index].latitude!, items[index].longitude!,isLoadPoint! ? currentPoint!.latitude! : 0, isLoadPoint! ? currentPoint!.longtitude! : 0)/1000).toInt() } ",style: TextStyle(color: Colors.blue),),
                          Text("( km )",style: TextStyle(color: Colors.blue),)
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: AppDimention.size10),
                        width: AppDimention.screenWidth * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(items[index].storeName!,textAlign: TextAlign.justify,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                            SizedBox(height: AppDimention.size5,),
                            Text(
                              items[index].location!,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.black45
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void addtocart() async {
    await Get.find<SizeController>().getbyidl(selectSize);
    String sizename = Get.find<SizeController>().sizename;
    Get.find<ProductController>()
        .addtocart(productid, quantity, idstore, sizename);
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return GetBuilder<ProductController>(builder: (productController) {
     
      if (productController.productListBycategory.isEmpty) {
        productController.getProductByCategoryId(productitem!.category!.categoryId!);
      }
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: AppDimention.size30,
                      height: AppDimention.size30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppDimention.size30),
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_new, size: 15),
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: Obx(() {
                      if (!authController.IsLogin.value) {
                        return Container();
                      } else {
                        return Container(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoute.CART_PAGE);
                                  },
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                    size: AppDimention.size30,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                width: 20,
                                height: 20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    color: AppColor.mainColor,
                                  ),
                                  child: Container(
                                      width: AppDimention.size10,
                                      height: AppDimention.size10,
                                      child: Center(
                                        child: Text(
                                          Get.find<CartController>()
                                              .cartlist
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
              pinned: true,
              backgroundColor: const Color.fromARGB(255, 243, 134, 134),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(AppDimention.size20),
                child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(AppDimention.size10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppDimention.size20),
                        topRight: Radius.circular(AppDimention.size20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          productitem!.productName!,
                          style: TextStyle(
                              fontSize: AppDimention.size30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("( ${productitem!.category!.categoryName!} )")
                      ],
                    )),
              ),
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.memory(
                  base64Decode(productitem!.image!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: AppDimention.size20,
                              right: AppDimention.size20),
                          child: Row(
                            children: [
                              Text(
                                "đ${productitem!.discountedPrice!.toInt() != 0 ? _formatNumber(productitem!.discountedPrice!.toInt()) : _formatNumber(productitem!.price!.toInt())}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: AppDimention.size10,
                              ),
                              Text(
                                "đ${productitem!.discountedPrice!.toInt() == 0 ? "" : _formatNumber(productitem!.price!.toInt())}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 10,
                                    color: Colors.red),
                              )
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              left: AppDimention.size20,
                              right: AppDimention.size20),
                          child: Row(
                            children: [
                              Wrap(
                                children: List.generate(
                                    5,
                                    (index) => Icon(Icons.star,
                                        color: AppColor.mainColor,
                                        size: AppDimention.size10)),
                              ),
                              Text(
                                "( 5 )",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.mainColor),
                              ),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: AppDimention.size10,
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: AppDimention.size20,
                          right: AppDimention.size20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GetBuilder<SizeController>(builder: (sizecontroller) {
                            return Row(
                              children: sizecontroller.sizelist.map((item) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectSize = item.id!;
                                      selectSizeString = item.name!;
                                    });
                                  },
                                  child: Container(
                                    width: AppDimention.size30,
                                    height: AppDimention.size30,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: item.id == selectSize
                                          ? Colors.greenAccent
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Text(item.name!),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
                          Text(
                            "SL : ${productitem!.stockQuantity.toString()}",
                          )
                        ],
                      )),
                  SizedBox(
                    height: AppDimention.size20,
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    padding: EdgeInsets.only(
                        left: AppDimention.size20, right: AppDimention.size20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chi tiết sản phẩm",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: AppDimention.size10,
                        ),
                        Text(
                          productitem!.description!,
                          style: TextStyle(color: Colors.black45),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _toggleContent(true),
                        child: Container(
                            child: Container(
                                width: AppDimention.screenWidth / 2,
                                height: 50,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: showDescription
                                                ? AppColor.mainColor
                                                : Colors.white))),
                                child: Center(
                                  child: Text(
                                    "Sản phẩm ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: showDescription
                                          ? AppColor.mainColor
                                          : Colors.black,
                                    ),
                                  ),
                                ))),
                      ),
                      GestureDetector(
                        onTap: () => _toggleContent(false),
                        child: Container(
                            width: AppDimention.screenWidth / 2,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1,
                                        color: !showDescription
                                            ? AppColor.mainColor
                                            : Colors.white))),
                            child: Center(
                              child: Text(
                                "Đánh giá",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: !showDescription
                                      ? AppColor.mainColor
                                      : Colors.black,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    width: AppDimention.screenWidth,
                    child: showDescription
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: 8, top: AppDimention.size10),
                                width: AppDimention.screenWidth,
                                padding:
                                    EdgeInsets.only(left: AppDimention.size10),
                                child: Text(
                                  "Có thể bạn sẽ thích",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black38),
                                ),
                              ),
                              GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: productController
                                              .productListBycategory.length >
                                          10
                                      ? 10
                                      : productController
                                          .productListBycategory.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              AppRoute.get_product_detail(
                                                  productController
                                                      .productList![index]
                                                      .productId!));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1,
                                                color: Color.fromRGBO(
                                                    218, 218, 218, 0.494)),
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 170,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: MemoryImage(
                                                        base64Decode(
                                                            productController
                                                                .productList[
                                                                    index]
                                                                .image!)),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 170,
                                                padding: EdgeInsets.only(
                                                    left: AppDimention.size10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          AppDimention.size5,
                                                    ),
                                                    Text(
                                                      productController
                                                          .productList![index]
                                                          .productName!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColor
                                                              .mainColor),
                                                    ),
                                                    Text(
                                                      "đ${_formatNumber(productController.productList[index].price!.toInt())}",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Wrap(
                                                              children: List.generate(
                                                                  5,
                                                                  (index) => Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: AppColor
                                                                          .mainColor,
                                                                      size: 8)),
                                                            ),
                                                            Text(
                                                              "(5)",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: AppColor
                                                                      .mainColor),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "1028",
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .chat_bubble_outline_rounded,
                                                              size: 12,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: AppDimention
                                                            .size15),
                                                    Row(
                                                      children: [
                                                        Icon(Icons
                                                            .delivery_dining_sharp),
                                                        Text(
                                                          "Miễn phí vận chuyển",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  })
                            ],
                          )
                        : GetBuilder<ProductController>(builder: (controller){
                          return controller.loadingComment! ? CircularProgressIndicator():

                              controller.listcomment.length == 0 ? 
                              Container(
                                width: AppDimention.screenWidth,
                                height: AppDimention.size50,
                                child: Center(
                                  child: Text(
                                    "Sản phẩm chưa có đánh giá"
                                  ),
                                ),
                              )
                              :
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.listcomment.length,
                                itemBuilder: (context, index) {
                                  RateData item = controller.listcomment[index];
                                  return Container(
                                    width: AppDimention.screenWidth,
                                    padding: EdgeInsets.all(AppDimention.size20),
                                    margin: EdgeInsets.only(
                                        left: AppDimention.size10,
                                        right: AppDimention.size10,
                                        bottom: AppDimention.size10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            AppDimention.size10)),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${item.userName}"),
                                            Row(
                                              children: [
                                                Wrap(
                                                  children: List.generate(
                                                      item.rate!,
                                                      (index) => Icon(Icons.star,
                                                          color: AppColor.mainColor,
                                                          size:
                                                              AppDimention.size15)),
                                                ),
                                                SizedBox(
                                                  width: AppDimention.size5,
                                                ),
                                                Text(
                                                  "(${item.rate})",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColor.mainColor),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: AppDimention.size10,
                                        ),
                                        Container(
                                            width: AppDimention.screenWidth,
                                            color: Colors.white,
                                            padding:
                                                EdgeInsets.all(AppDimention.size10),
                                            child: Text(
                                                "${item.comment}",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle()))
                                      ],
                                    ),
                                  );
                                });
                        })
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: AppDimention.size10,
                  bottom: AppDimention.size10,
                  left: AppDimention.size10,
                  right: AppDimention.size10),
              decoration: BoxDecoration(
                color: AppColor.mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimention.size10),
                  topRight: Radius.circular(AppDimention.size10),
                ),
              ),
              child: Obx(() {
                if (!authController.IsLogin.value) {
                  return Container(
                    width: AppDimention.screenWidth,
                    height: AppDimention.size30,
                    child: Center(
                        child: GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoute.LOGIN_PAGE);
                      },
                      child: Center(
                        child: Text(
                          "Vui lòng đăng nhập",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: AppDimention.size100,
                        padding: EdgeInsets.all(AppDimention.size5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppDimention.size5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (quantity > 1) quantity--;
                                });
                              },
                              child: Icon(
                                Icons.remove_circle_outline_rounded,
                                color: AppColor.mainColor,
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColor.mainColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (quantity < 20) quantity++;
                                });
                              },
                              child: Icon(
                                Icons.add_circle_outline_sharp,
                                color: AppColor.mainColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                            _order(productitem!.productId!,selectSizeString,quantity);
                        },
                        child: Container(
                        padding: EdgeInsets.only(
                            top: AppDimention.size20,
                            bottom: AppDimention.size20,
                            left: AppDimention.size70,
                            right: AppDimention.size70),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppDimention.size10),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Mua ngay",
                              style: TextStyle(
                                color: AppColor.mainColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      ),
                      GestureDetector(
                        onTap: () => _showDropdown(
                          productitem!.stores!,
                          (selectedStoreName) {
                            setState(() {
                              idstore = (productitem!.stores as List<Storesitem>)
                                  .firstWhere((store) =>
                                      store.storeName == selectedStoreName)
                                  .storeId!;
                              addtocart();
                            });
                          },
                        ),
                        child: Container(
                          padding: EdgeInsets.all(AppDimention.size10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppDimention.size10),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: AppColor.mainColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      );
    });
  }
}
