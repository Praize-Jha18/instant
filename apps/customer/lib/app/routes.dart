/// Route paths and builders for the customer app.
abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';

  static const String checkout = '/checkout';
  static const String addresses = '/addresses';
  static const String addressNew = '/addresses/new';
  static const String notifications = '/profile/notifications';

  static String vendor(String id) => '/vendors/$id';
  static String product(String id) => '/products/$id';
  static String order(String id, {bool celebrate = false}) => '/orders/$id${celebrate ? '?celebrate=1' : ''}';
  static String tracking(String id) => '/orders/$id/tracking';
  static String payment(String orderId) => '/checkout/pay/$orderId';
  static String addressEdit(String id) => '/addresses/$id/edit';
  static String searchWith({String? categoryId, String? q}) {
    final params = <String, String>{
      'categoryId': ?categoryId,
      if (q != null && q.isNotEmpty) 'q': q,
    };
    return Uri(path: search, queryParameters: params.isEmpty ? null : params).toString();
  }

  static const Set<String> authRoutes = {login, register, forgotPassword};
}
