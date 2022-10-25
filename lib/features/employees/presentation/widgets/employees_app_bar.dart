import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/filter_item.dart';
import '../../../../core/widgets/filter_item_for_date.dart';
import '../cubit/employee_cubit.dart';
import '../screens/modify_employee_screen.dart';

class EmployeesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final EmployeeCubit employeeCubit;
  final VoidCallback onFilterCallback;

  const EmployeesAppBar(
      {Key? key,
        required this.onSearchChangeCallback,
        required this.onCancelTapCallback,
        required this.employeeCubit,
        required this.onFilterCallback})
      : super(key: key);

  @override
  State<EmployeesAppBar> createState() => _EmployeesAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _EmployeesAppBarState extends State<EmployeesAppBar> {
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
          : const Text("الموظفون"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),

        if (Constants.currentEmployee!.permissions.contains(AppStrings.createEmployees))
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.modifyEmployeeRoute,
                arguments:
                ModifyEmployeeArgs(
                    employeeCubit: widget.employeeCubit,
                    fromRoute: Routes.employeesRoute));
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
          if (Constants.currentEmployee!.permissions.contains(AppStrings.viewEmployees))
              FilterItem(
                currentValue:
                widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(widget
                      .employeeCubit.employeeFiltersModel
                      .copyWith(employeeTypes: Wrapped.value(EmployeeTypes.ALL.name)));

                  widget.onFilterCallback();
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'الكل',
                value: EmployeeTypes.ALL.name,
              ),


              if (Constants.currentEmployee!.permissions.contains(AppStrings.viewCreatedEmployees) ||
                  Constants.currentEmployee!.permissions.contains(AppStrings.viewEmployees))
              FilterItem(
                currentValue:
                widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(widget
                      .employeeCubit.employeeFiltersModel
                      .copyWith(
                      createdById: Wrapped.value(Constants.currentEmployee!.employeeId),
                      employeeTypes: Wrapped.value(EmployeeTypes.I_CREATED.name)));

                  widget.onFilterCallback();
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'اللي ضفتهم',
                value: EmployeeTypes.I_CREATED.name
              ),

              if (Constants.currentEmployee!.permissions.contains(AppStrings.viewEmployees))
              FilterItem(
                currentValue:
                widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes:
                          Wrapped.value(EmployeeTypes.NOT_ASSIGNED.name)));

                  widget.onFilterCallback();
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'ليس له عميل',
                value: EmployeeTypes.NOT_ASSIGNED.name,
              ),
              if (Constants.currentEmployee!.permissions.contains(AppStrings.viewEmployees))
              FilterItem(
                currentValue:
                widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes:
                          Wrapped.value(EmployeeTypes.TEAM_LEADERS.name)));


                  widget.onFilterCallback();
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'تيم ليدرز',
                value: EmployeeTypes.TEAM_LEADERS.name,
              ),

              if (Constants.currentEmployee!.permissions.contains(AppStrings.viewEmployees))
              FilterItem(
                currentValue:
                widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes:
                          Wrapped.value(EmployeeTypes.NOT_IN_MEMBER.name)));


                  widget.onFilterCallback();
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'ليس له تيم',
                value: EmployeeTypes.NOT_IN_MEMBER.name,
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


                    widget.onFilterCallback();
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: "كل الاوقات",
                  startDateMillis: null,
                  endDateMillis: null,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime

              ),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimeOfCurrentMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfCurrentMonthMillis)));


                    widget.onFilterCallback();
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },

                  text: "هذا الشهر",
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


                    widget.onFilterCallback();
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: "الشهر السابق",
                  startDateMillis: DateTime.now().firstTimePreviousMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfPreviousMonthMillis,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime

              ),
            ],
          ),
        ),
      ),
    );
  }
}