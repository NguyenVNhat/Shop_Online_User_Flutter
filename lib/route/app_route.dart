class AppRoute {
  static String LOGIN_PAGE = "/login";
  static String HOME_PAGE = "/";
  static String REGISTER_PAGE = "/register";
  static String FORGET_PASSWORD_PAGE = "/forget_password";
  static String PROFILE_PAGE = "/profile";
  static String PROFILE_SETTING_PAGE = "/profile_setting";
  static String CAMERA_PAGE = "/camera";
  static String CART_PAGE = "/cart";
  static String PRODUCT_DETAIL = "/product_detail";
  static String COMBO_DETAIL = "/combo_detail";
  static String STORE_PAGE = "/store";
  static String CATEGORY_PAGE = "/category";
  static String CATEGORY_DETAIL_PAGE = "/category_detail";
  static String ORDER_PAGE = "/order";
  static String PRODUCT_ALL_PAGE = "/product_all";
  static String SEARCH_PAGE = "/search";
  static String PROFILE_CAMERA_PAGE = "/profile-camera";
  static String PROFILE_SETUP_PAGE = "/profile-setup";
  static String PROMOTION_PAGE = "/promotion";
  static String ORDER_DETAIL_PAGE = "/order-detail";
  static String CHART_PAGE = "/chart";
  static String STORE_DETAIL_PAGE = "/store-detail";
  static String REGISTER_SHIP_PAGE = "/register-ship";
  static String ORDER_COMBO_PAGE = "/order-combo";
  static String ORDER_CART_PAGE = "/order-cart";
  static String NOTIFICATION_PAGE = "/notification";
  static String ORDER_PRODUCT_PAGE = "/product-order";
  static String TRANSFER_POINT_PAGE = "/transfer-point";
  static String USER_CHAT_DETAIL_PAGE = "/chat-detail";
  static String SEARCH_CHAT_PAGE = "/search-chat";
  static String STORE_CHAT_PAGE = "/store-chat";
  static String STORE_CHAT_DETAIL_PAGE = "/store-chat-detail";

  static String user_chat_detail(int idreceiver) =>
      '$USER_CHAT_DETAIL_PAGE?idreceiver=$idreceiver';

  static String store_chat_detail(int storeId) =>
      '$STORE_CHAT_DETAIL_PAGE?storeId=$storeId';

  static String order_combo(int comboid, int drinkid) =>
      '$ORDER_COMBO_PAGE?comboid=$comboid&drinkid=$drinkid';

  static String order_product(int product, String size, int quantity) =>
      '$ORDER_PRODUCT_PAGE?product=$product&size=$size&quantity=$quantity';

  static String get_store_detail(int storeid) =>
      '$STORE_DETAIL_PAGE?storeid=$storeid';

  static String get_order_detail(String orderCode) =>
      '$ORDER_DETAIL_PAGE?orderCode=$orderCode';
  static String get_combo_detail(int comboId) =>
      '$COMBO_DETAIL?comboId=$comboId';
  static String get_product_detail(int productId) =>
      '$PRODUCT_DETAIL?productId=$productId';
  static String get_product_bycategoryid_detail(
          int categoryid, String categoryname) =>
      '$CATEGORY_DETAIL_PAGE?categoryid=$categoryid&categoryname=$categoryname';
}
