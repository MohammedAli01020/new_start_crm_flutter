import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/filter_item.dart';
import '../../../../core/widgets/filter_item_for_date.dart';
import '../../../employees/presentation/cubit/employee_cubit.dart';


class EmployeesPickerAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final EmployeeCubit employeeCubit;
  final String employeePickerTypes;

  const EmployeesPickerAppBar(
      {Key? key,
        required this.onSearchChangeCallback,
        required this.onCancelTapCallback,
        required this.employeeCubit,
        required this.employeePickerTypes})
      : super(key: key);

  @override
  State<EmployeesPickerAppBar> createState() => _EmployeesPickerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _EmployeesPickerAppBarState extends State<EmployeesPickerAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
        textInputAction: TextInputAction.go,
        decoration: const InputDecoration(
          hintText: "اسم الموظف او رقمة",
        ),
        onChanged: (search) {
          widget.onSearchChangeCallback(search);
        },
      )
          : widget.employeePickerTypes ==
          EmployeePickerTypes.SELECT_TEAM_LEADER.name || widget.employeePickerTypes ==
          EmployeePickerTypes.ASSIGN_MEMBER.name
          ? const Text("حدد عضو")
          : const Text("حد الاعضاء"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),
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

              if (widget.employeePickerTypes ==
                  EmployeePickerTypes.SELECT_TEAM_LEADER.name)
                FilterItem(
                  currentValue:
                  widget.employeeCubit.employeeFiltersModel.employeeTypes,
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            employeeTypes: Wrapped.value(
                                EmployeeTypes.NOT_TEAM_LEADERS.name)));


                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }

                  },
                  text: 'كل اللي مش تيم ليدر',
                  value: EmployeeTypes.NOT_TEAM_LEADERS.name,
                ),
              if (widget.employeePickerTypes ==
                  EmployeePickerTypes.SELECT_TEAM_LEADER.name)
                FilterItem(
                  currentValue:
                  widget.employeeCubit.employeeFiltersModel.employeeTypes,
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            employeeTypes: Wrapped.value(EmployeeTypes
                                .NOT_TEAM_LEADERS_NOT_IN_TEAM.name)));
                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }
                  },
                  text: 'مش تيم ليدر ومش في تيم',
                  value: EmployeeTypes.NOT_TEAM_LEADERS_NOT_IN_TEAM.name,
                ),
              if (widget.employeePickerTypes ==
                  EmployeePickerTypes.SELECT_TEAM_MEMBER.name ||
                  widget.employeePickerTypes ==
                      EmployeePickerTypes.ASSIGN_MEMBER.name ||
                  widget.employeePickerTypes ==
                      EmployeePickerTypes.SELECT_EMPLOYEE.name
              )
                FilterItem(
                  currentValue:
                  widget.employeeCubit.employeeFiltersModel.employeeTypes,
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            employeeTypes:
                            Wrapped.value(EmployeeTypes.ALL.name)));

                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }
                  },
                  text: 'كل الموظفين',
                  value: EmployeeTypes.ALL.name,
                ),
              if (widget.employeePickerTypes ==
                  EmployeePickerTypes.SELECT_TEAM_MEMBER.name)
                FilterItem(
                  currentValue:
                  widget.employeeCubit.employeeFiltersModel.employeeTypes,
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            employeeTypes: Wrapped.value(
                                EmployeeTypes.NOT_IN_MEMBER.name)));
                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }
                  },
                  text: 'غير عضو في تيم',
                  value: EmployeeTypes.NOT_IN_MEMBER.name,
                ),


              if (widget.employeePickerTypes ==
                  EmployeePickerTypes.ASSIGN_MEMBER.name)
              FilterItem(
                currentValue:
                widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes: Wrapped.value(EmployeeTypes
                              .NOT_ASSIGNED.name)));
                  if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                    widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                  } else {
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  }
                },
                text: 'ليس له عميل',
                value: EmployeeTypes.NOT_ASSIGNED.name,
              ),


              const VerticalDivider(
                thickness: 2.0,
              ),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: const Wrapped.value(null),
                            endDateTime: const Wrapped.value(null)));
                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }
                  },
                  text: "كل الاوقات",
                  startDateMillis: null,
                  endDateMillis: null,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimeOfCurrentMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfCurrentMonthMillis)));
                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }
                  },
                  text: "هل الشهر",
                  startDateMillis: DateTime.now().firstTimeOfCurrentMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfCurrentMonthMillis,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimePreviousMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfPreviousMonthMillis)));

                    if (widget.employeePickerTypes == EmployeePickerTypes.ASSIGN_MEMBER.name) {
                      widget.employeeCubit.fetchEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
                    } else {
                      widget.employeeCubit.fetchEmployees(refresh: true);
                    }
                  },
                  text: "الشهر السابق",
                  startDateMillis: DateTime.now().firstTimePreviousMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfPreviousMonthMillis,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime),
            ],
          ),
        ),
      ),
    );
  }
}