
import 'package:crm_flutter_project/features/sources/domain/repositories/source_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/source_model.dart';

abstract class SourcesUseCases {
  Future<Either<Failure, List<SourceModel>>> getAllSourcesByNameLike({String? name});

  Future<Either<Failure, SourceModel>> modifySource(
      ModifySourceParam modifySourceParam);

  Future<Either<Failure, void>> deleteSource(int sourceId);
}

class SourcesUseCasesImpl implements SourcesUseCases {
  final SourceRepository sourceRepository;

  SourcesUseCasesImpl({required this.sourceRepository});
  @override
  Future<Either<Failure, void>> deleteSource(int sourceId) {
    return sourceRepository.deleteSource(sourceId);
  }

  @override
  Future<Either<Failure, List<SourceModel>>> getAllSourcesByNameLike({String? name}) {
    return sourceRepository.getAllSourcesByNameLike(name: name);
  }

  @override
  Future<Either<Failure, SourceModel>> modifySource(ModifySourceParam modifySourceParam) {
    return sourceRepository.modifySource(modifySourceParam);
  }


}


class ModifySourceParam extends Equatable {
  final int? sourceId;

  final String name;


  const ModifySourceParam({
    required this.sourceId,
    required this.name,
  });

  Map<String, dynamic> toJson() =>
      {
        "sourceId": sourceId,
        "name": name
      };

  @override
  List<Object?> get props => [sourceId, name];
}