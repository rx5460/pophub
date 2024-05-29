import 'dart:io' show File;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as secure;
import 'package:pophub/utils/log.dart';

// dio Options랑 secureStorage Options랑 이름 충돌나서 secure로 했쇼
const secure.FlutterSecureStorage secureStorage = secure.FlutterSecureStorage();

Dio dio = Dio()
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Content-Type'] = 'application/json; charset=UTF-8';

        String? token = await secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['authorization'] = token;
        }
        return handler.next(options);
      },
    ),
  );

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
    Logger.debug(e.toString());
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
      if (response.data is String) {
        return {"data": response.data};
      }
      return response.data;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to get data: $e');
  }
}

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

Future<Map<String, dynamic>> putData(
    String url, Map<String, dynamic> data) async {
  try {
    Response response = await dio.put(
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
    Logger.debug(e.toString());
    return {"data": "fail"};
  }
}

Future<Map<String, dynamic>> postDataWithImage(
  String url,
  Map<String, dynamic> data,
  String imageKey,
  File imageFile,
) async {
  try {
    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      ...data,
      imageKey: await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    Response response = await dio.post(
      url,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {
          'authorization': await secureStorage.read(key: 'token'),
        },
      ),
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data is String) {
        return {"data": response.data};
      } else {
        return response.data;
      }
    } else {
      if (response.data is String) {
        return {"data 2": response.statusCode};
      } else {
        return response.data;
      }
    }
  } catch (e) {
    print(e);
    return {"data": "fail"};
  }
}

Future<Map<String, dynamic>> postFormData(String url, FormData data) async {
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
    Logger.debug(e.toString());
    return {"data": "fail"};
  }
}
