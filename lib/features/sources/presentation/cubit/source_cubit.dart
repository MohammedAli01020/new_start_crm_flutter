import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/features/sources/domain/use_cases/sources_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../data/models/source_model.dart';
part 'source_state.dart';

class SourceCubit extends Cubit<SourceState> {
  final SourcesUseCases sourcesUseCases;
  SourceCubit({required this.sourcesUseCases}) : super(SourceInitial());

  static SourceCubit get(context) => BlocProvider.of(context);

  List<SourceModel> sources = [];

  Future<void> getAllSourcesByNameLike({String? name}) async {
    emit(StartGetAllSourcesByNameLike());

    Either<Failure, List<SourceModel>> response =
    await sourcesUseCases.getAllSourcesByNameLike(name: name);

    response.fold(
            (failure) => emit(GetAllSourcesByNameLikeError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedSources) {
      sources = fetchedSources;
      return emit(EndGetAllSourcesByNameLike(fetchedSources: fetchedSources));
    });
  }

  List<String> selectedSources = [];

  void updateSelectedSources(String sourceName) {
    emit(StartUpdateSelectedSources());
    if (selectedSources.contains(sourceName)) {
      selectedSources.remove(sourceName);
    } else {
      selectedSources.add(sourceName);
    }
    emit(EndUpdateSelectedSources());
  }

  void setSelectedSources(List<String> newSources) {
    emit(StartSetSelectedSources());
    selectedSources = newSources;
    emit(EndSetSelectedSources());
  }

  void resetSelectedSources() {
    emit(StartResetSelectedSources());
    selectedSources = [];
    emit(EndResetSelectedSources());

  }




  Future<void> modifySource(ModifySourceParam modifySourceParam) async {

    emit(StartModifySource());

    Either<Failure, SourceModel> response =
    await sourcesUseCases.modifySource(modifySourceParam);

    response.fold(
            (failure) => emit(ModifySourceError(
            msg: Constants.mapFailureToMsg(failure))), (modifiedSource) {

      if (modifySourceParam.sourceId != null) {
        try {
          int index = sources.indexWhere((element) {
            return element.sourceId == modifySourceParam.sourceId;
          });

          sources[index] = modifiedSource;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        sources.insert(0, modifiedSource);
      }

      return emit(EndModifySource(modifiedSource: modifiedSource));
    });

  }

  Future<void> deleteSource(int sourceId) async {
    emit(StartDeleteSource());

    Either<Failure, void> response =
    await sourcesUseCases.deleteSource(sourceId);

    response.fold((failure) => emit(DeleteSourceError(msg: Constants.mapFailureToMsg(failure))),
            (success) {

          try {
            sources.removeWhere((element) {
              return element.sourceId == sourceId;
            });
          } catch (e) {
            debugPrint(e.toString());
          }

          return emit(EndDeleteSource(eventId: sourceId));
        });
  }
}
