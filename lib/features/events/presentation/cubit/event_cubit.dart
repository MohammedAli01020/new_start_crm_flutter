import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/features/customers/data/models/event_model.dart';
import 'package:crm_flutter_project/features/events/domain/use_cases/events_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final EventsUseCases eventsUseCases;

  EventCubit({required this.eventsUseCases}) : super(EventInitial());

  static EventCubit get(context) => BlocProvider.of(context);

  List<EventModel> events = [];

  Future<void> getAllEventsByNameLike({String? name, String? eventType}) async {
    emit(StartGetAllEventsByNameLike());

    Either<Failure, List<EventModel>> response =
        await eventsUseCases.getAllEventsByNameLike(name: name);

    response.fold(
        (failure) => emit(GetAllEventsByNameLikeError(
            msg: Constants.mapFailureToMsg(failure))), (fetchedEvents) {
          if (eventType == EventType.SELECT_EVENT.name) {
            fetchedEvents.removeWhere((element) => element.name == 'No Action');
            events = fetchedEvents;
          } else {
            events = fetchedEvents;
          }

      return emit(EndGetAllEventsByNameLike(fetchedEvents: fetchedEvents));
    });
  }

  List<EventModel> selectedEvents = [];


  void updateSelectedEvents(EventModel event) {
    emit(StartUpdateSelectedEvents());
    if (selectedEvents.contains(event)) {
      selectedEvents.remove(event);
    } else {
      selectedEvents.add(event);
    }
    emit(EndUpdateSelectedEvents());
  }

  EventModel? currentSelectedEvent;

  void updateCurrentSelectedEvent(EventModel? newEvent) {
    emit(StartUpdateCurrentSelectedEvent());
    if (newEvent == currentSelectedEvent) {
      currentSelectedEvent = null;
    } else {
      currentSelectedEvent = newEvent;
    }

    emit(EndUpdateCurrentSelectedEvent());
  }

  void setSelectedEvents(List<EventModel> newEvents) {
    emit(StartSetSelectedEvents());
    selectedEvents = newEvents;
    emit(EndSetSelectedEvents());
  }

  void resetSelectedEvents() {
    emit(StartResetSelectedEvents());
    selectedEvents = [];
    emit(EndResetSelectedEvents());
  }

  Future<void> modifyEvent(ModifyEventParam modifyEventParam) async {
    emit(StartModifyEvent());

    Either<Failure, EventModel> response =
        await eventsUseCases.modifyEvent(modifyEventParam);

    response.fold(
        (failure) =>
            emit(ModifyEventError(msg: Constants.mapFailureToMsg(failure))),
        (modifiedEvent) {
      if (modifyEventParam.eventId != null) {
        try {
          int index = events.indexWhere((element) {
            return element.eventId == modifyEventParam.eventId;
          });

          events[index] = modifiedEvent;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        events.insert(0, modifiedEvent);
      }

      return emit(EndModifyEvent(modifiedEvent: modifiedEvent));
    });
  }

  Future<void> deleteEvent(int eventId) async {
    emit(StartDeleteEvent());

    Either<Failure, void> response = await eventsUseCases.deleteEvent(eventId);

    response.fold(
        (failure) =>
            emit(DeleteEventError(msg: Constants.mapFailureToMsg(failure))),
        (success) {
      try {
        events.removeWhere((element) {
          return element.eventId == eventId;
        });
      } catch (e) {
        debugPrint(e.toString());
      }

      return emit(EndDeleteEvent(eventId: eventId));
    });
  }
}
