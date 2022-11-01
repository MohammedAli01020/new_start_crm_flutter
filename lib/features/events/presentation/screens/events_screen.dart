import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/features/events/presentation/widgets/event_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../customers/data/models/event_model.dart';
import '../cubit/event_cubit.dart';
import '../widgets/modify_event_widget.dart';

class EventsScreen extends StatelessWidget {
  final EventsArgs eventsArgs;

  final _scrollController = ScrollController();

  EventsScreen({Key? key, required this.eventsArgs}) : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? Constants.extraScrollSpeed
                  : -Constants.extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  Widget _buildBody(EventCubit eventCubit, EventState state) {

    if (state is StartGetAllEventsByNameLike) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllEventsByNameLikeError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          eventCubit.getAllEventsByNameLike(eventType: eventsArgs.eventType);
        },
      );
    }

    return Scrollbar(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentEvent = eventCubit.events[index];
          return ListTile(
            onTap: () {
              if (eventsArgs.eventType == EventType.SELECT_EVENT.name) {
                eventCubit.updateCurrentSelectedEvent(currentEvent);
              } else if (eventsArgs.eventType == EventType.VIEW_EVENTS.name) {

                if (Constants.currentEmployee!.permissions.contains(AppStrings.editEvents)) {
                  if (currentEvent.name == "No Action" ||
                      currentEvent.name == "Cancellation" ||
                      currentEvent.name == "Contract") {
                    Constants.showToast(msg: "غير قابله للتعديل او الحذف", context: context);
                    return;
                  }

                  Constants.showDialogBox(context: context,
                      title: "عدل الحدث",
                      content: ModifyEventWidget(
                        eventModel: currentEvent,
                        eventCubit: eventCubit,
                        state: state,
                      ));
                }

              }

            },
            selectedTileColor: Colors.blueGrey[100],
            selected: eventCubit.currentSelectedEvent == currentEvent,
            title: Text(currentEvent.name),
          );
        },
        itemCount: eventCubit.events.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCubit, EventState>(
      listener: (context, state) {
        if (state is ModifyEventError) {
          Constants.showToast(msg: "ModifyEventError: " + state.msg, context: context);
        }

        if (state is EndModifyEvent) {
          Constants.showToast(msg: "تم بنجاح", color: Colors.green ,context: context);
        }
      },
      builder: (context, state) {
        final eventCubit = EventCubit.get(context);
        return Scaffold(
          appBar: EventsAppBar(eventType: eventsArgs.eventType,
              onSearchChangeCallback: (search) {
                eventCubit.getAllEventsByNameLike(name: search, eventType: eventsArgs.eventType);
              },
              onCancelTapCallback: (isSearch) {
                if (!isSearch) {
                  eventCubit.getAllEventsByNameLike(eventType: eventsArgs.eventType);
                }
              },
              onDoneTapCallback: () {
                Navigator.pop(context, eventCubit.currentSelectedEvent);
              }, onNewTapCallback: () {


            if (Constants.currentEmployee!.permissions.contains(AppStrings.createEvents)) {
              Constants.showDialogBox(context: context,
                  title: "أضف حدث جديد",
                  content: ModifyEventWidget(
                    eventCubit: eventCubit,
                    state: state,
                  ));
            }


            },),
          body: _buildBody(eventCubit, state),
        );
      },
    );
  }
}

class EventsArgs {
  final String eventType;
  final EventModel? eventModel;

  EventsArgs({required this.eventType, this.eventModel});

}




