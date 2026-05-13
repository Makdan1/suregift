class AppConstants {
  static const String baseUrl = 'https://assessment.suregifts.com.ng';
  
  // Auth
  static const String loginUrl = '/api/Auth/login';
  
  // Products
  static const String productsUrl = '/api/suregifts/products';
  
  // Cart
  static const String cartUrl = '/api/cart';
  static const String cartItemsUrl = '/api/cart/items';
  static const String cartTotalUrl = '/api/cart/total';
  
  // Checkout
  static const String calculateTotalUrl = '/api/checkout/calculate-total';
  static const String checkoutUrl = '/api/checkout';
  
  // Orders
  static const String ordersUrl = '/api/orders';
  
  // Vouchers
  static const String vouchersUrl = '/api/vouchers';

  static const String tokenKey = 'access_token';
}
