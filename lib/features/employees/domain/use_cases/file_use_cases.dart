import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/file_repository.dart';
abstract class FileUseCases {
  Future<Either<Failure, String>> uploadFile(File imageFile);

  Future<Either<Failure, String>> deleteFile(String fileUrl);
}

class FileUseCasesImpl implements FileUseCases {
  final FileRepository fileRepository;

  FileUseCasesImpl({required this.fileRepository});
  @override
  Future<Either<Failure, String>> deleteFile(String fileUrl) {
    return fileRepository.deleteFile(fileUrl);
  }

  @override
  Future<Either<Failure, String>> uploadFile(File imageFile) {
    return fileRepository.uploadFile(imageFile);
  }



}