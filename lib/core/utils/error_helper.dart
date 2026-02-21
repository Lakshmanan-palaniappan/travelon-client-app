import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handle(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return "Connection timeout. Please try again.";
    }

    if (e.type == DioExceptionType.connectionError) {
      return "No internet connection.";
    }

    if (e.response != null) {
      final statusCode = e.response!.statusCode;
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

      switch (statusCode) {
        case 400:
          return "Invalid request.";
        case 401:
          return "Invalid email or password.";
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
}