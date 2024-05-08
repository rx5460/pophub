import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pophub/utils/log.dart';

// 황지민 : http 통신

Future<String> postData(String url, Map<String, String> data) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return response.body;
  } else {
    throw Exception('Failed to post data');
  }
}

Future<Map<String, String>> getData(
    String url, Map<String, String> queryParams) async {
  final uri = Uri.parse(url).replace(queryParameters: queryParams);
  final response = await http.get(uri);

  Logger.debug("### repsonse $response ");
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
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
