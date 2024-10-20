import 'dart:convert';

import 'package:flutter_user_github/data/controller/Product_controller.dart';
import 'package:flutter_user_github/models/Model/Item/ProductItem.dart';
import 'package:flutter_user_github/route/app_route.dart';
import 'package:flutter_user_github/theme/app_dimention.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ProductAll extends StatefulWidget{
   const ProductAll({
       Key? key,
   }): super(key:key);
   @override
   _ProductAllState createState() => _ProductAllState();
}
class _ProductAllState extends State<ProductAll>{
   @override
   Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
              child: Column(
                children: [
                    
                    GetBuilder<ProductController>(builder: (productController){
            return  productController.isLoading  ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: productController.productList.length ,
            itemBuilder: (context , index){
              Productitem item = productController.productList[index];
                return GestureDetector(
                    onTap: (){
                      Get.toNamed(AppRoute.get_product_detail(item.productId!));
                    },
                    child: Container(
                            margin: EdgeInsets.only(left: AppDimention.size20, right:  AppDimention.size20,bottom: AppDimention.size20),
                             decoration: BoxDecoration(
                                 border: Border(bottom: BorderSide(width: 1,color: Color.fromRGBO(0, 0, 0, 0.5)))
                              ),
                            child: Row(
                              children: [
                                Container(
                                    width: AppDimention.listViewImageSize,
                                    height: AppDimention.listViewImageSize,
                                    decoration: BoxDecoration(
                                     
                                      color: Colors.white,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(base64Decode(productController.productList[index].image!)),
                                        ),
                                    ),
                                  ),
                                Expanded(
                                  child: Container(
                                      margin: EdgeInsets.only(left: AppDimention.size10),
                                      height: AppDimention.listViewImageSize,
                                     
                                      child: Padding(
                                        padding: EdgeInsets.only(left: AppDimention.size10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,

                                          children: [
                                             SizedBox(height: AppDimention.size20,),
                                              Container(
                                                child: Text(productController.productList[index].productName!,style: TextStyle(
                                                    fontSize: AppDimention.size15,
                                                    fontWeight: FontWeight.w500
                                                ),),
                                              ),
                                              SizedBox(height: AppDimention.size10,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,color: Colors.yellow,),
                                                        Text("4.5")
                                                      ],
                                                    ),
                                                    SizedBox(width: AppDimention.size30,),
                                                     Row(
                                                      children: [
                                                        Icon(Icons.location_on,color: Colors.blue,),
                                                        Text("2.7 km")
                                                      ],
                                                    )
                                                  ],
                                              ),
                                              SizedBox(height: AppDimention.size10,),
                                              Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                 Text(
                                                    "Giá: " + productController.productList[index].price.toString(),
                                                    style: TextStyle(
                                                      fontSize: AppDimention.size10,
                                                      decoration: TextDecoration.lineThrough,color: Colors.red, 
                                                    ),
                                                  ),
                                                  SizedBox(width: AppDimention.size20,),
                                                  Text(productController.productList[index].discountedPrice.toString()+" vnđ")
                                                ],
                                              )
                                              

                                          ],
                                        ),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                        ),
                );
              },
          ): CircularProgressIndicator();
       })
                    
                   
                ],
              ),
              
            )
            ),
            
            
          ],
        ),
      );
   }
}