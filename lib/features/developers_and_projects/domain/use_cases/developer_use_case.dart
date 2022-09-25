import 'package:crm_flutter_project/features/developers_and_projects/data/models/developer_model.dart';
import 'package:crm_flutter_project/features/developers_and_projects/domain/repositories/developer_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
abstract class DeveloperUseCase {
  Future<Either<Failure, List<DeveloperModel>>> getAllDevelopersByNameLike({String? name});

  Future<Either<Failure, DeveloperModel>> modifyDeveloper(
      ModifyDeveloperParam  modifyDeveloperParam);

  Future<Either<Failure, void>> deleteDeveloper(int developerId);
}

class DeveloperUseCaseImpl implements DeveloperUseCase {
  final DeveloperRepository developerRepository;

  DeveloperUseCaseImpl({required this.developerRepository});
  @override
  Future<Either<Failure, void>> deleteDeveloper(int developerId) {

    return developerRepository.deleteDeveloper(developerId);
  }

  @override
  Future<Either<Failure, List<DeveloperModel>>> getAllDevelopersByNameLike({String? name}) {

    return developerRepository.getAllDevelopersByNameLike(name: name);
  }

  @override
  Future<Either<Failure, DeveloperModel>> modifyDeveloper(ModifyDeveloperParam modifyDeveloperParam) {
    return developerRepository.modifyDeveloper(modifyDeveloperParam);
  }

}



class ModifyDeveloperParam extends Equatable {
  final int? developerId;

  final String name;


  const ModifyDeveloperParam({
    required this.developerId,
    required this.name,
  });

  Map<String, dynamic> toJson() =>
      {
        "developerId": developerId,
        "name": name
      };

  @override
  List<Object?> get props => [developerId, name];
}