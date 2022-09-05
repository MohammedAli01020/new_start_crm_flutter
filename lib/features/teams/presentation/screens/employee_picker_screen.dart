import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../employees/presentation/screens/employees_screen.dart';

class EmployeePickerScreen extends StatefulWidget {
  final EmployeePickerArgs employeePickerArgs;

  const EmployeePickerScreen({Key? key, required this.employeePickerArgs})
      : super(key: key);

  @override
  State<EmployeePickerScreen> createState() => _EmployeePickerScreenState();
}

class _EmployeePickerScreenState extends State<EmployeePickerScreen> {
  List<EmployeeModel> selectedEmployees = [];

  void _getPageEmployees({bool refresh = false}) {
    BlocProvider.of<EmployeeCubit>(context).fetchEmployees(refresh: refresh);
  }

  @override
  void initState() {
    super.initState();

    final employeeCubit = BlocProvider.of<EmployeeCubit>(context);
    if (widget.employeePickerArgs.employeePickerTypes ==
        EmployeePickerTypes.SELECT_TEAM_LEADER.name) {
      employeeCubit.updateFilter(employeeCubit.employeeFiltersModel.copyWith(
        employeeTypes: Wrapped.value(EmployeeTypes.NOT_TEAM_LEADERS.name),
        notInThisTeamId: Wrapped.value(widget.employeePickerArgs.notInThisTeamId),
      ));

      _getPageEmployees(refresh: true);
    } else if (widget.employeePickerArgs.employeePickerTypes ==
        EmployeePickerTypes.SELECT_TEAM_MEMBER.name) {
      employeeCubit.updateFilter(employeeCubit.employeeFiltersModel.copyWith(
        employeeTypes: Wrapped.value(EmployeeTypes.ALL.name),
        notInThisTeamId: Wrapped.value(widget.employeePickerArgs.notInThisTeamId),
      ));

      _getPageEmployees(refresh: true);
    }
  }

  Widget _buildList(EmployeeCubit cubit, EmployeeState state) {
    if (state is StartRefreshEmployees || state is StartLoadingEmployees) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RefreshEmployeesError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _getPageEmployees(refresh: true);
        },
      );
    }

    if (cubit.employees.isEmpty) {
      return const Center(child: Text("فارع ابدأ بالاضافة عن طريق علامة +"));
    }

    return Scrollbar(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int colCount = max(1, (constraints.maxWidth / 135).floor());

        return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: cubit.employees.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colCount,
                childAspectRatio: 1,
                mainAxisExtent: 100.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0),
            itemBuilder: (context, index) {
              final currentEmployee = cubit.employees[index];

              return InkWell(
                onTap: () {
                  if (widget.employeePickerArgs.employeePickerTypes ==
                      EmployeePickerTypes.SELECT_TEAM_LEADER.name) {
                    if (selectedEmployees.contains(currentEmployee)) {
                      selectedEmployees = [];
                    } else {
                      selectedEmployees = [currentEmployee];
                    }
                  } else {
                    if (selectedEmployees.contains(currentEmployee)) {
                      selectedEmployees.remove(currentEmployee);
                    } else {
                      selectedEmployees.add(currentEmployee);
                    }
                  }

                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: ClipOval(
                                child: currentEmployee.imageUrl != null
                                    ? CachedNetworkImage(
                                        height: 50.0,
                                        width: 50.0,
                                        fit: BoxFit.cover,
                                        imageUrl: currentEmployee.imageUrl!,
                                        placeholder: (context, url) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.hint.withOpacity(0.2),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 25.0,
                                        child: Text(
                                          currentEmployee
                                              .fullName.characters.first,
                                          style: const TextStyle(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ))),
                            height: 50.0,
                            width: 50.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (selectedEmployees.contains(currentEmployee))
                            Container(
                              child: const Center(
                                  child: Icon(
                                Icons.done,
                                color: Colors.white,
                              )),
                              decoration: BoxDecoration(
                                  color: Colors.green[300],
                                  shape: BoxShape.circle),
                            )
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        currentEmployee.fullName,
                        style: const TextStyle(
                            fontSize: 14.0),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            });
      },
    ));
  }

  Widget _buildBody(
      {required EmployeeCubit cubit, required EmployeeState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (selectedEmployees.isNotEmpty)
              TextButton(
                  onPressed: () {
                    selectedEmployees.clear();
                    setState(() {});
                  },
                  child: const Text("مسح الكل")),
            const Spacer(),
            TextButton(
                onPressed: () {
                  if (widget.employeePickerArgs.employeePickerTypes ==
                      EmployeePickerTypes.SELECT_TEAM_MEMBER.name) {
                  } else if (widget.employeePickerArgs.employeePickerTypes ==
                      EmployeePickerTypes.SELECT_TEAM_LEADER.name) {
                    EmployeeModel? em;
                    if (selectedEmployees.isNotEmpty) {
                      em = selectedEmployees.first;
                    }
                    Navigator.pop(context, em?.toJson());
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text("تأكيد")),
          ],
        ),
        SizedBox(
          height: 120.0,
          child: selectedEmployees.isEmpty
              ? const Center(child: Text("لا توجد عناصر محددة"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final currentEmployee = selectedEmployees[index];
                    return GestureDetector(
                      onTap: () {
                        selectedEmployees.remove(currentEmployee);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        // padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: ClipOval(
                                      child: currentEmployee.imageUrl != null
                                          ? CachedNetworkImage(
                                              height: 50.0,
                                              width: 50.0,
                                              fit: BoxFit.cover,
                                              imageUrl: currentEmployee.imageUrl!,
                                              placeholder: (context, url) =>
                                                  Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.hint
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: Colors.grey,
                                              radius: 25.0,
                                              child: Text(
                                                currentEmployee
                                                    .fullName.characters.first,
                                                style: const TextStyle(
                                                    fontSize: 25.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ))),
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  child: const Center(
                                      child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  )),
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              currentEmployee.fullName,
                              style: const TextStyle(
                                  fontSize: 14.0),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: selectedEmployees.length),
        ),
        const Divider(),
        Expanded(child: _buildList(cubit, state)),
        if (cubit.employees.isNotEmpty)
          SizedBox(
            width: context.width,
            child: NumberPaginator(
                onPageChange: (index) {
                  cubit.updateFilter(cubit.employeeFiltersModel
                      .copyWith(pageNumber: Wrapped.value(index)));
                  _getPageEmployees(refresh: true);
                },
                initialPage: cubit.employeeCurrentPage,
                numberPages: cubit.employeePagesCount),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final employeeCubit = EmployeeCubit.get(context);
        return Scaffold(
          appBar: EmployeesPickerAppBar(
            employeeCubit: employeeCubit,
            onSearchChangeCallback: (search) {
              employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                  .copyWith(fullNameOrPhoneNumber: Wrapped.value(search)));
              _getPageEmployees(refresh: true);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                    .copyWith(
                        fullNameOrPhoneNumber: const Wrapped.value(null)));

                _getPageEmployees(refresh: true);
              }
            },
            employeePickerTypes: widget.employeePickerArgs.employeePickerTypes,
          ),
          body: _buildBody(cubit: employeeCubit, state: state),
        );
      },
    );
  }
}

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
                  EmployeePickerTypes.SELECT_TEAM_LEADER.name
              ? const Text("حدد تيم ليدر")
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
                    widget.employeeCubit.fetchEmployees(refresh: true);
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
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: 'مش تيم ليدر ومش في تيم',
                  value: EmployeeTypes.NOT_TEAM_LEADERS_NOT_IN_TEAM.name,
                ),
              if (widget.employeePickerTypes ==
                  EmployeePickerTypes.SELECT_TEAM_MEMBER.name)
                FilterItem(
                  currentValue:
                      widget.employeeCubit.employeeFiltersModel.employeeTypes,
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            employeeTypes:
                                Wrapped.value(EmployeeTypes.ALL.name)));
                    widget.employeeCubit.fetchEmployees(refresh: true);
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
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: 'غير عضو في تيم',
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
                    widget.employeeCubit.fetchEmployees(refresh: true);
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
                    widget.employeeCubit.fetchEmployees(refresh: true);
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

                    widget.employeeCubit.fetchEmployees(refresh: true);
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


class EmployeePickerArgs {
  final String employeePickerTypes;
  final int? notInThisTeamId;

  EmployeePickerArgs({required this.employeePickerTypes, this.notInThisTeamId});

}