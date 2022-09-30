import 'dart:io';



import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/file_repository.dart';
import '../data_sources/file_remote_data_source.dart';

class FileRepositoryImpl implements FileRepository {

  final FileRemoteDataSource fileRemoteDataSource;

  FileRepositoryImpl({required this.fileRemoteDataSource});
  @override
  Future<Either<Failure, String>> deleteFile(String fileUrl) async {
    try {
      final response = await fileRemoteDataSource.deleteFile(fileUrl);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile(File imageFile) async {
    try {
      final response = await fileRemoteDataSource.uploadFile(imageFile);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}