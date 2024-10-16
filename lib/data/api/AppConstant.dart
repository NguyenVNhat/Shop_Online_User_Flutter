class Appconstant {
  static const  String APP_NAME = "NhatDepTrai";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "http://192.168.1.39:8080";
  static const String BASE_AI_URL = "http://192.168.1.39:5000";
  static const String SEARCH_BYIMAGE_URL = "/predict";



  static const String LOGIN_URL= "/api/v1/auth/login";
  static const String LOGOUT_URL= "/api/v1/auth/logout";
  static const String REGISTER_URL= "/api/v1/auth/register-user";
  static const String REGISTER_SHIPPER_URL= "/api/v1/auth/shipper-registration";
  static const String SENDOTP_URL= "/api/v1/auth/send-otp?email={email}";
  static const String VERIFYOTP_URL= "/api/v1/auth/confirm-otp?email={email}&otp={otp}&newPassword={newpassword}";

  static const String COMBO_URL = "/api/v1/public/combo/all";
  static const String COMBO_BY_COMBOID_URL = "/api/v1/public/combo/{id}";
  

  static const String STORE_URL = "/api/v1/public/stores/all";
  static const String STORE_BY_ID_URL = "/api/v1/public/stores/{id}";

  static const String CATEGORY_URL = "/api/v1/public/categories/all";
  static const String CATEGORY_BYSTOREID_URL = "/api/v1/public/category/stores/{storeid}";

  static const String PRODUCT_URL = "/api/v1/public/products/all";
  static const String PRODUCT_GET_COMMENT_URL = "/api/v1/public/rate/product/{productid}";
  static const String PRODUCT_BYID_URL = "/api/v1/public/products/{id}";
  static const String PRODUCT_ADD_COMMENT_URL = "/api/v1/user/product/rate";
  static const String PRODUCT_LIST_BYCATEGORYID_URL = "/api/v1/public/products/category/{id}";
  static const String PRODUCT_LIST_BYCATEGORYID_STOREID_URL = "/api/v1/public/products/{storeid}/{categoryid}";
  
  static const String ADD_TOCART_URL = "/api/v1/user/cart/add/product?productId={productid}&quantity={quantity}&storeId={storeid}&size={size}";
  static const String CART_URL = "/api/v1/user/cart/history";
  static const String CART_BYID_URL = "/api/v1/user/cart/{cartid}";
  static const String CART_STORE_URL = "/api/v1/user/cart/allstore";
  static const String CART_STORE_LISTPRODUCT_URL = "/api/v1/user/cart/store/{storeid}";

  static const String ORDERT_URL = "/api/v1/user/order/history";
  static const String ORDERT_CANCEL_URL = "/api/v1/user/order/cancel/{ordercode}";
  static const String ORDER_UPDATE_FEEDBACK_URL = "/api/v1/user/order/update/feedback/{orderid}";
  static const String ORDER_COMBO_2_URL = "/api/v1/user/order/create/now";
  static const String ORDER_PRODUCT_INCART_URL = "/api/v1/user/order/create";
  static const String ORDER_BY_ORDERCODE_URL = "/api/v1/user/order/history/{ordercode}";
  static const String ORDER_BY_ORDERSTATUS_URL = "/api/v1/user/order/history/status?status={status}";
  static const String ANNOUNCE_URL = "/api/v1/user/announce";
  static const String ANNOUNCE_ADD_URL = "/api/v1/user/announce/add";
  
  static const String USER_PROFILE_URL = "/api/v1/user/auth/profile";
  static const String USER_UPDATE_PROFILE_URL = "/api/v1/user/auth/profiles/update";
  static const String PRODUCT_LIST_BYNAME_URL = "/api/v1/public/products/search?name={name}";

  static const String SIZE_URL = "/api/v1/public/sizes/all";
  static const String SIZE_BY_ID_URL = "/api/v1/public/sizes/{id}";

  static const String SAVE_CHART_IMAGE = "/api/chats/saveImages";
  static const String CHART_URL = "/api/chats/users-chat";
  static const String GETLISTCHART_URL = "/api/chats/receiver/{receiverid}";

  static const String TOKEN = "DBtoken";
}
