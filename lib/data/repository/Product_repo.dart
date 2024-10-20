import 'dart:convert';
import 'package:flutter_user_github/data/api/ApiClient.dart';
import 'package:flutter_user_github/data/api/ApiClientAI.dart';
import 'package:flutter_user_github/data/api/AppConstant.dart';
import 'package:flutter_user_github/models/Dto/AddCartDto.dart';
import 'package:flutter_user_github/models/Dto/CommentDto.dart';
import 'package:flutter_user_github/models/Dto/OrderProductDto.dart';
import 'package:get/get.dart';

class ProductRepo {
  final ApiClient apiClient;
  final Apiclientai apiClientAI;
  ProductRepo({required this.apiClient,required this.apiClientAI});
  // get all product
  Future<Response> getall() async {
    return await apiClient.getData(Appconstant.PRODUCT_URL);
  }

  // get product by id
  Future<Response> getbyid(int id) async {
    String url =
        Appconstant.PRODUCT_BYID_URL.replaceFirst("{id}", id.toString());
    return await apiClient.getData(url);
  }

  // get product by category id
  Future<Response> getbycategoryid(int id) async {
    String url = Appconstant.PRODUCT_LIST_BYCATEGORYID_URL
        .replaceFirst("{id}", id.toString());
    return await apiClient.getData(url);
  }

  // add product to cart
  Future<Response> addtocart(
      AddcartDto dto) async {
  
    return await apiClient.postData(Appconstant.ADD_TOCART_URL, dto.toJson());
  }

  // get product by name
  Future<Response> getbyname(String textsearch) async {
    String url = Appconstant.PRODUCT_LIST_BYNAME_URL
        .replaceFirst("{name}", textsearch);
        print(url);
    return await apiClient.getData(url);
  }

  // get product by name
  Future<Response> getbystoreandcategoryid(int storeId, int categoryId) async {
    return await apiClient.getData(Appconstant
        .PRODUCT_LIST_BYCATEGORYID_STOREID_URL
        .replaceFirst("{storeid}", storeId.toString())
        .replaceFirst("{categoryid}", categoryId.toString()));
  }

  // get comment 
  Future<Response> addcomment(Commentdto dto) async {
    return await apiClient.postData(Appconstant.PRODUCT_ADD_COMMENT_URL,dto.toJson());
  }

  Future<Response> getcomment(int productid) async{
    return await apiClient.getData(Appconstant.PRODUCT_GET_COMMENT_URL.replaceFirst("{productid}", productid.toString()));
  }
  Future<Response> order(Orderproductdto dto) async{
    return await apiClient.postData(Appconstant.ORDER_COMBO_2_URL,dto.toJson());
  }

 Future<Response> searchbyimage(String base64Image) async {
  final body = jsonEncode({
    'image': base64Image,
  });
  return await apiClientAI.postDataPublic(Appconstant.SEARCH_BYIMAGE_URL, body);
 }
 Future<Response> getbystoreId(int storeId) async{
    return await apiClient.getData(Appconstant.PRODUCT_BYSTOREID_URL.replaceFirst("{id}", storeId.toString()));
  }


// Future<Response> searchByImage(String base64Image) async {
//   final url = Uri.parse('http://192.168.1.39:5000/predict');
//   final headers = {
//     'Content-Type': 'application/json', // Set the content type to JSON
//   };

//   // Prepare the body data with the base64 image
//   final body = jsonEncode({
//     'image': base64Image,
//     // Add other parameters according to your API requirements
//   });

//   try {
//     // Send the POST request using GetConnect
//     final response = await GetConnect().post(url.toString(), body, headers: headers);

//     // Check if the request was successful
//     if (response.isOk) {
//       // Handle the successful response here
//       print('Response data: ${response.body}');
//       return response; // Return the successful response
//     } else {
//       // Handle non-successful responses (e.g., 400, 404, 500)
//       print('Request failed with status: ${response.statusCode}.');
//       throw Exception('Failed to load data: ${response.statusText}');
//     }
//   } catch (error) {
//     print('Error occurred: $error');
//     throw Exception('Error making request: $error'); // Rethrow or handle the error as needed
//   }
// }


}
