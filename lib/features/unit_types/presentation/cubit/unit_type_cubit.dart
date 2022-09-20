import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/features/unit_types/domain/use_cases/unit_types_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/unti_type_model.dart';
part 'unit_type_state.dart';

class UnitTypeCubit extends Cubit<UnitTypeState> {

  final UnitTypesUseCases unitTypesUseCases;
  UnitTypeCubit({required this.unitTypesUseCases}) : super(UnitTypeInitial());

  static UnitTypeCubit get(context) => BlocProvider.of(context);
  List<UnitTypeModel> unitTypes = [];

  Future<void> getAllUnitTypesByNameLike({String? name}) async {
    emit(StartGetAllUnitTypesByNameLike());

    Either<Failure, List<UnitTypeModel>> response =
    await unitTypesUseCases.getAllUnitTypesByNameLike(name: name);

    response.fold(
            (failure) => emit(GetAllUnitTypesByNameLikeError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedUnitTypes) {
      unitTypes = fetchedUnitTypes;
      return emit(EndGetAllUnitTypesByNameLike(fetchedUnitTypes: fetchedUnitTypes));
    });
  }

  List<String> selectedUnitTypes = [];

  void updateSelectedUnitTypes(String sourceName) {
    emit(StartUpdateSelectedUnitTypes());
    if (selectedUnitTypes.contains(sourceName)) {
      selectedUnitTypes.remove(sourceName);
    } else {
      selectedUnitTypes.add(sourceName);
    }
    emit(EndUpdateSelectedUnitTypes());
  }


  void setSelectedUnitTypes(List<String> newUnitTypes) {
    emit(StartSetSelectedUnitTypes());
    selectedUnitTypes = newUnitTypes;
    emit(EndSetSelectedUnitTypes());
  }

  void resetSelectedUnitTypes() {
    emit(StartResetSelectedUnitTypes());
    selectedUnitTypes = [];
    emit(EndResetSelectedUnitTypes());

  }




  Future<void> modifyUnitType(ModifyUnitTypeParam modifyUnitTypeParam) async {

    emit(StartModifyUnitType());

    Either<Failure, UnitTypeModel> response =
    await unitTypesUseCases.modifyUnitType(modifyUnitTypeParam);

    response.fold(
            (failure) => emit(ModifyUnitTypeError(
            msg: Constants.mapFailureToMsg(failure))), (modifiedUnitType) {

      if (modifyUnitTypeParam.unitTypeId != null) {
        try {
          int index = unitTypes.indexWhere((element) {
            return element.unitTypeId == modifyUnitTypeParam.unitTypeId;
          });

          unitTypes[index] = modifiedUnitType;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        unitTypes.insert(0, modifiedUnitType);
      }

      return emit(EndModifyUnitType(modifiedUnitType: modifiedUnitType));
    });

  }

  Future<void> deleteUnitType(int unitTypeId) async {
    emit(StartDeleteUnitType());

    Either<Failure, void> response =
    await unitTypesUseCases.deleteUnitType(unitTypeId);

    response.fold((failure) => emit(DeleteUnitTypeError(msg: Constants.mapFailureToMsg(failure))),
            (success) {

          try {
            unitTypes.removeWhere((element) {
              return element.unitTypeId == unitTypeId;
            });
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndDeleteUnitType(eventId: unitTypeId));
        });
  }
}
