import 'package:dio/dio.dart';

String mapErrorToMessage(Object error) {
  if (error is DioException) {
    if (error.error is String) {
      return error.error as String;
    }

    if (error.response?.data is Map &&
        error.response?.data['message'] != null) {
      return error.response!.data['message'].toString();
    }
  }

  final message = error.toString();

  if (message.startsWith("Exception: ")) {
    return message.replaceFirst("Exception: ", "");
  }

  return "Something went wrong";
}