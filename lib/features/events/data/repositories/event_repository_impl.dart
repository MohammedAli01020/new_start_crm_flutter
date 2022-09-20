import 'package:crm_flutter_project/core/error/failures.dart';

import 'package:crm_flutter_project/features/customers/data/models/event_model.dart';
import 'package:crm_flutter_project/features/events/data/data_sources/event_remote_data_source.dart';

import 'package:crm_flutter_project/features/events/domain/use_cases/events_use_cases.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource eventRemoteDataSource;

  EventRepositoryImpl({required this.eventRemoteDataSource});

  @override
  Future<Either<Failure, void>> deleteEvent(int eventId) async {
    try {
      final response = await eventRemoteDataSource.deleteEvent(eventId);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getAllEventsByNameLike({String? name}) async {
    try {
      final response = await eventRemoteDataSource.getAllEventsByNameLike(name: name);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

  @override
  Future<Either<Failure, EventModel>> modifyEvent(ModifyEventParam modifyEventParam) async {
    try {
      final response = await eventRemoteDataSource.modifyEvent(modifyEventParam);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(msg: e.msg));
    }
  }

}