import 'package:m_expense/app/utils/request_utils.dart';

class UserAPI{
  static Future<dynamic> login(Map<String,dynamic> params) async {
    return await RequestUtil.security.open.post('/auth/login', params:params);
  }
  static Future<dynamic> user(String userId) async {
    return await RequestUtil.security.auth.get('/users/$userId');
  }
}