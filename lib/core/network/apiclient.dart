import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://192.168.185.152:5821/api"));

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
}
