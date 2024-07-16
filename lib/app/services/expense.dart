import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../utils/request_utils.dart';

class ExpenseAPI{
  static Future<dynamic> create(Map<String, dynamic> data, File document) async {
    Map<String, dynamic> formData = {
      'document':  await MultipartFile.fromFile(document.path, filename: basename(document.path)) ,
      'data': jsonEncode(data)
    };
    return await RequestUtil.main.auth.postForm('/expense', params: formData, options: Options(method: 'POST'));
  }
  static Future<dynamic> update(String expenseId, {Map<String, dynamic> data  = const {}, File? document}) async {
    Map<String, dynamic> formData = {
      if(document!=null)
      'document':  await MultipartFile.fromFile(document.path, filename: basename(document.path)) ,
      'data': jsonEncode(data)
    };
    return await RequestUtil.main.auth.postForm('/expense/$expenseId', params: formData, options: Options(method: 'PUT'));
  }

  static Future<dynamic> delete(String expenseId) async {
    return await RequestUtil.main.auth.delete('/expense/$expenseId');
  }

  // static Future<dynamic> update(String expenseId, {Map<String, dynamic> data = const {}}) async {
  //   return await RequestUtil.main.auth.put('/expense/$expenseId', params: data);
  // }


  static Future<dynamic> filter({String? field = "status", String? fieldValue = "SUBMITTED"}) async {
    return await RequestUtil.main.auth.get('/expense/filter-by/$field/where-value/$fieldValue');
  }

  static Future<dynamic> submitAllDraft({Map<String, dynamic> data  = const {}}) async {
    return await RequestUtil.main.auth.post('/expense/submit_expenses',params: data);
  }

  static Future<dynamic> rangeFilter({String? field = "status", String? fieldValue = "SUBMITTED", String? from = "2000-01-01", String? to = "2029-01-01",}) async {
    return await RequestUtil.main.auth.get('/expense/filter-by/$field/where-value/$fieldValue/from-date/$from/to-date/$to');
  }

}