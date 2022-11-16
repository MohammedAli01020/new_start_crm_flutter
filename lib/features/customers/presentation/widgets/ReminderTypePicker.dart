import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:flutter/material.dart';

class ReminderTypePicker extends StatefulWidget {
  final String? reminderTypes;
  final Function onSelectTypeCallback;

  const ReminderTypePicker(
      {Key? key, this.reminderTypes, required this.onSelectTypeCallback})
      : super(key: key);

  @override
  State<ReminderTypePicker> createState() => _ReminderTypePickerState();
}

class _ReminderTypePickerState extends State<ReminderTypePicker> {
  String? currentSelectedType;

  @override
  void initState() {
    super.initState();
    currentSelectedType = widget.reminderTypes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500.0,
      // height: 500.0,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                currentSelectedType = ReminderTypes.ALL.name;
                setState(() {});
                widget.onSelectTypeCallback(ReminderTypes.ALL.name);
                Navigator.pop(context);
              },
              title: const Text("ALL"),
              selected: currentSelectedType == null ||
                  currentSelectedType == ReminderTypes.ALL.name,
            ),
            const Divider(),

            ListTile(
              onTap: () {
                currentSelectedType = ReminderTypes.NOW.name;
                setState(() {});
                widget.onSelectTypeCallback(ReminderTypes.NOW.name);
                Navigator.pop(context);
              },
              title: const Text("NOW"),
              selected:
                  currentSelectedType == ReminderTypes.NOW.name,
            ),
            const Divider(),

            ListTile(
              onTap: () {
                currentSelectedType = ReminderTypes.SKIP.name;
                setState(() {});
                widget.onSelectTypeCallback(ReminderTypes.SKIP.name);
                Navigator.pop(context);
              },
              title: const Text("DELAYED"),
              selected:
                  currentSelectedType == ReminderTypes.SKIP.name,
            ),
            const Divider(),

            ListTile(
              onTap: () {
                currentSelectedType = ReminderTypes.DELAYED.name;
                setState(() {});
                widget.onSelectTypeCallback(ReminderTypes.DELAYED.name);
                Navigator.pop(context);
              },
              title: const Text("UPCOMING"),
              selected:
                  currentSelectedType == ReminderTypes.DELAYED.name,
            ),
          ],
        ),
      ),
    );
  }
}
