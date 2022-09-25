import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../cubit/team_members/team_members_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;

class TeamMembersDataTable extends DataTableSource {
  final TeamMembersCubit teamMembersCubit;
  final BuildContext context;
  final Function onSelect;

  TeamMembersDataTable({
    required this.context,
    required this.teamMembersCubit,
    required this.onSelect,
  });

  @override
  DataRow? getRow(int index) {
    final currentTeamMember = teamMembersCubit.teamMembers[index];

    return DataRow.byIndex(
        index: index,
        selected: teamMembersCubit.selectedTeamMembersIds.contains(
            currentTeamMember.employee.employeeId),
        onSelectChanged: (val) {
          onSelect(val, currentTeamMember);
        },
        cells: [
          DataCell(BlocProvider(
            create: (context) => di.sl<EmployeeCubit>(),
            child: BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) {
                final cubit = EmployeeCubit.get(context);
                return DefaultUserAvatarWidget(
                  onTap: () {
                    if (Constants.currentEmployee!.teamId != null &&
                        Constants.currentEmployee!.teamId ==
                            currentTeamMember.userTeamId.teamId) {
                      Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                          arguments: EmployeeDetailsArgs(
                              employeeModel: currentTeamMember.employee,
                              employeeCubit: cubit,
                              fromRoute: Routes.teamsDetailsRoute));
                    }
                  },
                  imageUrl: currentTeamMember.employee.imageUrl,
                  fullName: currentTeamMember.employee.fullName,
                  height: 40.0,);
              },
            ),
          )),


          DataCell(Text(currentTeamMember.employee.fullName)),
          DataCell(Text(Constants.dateTimeFromMilliSeconds(
              currentTeamMember.insertDateTime))),

          DataCell(Text(currentTeamMember.insertedBy != null ? currentTeamMember
              .insertedBy!.fullName : "غير موجود")),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => teamMembersCubit.teamMembersTotalElements;

  @override
  int get selectedRowCount => 0;
}