import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';


class EventsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final Function onDoneTapCallback;
  final VoidCallback onNewTapCallback;

  final String eventType;

  const EventsAppBar({Key? key,
    required this.onSearchChangeCallback,
    required this.onCancelTapCallback,
    required this.onNewTapCallback,
    required this.eventType,
    required this.onDoneTapCallback}) : super(key: key);

  @override
  _EventsAppBarState createState() => _EventsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EventsAppBarState extends State<EventsAppBar> {
  bool isSearch = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          hintText: "اسم الحدث",
        ),
        onChanged: (search) {
          widget.onSearchChangeCallback(search);
        },
      )
          : const Text("الاحداث"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),

        if (widget.eventType == EventType.SELECT_EVENT.name)
          IconButton(
              onPressed: () {
                widget.onDoneTapCallback();
              },
              icon: const Icon(Icons.done)),


        if (Constants.currentEmployee!.permissions.contains(AppStrings.createEvents))
        IconButton(onPressed: widget.onNewTapCallback,
            icon: const Icon(Icons.add))

      ],
    );
  }
}