import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/source_model.dart';
import '../use_cases/sources_use_cases.dart';

abstract class SourceRepository {
  Future<Either<Failure, List<SourceModel>>> getAllSourcesByNameLike({String? name});

  Future<Either<Failure, SourceModel>> modifySource(
      ModifySourceParam modifySourceParam);

  Future<Either<Failure, void>> deleteSource(int sourceId);
}