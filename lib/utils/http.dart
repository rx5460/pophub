import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:pophub/utils/log.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Dio dio = Dio()
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';
        // 여기에 기본 Authorization 헤더를 추가합니다.
        String? token = await secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['authorization'] = token;
        }
        return handler.next(options);
      },
    ),
  );

String? _token; // 토큰을 저장하는 변수

void setToken(String token) {
  _token = token;
}

Future<Map<String, dynamic>> postData(
    String url, Map<String, dynamic> data) async {
  try {
    Response response = await dio.post(
      url,
      data: data,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
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
    String url, Map<String, dynamic> queryParams) async {
  print(url);
  try {
    Response response = await dio.get(
      url,
      queryParameters: queryParams,
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

// Future<Map<String, dynamic>> getNoAuthData(
//     String url, Map<String, dynamic> queryParams) async {
//   try {
//     Dio dio = Dio();
//     Logger.debug("url : $url");
//     Response response = await dio.get(
//       url,
//       queryParameters: queryParams,
//       options: Options(
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//       ),
//     );
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return response.data;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     throw Exception('Failed to get data: $e');
//   }
// }

Future<List<dynamic>> getListData(
    String url, Map<String, dynamic> queryParams) async {
  try {
    Response response = await dio.get(
      url,
      queryParameters: queryParams,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
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
      'Authorization': _token ?? '',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to update data');
  }
}

// Future<Map<String, dynamic>> postDataWithImage(
//   String url,
//   Map<String, dynamic> data,
//   String imageKey,
//   File imageFile,
// ) async {
//   try {
//     String fileName = imageFile.path.split('/').last;

//     FormData formData = FormData.fromMap({
//       ...data,
//       imageKey: await MultipartFile.fromFile(
//         imageFile.path,
//         filename: fileName,
//       ),
//     });

//     Response response = await dio.post(
//       url,
//       data: formData,
//       options: Options(
//         headers: {
//           'Content-Type': 'multipart/form-data',
//         },
//       ),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       if (response.data is String) {
//         return {"data": response.data};
//       } else {
//         return response.data;
//       }
//     } else {
//       if (response.data is String) {
//         return {"data": response.statusCode};
//       } else {
//         return response.data;
//       }
//     }
//   } catch (e) {
//     return {"data": "fail"};
//   }
// }
