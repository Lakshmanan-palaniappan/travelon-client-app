import 'package:Travelon/core/utils/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    final baseUrl = dotenv.env['API_URL'];
    if (baseUrl == null || baseUrl.isEmpty) {
      throw Exception('API_URL not found in .env');
    }


    dio = Dio(BaseOptions(baseUrl: baseUrl));

    // Attach token to each request automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        // onRequest: (options, handler) async {
        //   final token = await TokenStorage.getToken();
        //   if (token != null && token.isNotEmpty) {
        //     options.headers['Authorization'] = 'Bearer $token';
        //   }
        //   return handler.next(options);
        // },
        onRequest: (options, handler) async {
          // List of paths that DON'T need a token
          const publicPaths = ['/agency', '/commons/list-agencies'];

          // if path not in public paths attach token
          if (!publicPaths.any((path) => options.path.contains(path))) {
            final token = await TokenStorage.getToken();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          //  token refresh
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/refresh')) {
            final refreshed = await _refreshToken();

            if (refreshed) {
              final token = await TokenStorage.getToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';

              final cloneReq = await dio.fetch(error.requestOptions);
              return handler.resolve(cloneReq);
            }
          }

          final cleanMessage = _mapDioError(error);

          return handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: cleanMessage,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );
  }
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final baseUrl = dotenv.env['API_URL']!;
      final refreshDio = Dio(BaseOptions(baseUrl: baseUrl));
      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.data['status'] == 'success') {
        final msg = response.data['message'];
        await TokenStorage.saveAuthData(
          token: msg['token'],
          refreshToken: msg['refreshToken'],
        );
        return true;
      }
    } catch (e) {
      // print('Token refresh failed: $e');
    }
    return false;
  }

  //  Normal requests
  Future<Response> postMultipart(
    String path,
    Map<String, dynamic> fields,
    String filePath,
    String fileField,
  ) async {
    final formData = FormData.fromMap({
      ...fields,
      fileField: await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });
    return await dio.post(path, data: formData);
  }

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await dio.post(path, data: data);
  }

  Future<Response> patch(String path, Map<String, dynamic> data) async {
    return await dio.patch(path, data: data);
  }

  Future<Response> get(String path) async {
    return await dio.get(path);
  }

  Future<Response> put(String path, Map<String, dynamic> data) async {
    return await dio.put(path, data: data);
  }
}

String _mapDioError(DioException e) {
  if (e.type == DioExceptionType.connectionError) {
    return "No internet connection.";
  }

  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return "Connection timeout. Please try again.";
  }

  if (e.response != null) {
    final data = e.response!.data;

    if (data is Map<String, dynamic>) {
      if (data["message"] != null) {
        return data["message"];
      }

      if (data["errors"] != null) {
        final errors = data["errors"];
        return errors.values.first[0];
      }
    }

    switch (e.response!.statusCode) {
      case 401:
        return "Invalid credentials.";
      case 403:
        return "Access denied.";
      case 404:
        return "Service not found.";
      case 500:
        return "Server error. Try again later.";
    }
  }

  return "Something went wrong.";
}
