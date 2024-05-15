import 'dart:convert';
import 'package:http/http.dart' as http;

// 황지민 : http 통신

import 'package:dio/dio.dart';

Future<Map<String, dynamic>> postData(
    String url, Map<String, dynamic> data) async {
  try {
    Dio dio = Dio();
    Response response = await dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          //'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is String) {
        return {"data": response.data};
      } else {
        return response.data;
      }
    } else {
      if (response.data is String) {
        return {"data": response.statusCode};
      } else {
        return response.data;
      }
    }
  } catch (e) {
    return {"data": "fail"};
  }
}

Future<Map<String, dynamic>> getData(
    String url, Map<String, dynamic> queryParams, String token) async {
  try {
    Dio dio = Dio();
    Response response = await dio.get(
      url,
      queryParameters: queryParams,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

Future<List<dynamic>> getListData(
    String url, Map<String, dynamic> queryParams, String token) async {
  try {
    Dio dio = Dio();
    Response response = await dio.get(
      url,
      queryParameters: queryParams,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

Future<Map<String, dynamic>> updateData(
    String url, Map<String, dynamic> data) async {
  final response = await http.put(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to update data');
  }
}
