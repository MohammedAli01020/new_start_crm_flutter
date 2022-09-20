import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../domain/use_cases/team_member_use_cases.dart';
import '../widgets/employees_grid_view.dart';
import '../widgets/employess_picker_app_bar.dart';
import '../widgets/selected_employee_list_view.dart';

class EmployeePickerScreen extends StatefulWidget {
  final EmployeePickerArgs employeePickerArgs;

  const EmployeePickerScreen({Key? key, required this.employeePickerArgs})
      : super(key: key);

  @override
  State<EmployeePickerScreen> createState() => _EmployeePickerScreenState();
}

class _EmployeePickerScreenState extends State<EmployeePickerScreen> {
  List<EmployeeModel> selectedEmployees = [];

  void _getPageEmployees({bool refresh = false, String? employeePickerTypes}) {
    BlocProvider.of<EmployeeCubit>(context).fetchEmployees(refresh: refresh, employeePickerTypes: employeePickerTypes);
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
        excludeTeamLeader: Wrapped.value(widget.employeePickerArgs.excludeTeamLeader),
      ));

      _getPageEmployees(refresh: true);

    } else if (widget.employeePickerArgs.employeePickerTypes ==
        EmployeePickerTypes.SELECT_TEAM_MEMBER.name) {
      employeeCubit.updateFilter(employeeCubit.employeeFiltersModel.copyWith(
        employeeTypes: Wrapped.value(EmployeeTypes.ALL.name),
        notInThisTeamId: Wrapped.value(widget.employeePickerArgs.notInThisTeamId),
        excludeTeamLeader: Wrapped.value(widget.employeePickerArgs.excludeTeamLeader),
      ));

      _getPageEmployees(refresh: true);

    } else if (widget.employeePickerArgs.employeePickerTypes ==
        EmployeePickerTypes.ASSIGN_MEMBER.name) {

    employeeCubit.updateFilter(employeeCubit.employeeFiltersModel.copyWith(
        employeeTypes: Wrapped.value(EmployeeTypes.ALL.name),
    ));

    _getPageEmployees(refresh: true, employeePickerTypes: EmployeePickerTypes.ASSIGN_MEMBER.name);
    } else if (widget.employeePickerArgs.employeePickerTypes ==
        EmployeePickerTypes.SELECT_EMPLOYEE.name) {

        employeeCubit.updateFilter(employeeCubit.employeeFiltersModel.copyWith(
          employeeTypes: Wrapped.value(EmployeeTypes.ALL.name),
        ));
      _getPageEmployees(refresh: true);
    }
  }

  Widget _buildList(EmployeeCubit cubit, EmployeeState state) {

    // if (state is StartRefreshEmployees || state is StartLoadingEmployees) {
    //   return const Center(child: CircularProgressIndicator());
    // }


    if (state is RefreshEmployeesError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _getPageEmployees(refresh: true, employeePickerTypes: widget.employeePickerArgs.employeePickerTypes);
        },
      );
    }

    if (cubit.employees.isEmpty && (state is EndRefreshTeamMembers)) {
      return const Center(child: Text("فارع ابدأ بالاضافة عن طريق علامة +"));
    }

    return EmployeesGridView(
      onEmployeeSelectCallback: (EmployeeModel currentEmployee) {
        if (widget.employeePickerArgs.employeePickerTypes ==
            EmployeePickerTypes.SELECT_TEAM_LEADER.name ||
            widget.employeePickerArgs.employeePickerTypes ==
                EmployeePickerTypes.ASSIGN_MEMBER.name ||
            widget.employeePickerArgs.employeePickerTypes ==
                EmployeePickerTypes.SELECT_EMPLOYEE.name
        ) {
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
      employees: cubit.employees,
      selectedEmployees: selectedEmployees,
    );
  }

  Widget _buildBody(
      {required EmployeeCubit cubit, required EmployeeState state}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (selectedEmployees.isNotEmpty)
                OutlinedButton(
                    onPressed: () {
                      selectedEmployees.clear();
                      setState(() {});
                    },
                    child: const Text("مسح الكل")),
              const Spacer(),

              BlocConsumer<TeamMembersCubit, TeamMembersState>(
                listener: (context, state) {
                  if (state is InsertBulkTeamMembersError) {
                    Constants.showConfirmDialog(
                        context: context,
                        msg: "InsertBulkTeamMembersError: " + state.msg);
                  }

                  if (state is EndInsertBulkTeamMembers) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  final teamMembersCubit = TeamMembersCubit.get(context);

                  if (state is StartInsertBulkTeamMembers) {
                    return const Center(child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator()));
                  }

                  return OutlinedButton(
                      onPressed: () {
                        if (widget.employeePickerArgs.employeePickerTypes ==
                            EmployeePickerTypes.SELECT_TEAM_MEMBER.name) {
                          if (selectedEmployees.isEmpty) {
                            Constants.showToast(msg: "لا توجد اعضاء محددة لاضافتهم", context: context);
                            return;
                          }
                          teamMembersCubit.insertBulkTeamMembers(
                              InsertBulkTeamMembersParam(
                                  insertedByEmployeeId:
                                      Constants.currentEmployee?.employeeId,
                                  teamId: widget
                                      .employeePickerArgs.notInThisTeamId!,
                                  insertDateTime:
                                      DateTime.now().millisecondsSinceEpoch,
                                  employeeIds: selectedEmployees
                                      .map((e) => e.employeeId)
                                      .toList()));
                        } else if (widget
                                .employeePickerArgs.employeePickerTypes ==
                            EmployeePickerTypes.SELECT_TEAM_LEADER.name ||
                            widget
                                .employeePickerArgs.employeePickerTypes ==
                                EmployeePickerTypes.ASSIGN_MEMBER.name ||
                            widget
                                .employeePickerArgs.employeePickerTypes ==
                                EmployeePickerTypes.SELECT_EMPLOYEE.name ) {
                          EmployeeModel? em;
                          if (selectedEmployees.isNotEmpty) {
                            em = selectedEmployees.first;
                          }
                          Navigator.pop(context, em?.toJson());
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("تأكيد"));
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120.0,
          child: selectedEmployees.isEmpty
              ? const Center(child: Text("لا توجد عناصر محددة"))
              : SelectedEmployeeListView(
                  onRemoveEmployeeCallback: (EmployeeModel employeeModel) {
                    selectedEmployees.remove(employeeModel);
                    setState(() {});
                  },
                  selectedEmployees: selectedEmployees,
                ),
        ),
        const Divider(),

        Visibility(
            visible: state is StartRefreshEmployees || state is StartLoadingEmployees,
            child: const LinearProgressIndicator()),
        Expanded(child: _buildList(cubit, state)),
        if (cubit.employees.isNotEmpty)
          SizedBox(
            width: context.width,
            child: NumberPaginator(
                onPageChange: (index) {
                  cubit.updateFilter(cubit.employeeFiltersModel
                      .copyWith(pageNumber: Wrapped.value(index)));
                  _getPageEmployees(refresh: true, employeePickerTypes: widget.employeePickerArgs.employeePickerTypes);
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
              _getPageEmployees(refresh: true, employeePickerTypes: widget.employeePickerArgs.employeePickerTypes);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                    .copyWith(
                        fullNameOrPhoneNumber: const Wrapped.value(null)));

                _getPageEmployees(refresh: true, employeePickerTypes: widget.employeePickerArgs.employeePickerTypes);
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

class EmployeePickerArgs {
  final String employeePickerTypes;
  final int? notInThisTeamId;
  final int? excludeTeamLeader;
  final TeamMembersCubit teamMembersCubit;

  EmployeePickerArgs({
    required this.employeePickerTypes,
    this.excludeTeamLeader,

    this.notInThisTeamId,
    required this.teamMembersCubit,
  });
}
