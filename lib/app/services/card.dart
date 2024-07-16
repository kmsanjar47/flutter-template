import 'package:m_expense/app/utils/request_utils.dart';

class CardAPI{
  static Future<dynamic> addCard(Map<String,dynamic> params) async {
    return await RequestUtil.main.auth.post('/card', params:params);
  }
  static Future<dynamic> delete(String id) async {
    return await RequestUtil.main.auth.delete('/card/$id}');
  }
  static Future<dynamic> update(String id, Map<String,dynamic> params) async {
    return await RequestUtil.main.auth.put('/card/$id}', params:params);
  }
  static Future<dynamic> ownCards(String userId) async {
    return await RequestUtil.main.auth.get('/card/by-user/$userId');
  }
}