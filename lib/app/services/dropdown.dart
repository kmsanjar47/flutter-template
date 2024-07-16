import 'package:m_expense/app/utils/request_utils.dart';

class DropdownAPI{
  static Future<dynamic> get({int typeId=0}) async {
    return await RequestUtil.main.auth.get('/dropdown/item/by-type/$typeId');
  }
}