import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_item_widget.dart';
import '../../../events/presentation/cubit/event_cubit.dart';
import '../../data/models/event_model.dart';

class EventsPicker extends StatelessWidget {
  final List<EventModel> selectedEvents;
  final Function onConfirmCallback;

  const EventsPicker(
      {Key? key, required this.selectedEvents, required this.onConfirmCallback})
      : super(key: key);

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
              SizedBox(
                height: 500.0,
                width: 500.0,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final currentEvent = eventCubit.events[index];
                    return ListTile(
                      onTap: () {
                        eventCubit.updateSelectedEvents(currentEvent);
                      },
                      // selectedTileColor: Colors.blueGrey[100],
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
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      onConfirmCallback(eventCubit.selectedEvents);
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.black,
                        textStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    child: const Text('تأكيد'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                        primary: Colors.black,
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
            ],
          );
        },
      ),
    );
  }
}
