import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class FileRepository {
  Future<Either<Failure, String>> uploadFile(File imageFile);

  Future<Either<Failure, String>> deleteFile(String fileUrl);
}