import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../events/presentation/cubit/event_cubit.dart';
import '../../data/models/event_model.dart';

class EventsPicker extends StatelessWidget {
  final List<EventModel> selectedEvents;
  final Function onConfirmCallback;

  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;
   EventsPicker(
      {Key? key, required this.selectedEvents, required this.onConfirmCallback})
      : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? _extraScrollSpeed
                  : -_extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<EventCubit>()
        ..setSelectedEvents(selectedEvents)
        ..getAllEventsByNameLike(),
      child: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          final eventCubit = EventCubit.get(context);
          if (state is StartGetAllEventsByNameLike) {
            return const SizedBox(
                height: 500.0,
                width: 500.0,
                child: Center(child: CircularProgressIndicator()));
          }

          if (state is GetAllEventsByNameLikeError) {
            return SizedBox(
              height: 500.0,
              width: 500.0,
              child: ErrorItemWidget(
                msg: state.msg,
                onPress: () {
                  eventCubit.getAllEventsByNameLike();
                },
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      onConfirmCallback(eventCubit.selectedEvents);
                    },
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    child: const Text('تأكيد'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    child: const Text('إلغاء'),
                  ),

                  TextButton(
                    onPressed: () {
                      eventCubit.resetSelectedEvents();
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.red,
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    child: const Text('مسح الكل'),
                  ),
                ],
              ),
              SizedBox(
                height: 500.0,
                width: 500.0,
                child: ListView.separated(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    final currentEvent = eventCubit.events[index];
                    return ListTile(
                      onTap: () {
                        eventCubit.updateSelectedEvents(currentEvent);
                      },
                      selected:
                          eventCubit.selectedEvents.contains(currentEvent),
                      title: Text(currentEvent.name),
                    );
                  },
                  itemCount: eventCubit.events.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
