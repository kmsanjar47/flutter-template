import 'package:m_expense/app/utils/request_utils.dart';

class DashboardAPI{
  static Future<dynamic> info(String yearAndMonth) async {
    return await RequestUtil.main.auth.get('/dashboard/by-month/$yearAndMonth');
  }
}