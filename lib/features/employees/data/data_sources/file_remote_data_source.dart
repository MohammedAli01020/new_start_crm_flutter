import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';

abstract class FileRemoteDataSource {
  Future<String> uploadFile(File imageFile);
  Future<String> deleteFile(String fileUrl);
}


class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiConsumer apiConsumer;

  FileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<String> deleteFile(String fileUrl) async {
    final response =  await apiConsumer.delete(
      EndPoints.deleteFile,
      queryParameters: {
        "fileUrl": fileUrl
      },
    );

    return response;
  }

  @override
  Future<String> uploadFile(File imageFile) async {
    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path,
          filename: fileName),
    });

    final response =  await apiConsumer.post(
      EndPoints.uploadFile,
      body: formData,
    );

    return response;
  }

}
