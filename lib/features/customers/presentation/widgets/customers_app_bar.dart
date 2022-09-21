import 'package:crm_flutter_project/core/utils/app_colors.dart';
import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/filter_field.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/sources_picker.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/unit_types_picker.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../data/models/event_model.dart';
import '../screens/modify_customer_screen.dart';
import 'CustomerTypePicker.dart';
import 'DateFilterPicker.dart';
import 'ReminderTypePicker.dart';
import 'event_picker.dart';

class CustomersAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final CustomerCubit customerCubit;
  final TeamMembersCubit teamMembersCubit;

  const CustomersAppBar({Key? key,
    required this.onSearchChangeCallback,
    required this.onCancelTapCallback,
    required this.customerCubit,
    required this.teamMembersCubit})
      : super(key: key);

  @override
  State<CustomersAppBar> createState() => _CustomersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _CustomersAppBarState extends State<CustomersAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          hintText: "اسم العميل او رقمة",
        ),
        onChanged: (search) {
          widget.onSearchChangeCallback(search);
        },
      )
          : const Text("العملاء"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),


        if (Constants.currentEmployee!.permissions.contains(AppStrings.creatLead))
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.modifyCustomerRoute,
                arguments: ModifyCustomerArgs(
                    customerCubit: widget.customerCubit,
                    fromRoute: Routes.customersRoute,
                    teamMembersCubit: widget.teamMembersCubit));
          },
          icon: const Icon(Icons.person_add),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SizedBox(
          height: 45,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                  onTap: () {

                    widget.customerCubit.updateFilter(widget.customerCubit.customerFiltersModel.copyWith(
                      sources: const Wrapped.value(null),
                      unitTypes: const Wrapped.value(null),
                      lastEventIds: const Wrapped.value(null),
                      reminderTypes: const Wrapped.value(null),
                      startDateTime: const Wrapped.value(null),
                      endDateTime: const Wrapped.value(null),
                    ));
                    widget.customerCubit.updateSelectedEvents([]);
                    widget.customerCubit.updateSelectedSources([]);
                    widget.customerCubit.updateSelectedUnitTypes([]);

                    Constants.refreshCustomers(widget.customerCubit);


                  },
                  child: const FilterField(
                    text: Text("حذف الفلاتر"),
                  )),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                      context: context,
                      title: "حدد العملاء",
                      content: CustomerTypePicker(
                        customerTypes: widget
                            .customerCubit.customerFiltersModel.customerTypes,
                        onSelectTypeCallback: (String? customerTypes) {
                          widget.customerCubit.updateFilter(widget
                              .customerCubit.customerFiltersModel
                              .copyWith(
                            customerTypes: Wrapped.value(customerTypes),
                            teamId: Wrapped.value(
                                Constants.currentEmployee?.teamId),
                            employeeId: Wrapped.value(
                                Constants.currentEmployee?.employeeId),
                          ));


                          widget.customerCubit.fetchCustomers(refresh: true);
                        },
                      ),
                    );
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(_getCustomerType(widget
                            .customerCubit.customerFiltersModel.customerTypes)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.customerCubit.customerFiltersModel
                              .customerTypes !=
                              null &&
                              widget.customerCubit.customerFiltersModel
                                  .customerTypes !=
                                  CustomerTypes.ALL.name
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب التذكير",
                        content: ReminderTypePicker(
                          reminderTypes: widget.customerCubit
                              .customerFiltersModel.reminderTypes,
                          onSelectTypeCallback: (String? reminderTypes) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                              reminderTypes: Wrapped.value(reminderTypes),
                            ));
                            Constants.refreshCustomers(widget.customerCubit);
                          },

                        )
                    );
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(_getReminderType(widget
                            .customerCubit.customerFiltersModel.reminderTypes)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.customerCubit.customerFiltersModel
                              .reminderTypes !=
                              null &&
                              widget.customerCubit.customerFiltersModel
                                  .reminderTypes !=
                                  ReminderTypes.ALL.name
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                      context: context,
                      title: "حدد الحدث",
                      content: EventsPicker(
                        selectedEvents:
                        widget.customerCubit.selectedEvents ?? [],
                        onConfirmCallback: (List<EventModel> selected) {

                          widget.customerCubit.updateFilter(widget
                              .customerCubit.customerFiltersModel
                              .copyWith(
                              lastEventIds: Wrapped.value(selected.isEmpty
                                  ? null
                                  : selected
                                  .map((e) => e.eventId)
                                  .toList())));

                          widget.customerCubit.updateSelectedEvents(
                              selected.isEmpty ? null : selected);

                          Constants.refreshCustomers(widget.customerCubit);

                          Navigator.of(context).pop(false);


                        },
                      ),
                    );
                  },
                  child: FilterField(
                      text: Row(
                        children: [
                          Text(
                            widget.customerCubit.selectedEvents != null &&
                                widget.customerCubit.selectedEvents!.isNotEmpty
                                ? (widget.customerCubit.selectedEvents!.length >
                                1
                                ? widget.customerCubit.selectedEvents!
                                .map((e) => e.name)
                                .toList()
                                .sublist(0, 1)
                                .toString() +
                                ", ${widget.customerCubit.selectedEvents!
                                    .length - 1} other"
                                : widget.customerCubit.selectedEvents!
                                .map((e) => e.name)
                                .toList()
                                .toString())
                                : "كل الاحداث",
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: widget.customerCubit.selectedEvents !=
                                  null &&
                                  widget
                                      .customerCubit.selectedEvents!.isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                        ],
                      ))),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب التاريخ",
                        content: DateFilterPicker(
                          startDateTime: widget.customerCubit
                              .customerFiltersModel.startDateTime,
                          endDateTime: widget.customerCubit.customerFiltersModel
                              .endDateTime,
                          onSelectTypeCallback: (int? start, int? end) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel.copyWith(
                              startDateTime: Wrapped.value(start),
                              endDateTime: Wrapped.value(end),
                            ));

                            Constants.refreshCustomers(widget.customerCubit);
                          },

                        )
                    );
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(_getDateType(widget
                            .customerCubit.customerFiltersModel.startDateTime,
                          widget
                              .customerCubit.customerFiltersModel
                              .endDateTime,)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.customerCubit.customerFiltersModel
                              .startDateTime != null &&
                              widget.customerCubit.customerFiltersModel
                                  .endDateTime != null
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر انواع الوحدات",
                        content: UnitTypesPicker(
                          selectedUnitTypes: widget.customerCubit.customerFiltersModel.unitTypes ?? [],
                          onConfirmCallback: (List<String> selectedUnitTypes) {

                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                                unitTypes: Wrapped.value(selectedUnitTypes.isEmpty
                                    ? null
                                    : selectedUnitTypes)));

                            widget.customerCubit.updateSelectedUnitTypes(
                                selectedUnitTypes.isEmpty ? null : selectedUnitTypes);

                            Constants.refreshCustomers(widget.customerCubit);
                            Navigator.of(context).pop(false);
                          },


                        )
                    );
                  },
                  child: FilterField(
                      text: Row(
                        children: [
                          Text(
                            widget.customerCubit.selectedUnitTypes != null &&
                                widget.customerCubit.selectedUnitTypes!.isNotEmpty
                                ? (widget.customerCubit.selectedUnitTypes!.length >
                                1
                                ? widget.customerCubit.selectedUnitTypes!
                                .sublist(0, 1)
                                .toString() +
                                ", ${widget.customerCubit.selectedUnitTypes!
                                    .length - 1} other"
                                : widget.customerCubit.selectedUnitTypes!
                                .toString())
                                : "كل الوحدات",
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: widget.customerCubit.selectedUnitTypes !=
                                  null &&
                                  widget
                                      .customerCubit.selectedUnitTypes!.isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                        ],
                      ))),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب المصادر",
                        content: SourcesPicker(
                          selectedSources: widget.customerCubit.customerFiltersModel.sources ?? [],
                          onConfirmCallback: (List<String> selectedSources) {

                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                                sources: Wrapped.value(selectedSources.isEmpty
                                    ? null
                                    : selectedSources)));

                            widget.customerCubit.updateSelectedSources(
                                selectedSources.isEmpty ? null : selectedSources);

                            Constants.refreshCustomers(widget.customerCubit);
                            Navigator.of(context).pop(false);
                          },


                        )
                    );
                  },
                  child: FilterField(
                      text: Row(
                        children: [
                          Text(
                            widget.customerCubit.selectedSources != null &&
                                widget.customerCubit.selectedSources!.isNotEmpty
                                ? (widget.customerCubit.selectedSources!.length >
                                1
                                ? widget.customerCubit.selectedSources!
                                .sublist(0, 1)
                                .toString() +
                                ", ${widget.customerCubit.selectedSources!
                                    .length - 1} other"
                                : widget.customerCubit.selectedSources!
                                .toString())
                                : "كل المصادر",
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: widget.customerCubit.selectedSources !=
                                  null &&
                                  widget
                                      .customerCubit.selectedSources!.isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }




  String _getCustomerType(String? customerTypes) {
    if (customerTypes == CustomerTypes.ME.name) {
      return "المعينين لي";
    } else if (customerTypes == CustomerTypes.ME_AND_TEAM.name) {
      return "انا وفريقي";
    } else if (customerTypes == CustomerTypes.TEAM.name) {
      return "فريقي";
    } else if (customerTypes == CustomerTypes.NOT_ASSIGNED.name) {
      return "غير معينين";
    } else {
      return "كل العملاء";
    }
  }

  String _getReminderType(String? reminderTypes) {
    if (reminderTypes == ReminderTypes.NOW.name) {
      return "حان موعد الاتصال";
    } else if (reminderTypes == ReminderTypes.SKIP.name) {
      return "فات موعد الاتصال";
    } else if (reminderTypes == ReminderTypes.DELAYED.name) {
      return "المؤجلين";
    } else {
      return "حسب التذكير";
    }
  }

  String _getDateType(int? startDateTime, int? endDateTime) {
    if (startDateTime == null && endDateTime == null) {
      return "كل الاوقات";
    } else if (startDateTime == DateTime.now().firstTimOfCurrentDayMillis &&
        endDateTime == DateTime.now().lastTimOfCurrentDayMillis) {
      return "هذا اليوم";
    } else if (startDateTime == DateTime.now().firstTimeOfCurrentMonthMillis &&
        endDateTime == DateTime.now().lastTimOfCurrentMonthMillis) {
      return "هذا الشهر";
    } else if (startDateTime == DateTime.now().firstTimePreviousMonthMillis &&
        endDateTime == DateTime.now().lastTimOfPreviousMonthMillis) {
      return "الشهر السابق";
    } else {

      String from = startDateTime != null ? (" من " + Constants.dateFromMilliSeconds(startDateTime)) : "";
      String to = endDateTime != null ? (" ألي " + Constants.dateFromMilliSeconds(endDateTime)) : "";

      return from + to;
    }
  }

  }
