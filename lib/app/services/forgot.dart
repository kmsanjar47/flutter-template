import 'package:m_expense/app/utils/request_utils.dart';

class ForgotPassAPI{
  static Future<dynamic> sendOTP(Map<String,dynamic> params) async {
    return await RequestUtil.security.open.post('/otp/send_otp', params:params);
  }
  static Future<dynamic> matchOTP(Map<String,dynamic> params) async {
    return await RequestUtil.security.open.post('/otp/match_otp', params:params);
  }
  static Future<dynamic> changePassword(Map<String,dynamic> params) async {
    return await RequestUtil.security.open.post('/auth/change_password', params:params);
  }
}