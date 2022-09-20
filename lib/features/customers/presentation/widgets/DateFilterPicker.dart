
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateFilterPicker extends StatefulWidget {
  final int? startDateTime;
  final int? endDateTime;

  final Function onSelectTypeCallback;

  const DateFilterPicker(
      {Key? key, this.startDateTime, this.endDateTime, required this.onSelectTypeCallback})
      : super(key: key);

  @override
  State<DateFilterPicker> createState() => _DateFilterPickerState();
}

class _DateFilterPickerState extends State<DateFilterPicker> {
  int? start;
  int? end;

  @override
  void initState() {
    super.initState();
    start = widget.startDateTime;
    end = widget.endDateTime;
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

                start = null;
                end = null;
                setState(() {});
                widget.onSelectTypeCallback(start, end);
                Navigator.pop(context);
              },
              title: const Text("كل الاوقات"),
              selected: start == null && end == null,
            ),
            const Divider(),

            ListTile(
              onTap: () {
                start = DateTime.now().firstTimOfCurrentDayMillis;
                end = DateTime.now().lastTimOfCurrentDayMillis;

                setState(() {});

                widget.onSelectTypeCallback(start, end);
                Navigator.pop(context);
              },
              title: const Text("هذا اليوم"),
              selected: start == DateTime.now().firstTimOfCurrentDayMillis &&
                  end == DateTime.now().lastTimOfCurrentDayMillis,
            ),
            const Divider(),


            ListTile(
              onTap: () {
                start = DateTime.now().firstTimeOfCurrentMonthMillis;
                end = DateTime.now().lastTimOfCurrentMonthMillis;

                setState(() {});

                widget.onSelectTypeCallback(start, end);
                Navigator.pop(context);
              },
              title: const Text("هذا الشهر"),
              selected: start == DateTime.now().firstTimeOfCurrentMonthMillis &&
                  end == DateTime.now().lastTimOfCurrentMonthMillis,
            ),
            const Divider(),

            ListTile(
              onTap: () {
                start = DateTime.now().firstTimePreviousMonthMillis;
                end = DateTime.now().lastTimOfPreviousMonthMillis;

                setState(() {});

                widget.onSelectTypeCallback(start, end);
                Navigator.pop(context);
              },
              title: const Text("الشهر السابق"),
              selected: start == DateTime.now().firstTimePreviousMonthMillis &&
                  end == DateTime.now().lastTimOfPreviousMonthMillis,
            ),
            const Divider(),

            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Card(
                    child: ListTile(
                      onTap: () async {
                        final startPicked = await showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 2),
                            lastDate: DateTime(DateTime.now().year + 2));

                        if (startPicked != null) {
                          start = startPicked.millisecondsSinceEpoch;
                          setState(() {});
                        }
                      },
                      title: const Text("من"),
                      subtitle: Text(Constants.dateFromMilliSeconds(start)),
                    ),
                  ),

                  Card(
                    child: ListTile(
                      onTap: () async {
                        final endPicked = await showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 2),
                            lastDate: DateTime(DateTime.now().year + 2));

                        if (endPicked != null) {
                          end = endPicked.millisecondsSinceEpoch;
                          setState(() {});
                        }
                      },
                      title: const Text("ألي"),
                      subtitle: Text(Constants.dateFromMilliSeconds(end)),
                    ),
                  ),

                  const DefaultHeightSizedBox(),

                  SizedBox(
                    width: context.width,
                    child: OutlinedButton(

                        onPressed: () {
                          widget.onSelectTypeCallback(start, end);
                          Navigator.pop(context);
                    }, child: const Text("فلتر")),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// const VerticalDivider(
//   thickness: 2.0,
// ),
// FilterItemForDate(
//     onTapCallback: () {
//       widget.customerCubit.updateFilter(
//           widget.customerCubit.customerFiltersModel.copyWith(
//               startDateTime: const Wrapped.value(null),
//               endDateTime: const Wrapped.value(null)));
//       widget.customerCubit.fetchCustomers(refresh: true);
//     },
//     text: "كل الاوقات",
//     startDateMillis: null,
//     endDateMillis: null,
//     currentStartDateMillis:
//         widget.customerCubit.customerFiltersModel.startDateTime,
//     currentEndDateMillis:
//         widget.customerCubit.customerFiltersModel.endDateTime),
// FilterItemForDate(
//     onTapCallback: () {
//       widget.customerCubit.updateFilter(
//           widget.customerCubit.customerFiltersModel.copyWith(
//               startDateTime: Wrapped.value(
//                   DateTime.now().firstTimeOfCurrentMonthMillis),
//               endDateTime: Wrapped.value(
//                   DateTime.now().lastTimOfCurrentMonthMillis)));
//       widget.customerCubit.fetchCustomers(refresh: true);
//     },
//     text: "هل الشهر",
//     startDateMillis: DateTime.now().firstTimeOfCurrentMonthMillis,
//     endDateMillis: DateTime.now().lastTimOfCurrentMonthMillis,
//     currentStartDateMillis:
//         widget.customerCubit.customerFiltersModel.startDateTime,
//     currentEndDateMillis:
//         widget.customerCubit.customerFiltersModel.endDateTime),
// FilterItemForDate(
//     onTapCallback: () {
//       widget.customerCubit.updateFilter(
//           widget.customerCubit.customerFiltersModel.copyWith(
//               startDateTime: Wrapped.value(
//                   DateTime.now().firstTimePreviousMonthMillis),
//               endDateTime: Wrapped.value(
//                   DateTime.now().lastTimOfPreviousMonthMillis)));
//
//       widget.customerCubit.fetchCustomers(refresh: true);
//     },
//     text: "الشهر السابق",
//     startDateMillis: DateTime.now().firstTimePreviousMonthMillis,
//     endDateMillis: DateTime.now().lastTimOfPreviousMonthMillis,
//     currentStartDateMillis:
//         widget.customerCubit.customerFiltersModel.startDateTime,
//     currentEndDateMillis:
//         widget.customerCubit.customerFiltersModel.endDateTime),