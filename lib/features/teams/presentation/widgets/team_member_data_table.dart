import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../cubit/team_members/team_members_cubit.dart';


class TeamMembersDataTable extends DataTableSource {
  final TeamMembersCubit teamMembersCubit;
  final Function onSelect;

  TeamMembersDataTable({
    required this.teamMembersCubit,
    required this.onSelect,
  });

  @override
  DataRow? getRow(int index) {
    final currentTeamMember = teamMembersCubit.teamMembers[index];

    return DataRow.byIndex(
        index: index,
        selected: teamMembersCubit.selectedTeamMembersIds.contains(currentTeamMember.employee.employeeId),
        onSelectChanged: (val) {
          onSelect(val, currentTeamMember);
        },
        cells: [
          DataCell(DefaultUserAvatarWidget(
            onTap: () {
              print("llll");
            },
            imageUrl: currentTeamMember.employee.imageUrl,
            fullName: currentTeamMember.employee.fullName,
            height: 40.0,)),
          DataCell(Text(currentTeamMember.employee.fullName)),
          DataCell(Text(Constants.dateTimeFromMilliSeconds(
              currentTeamMember.insertDateTime))),

          DataCell(Text(currentTeamMember.insertedBy != null ? currentTeamMember.insertedBy!.fullName : "غير موجود")),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => teamMembersCubit.teamMembersTotalElements;

  @override
  int get selectedRowCount => 0;
}