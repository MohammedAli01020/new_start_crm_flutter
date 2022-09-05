import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/widgets/default_bottom_navigation_widget.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_mmbers/team_members_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/employee_picker_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/modify_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../../core/widgets/waiting_item_widget.dart';

class TeamDetailsScreen extends StatelessWidget {
  final TeamDetailsArgs teamDetailsArgs;

  const TeamDetailsScreen({Key? key, required this.teamDetailsArgs})
      : super(key: key);

  void _getPageEmployees(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<TeamMembersCubit>(context)
        .fetchTeamMembers(refresh: refresh);
  }


  Widget _buildBodyTable() {
    return BlocConsumer<TeamMembersCubit, TeamMembersState>(
      listener: (context, state) {},
      builder: (context, state) {
        final teamMembersCubit = TeamMembersCubit.get(context);

        if (state is StartRefreshTeamMembers ||
            state is StartLoadingTeamMembers) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RefreshTeamMembersError) {
          return ErrorItemWidget(
            msg: state.msg,
            onPress: () {
              _getPageEmployees(refresh: true, context: context);
            },
          );
        }

        return SingleChildScrollView(
          child: SizedBox(
            width: context.width,
            child: PaginatedDataTable(

                columns: const [
                  DataColumn(label: Text('صورة العضو')),
                  DataColumn(label: Text('اسم العضو')),
                  DataColumn(label: Text('تاريخ الانشاء')),
                ],
                header: const Text("الاعضاء"),
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.employeePickerRoute,
                            arguments: EmployeePickerArgs(
                                employeePickerTypes:
                                    EmployeePickerTypes.SELECT_TEAM_MEMBER.name,
                                notInThisTeamId:
                                    teamDetailsArgs.teamModel.teamId));
                      },
                      icon: const Icon(Icons.group_add)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
                ],
                rowsPerPage: 5,
                showCheckboxColumn: true,
                onSelectAll: (val) {

                },

                onPageChanged: (pageIndex) {
                  teamMembersCubit.updateFilter(teamMembersCubit
                      .teamMembersFiltersModel
                      .copyWith(pageNumber: Wrapped.value(pageIndex)));

                  _getPageEmployees(context: context);
                },
                source: TeamMembersDataTable(
                    onSelect: (val, currentTeamMember) {
                      teamMembersCubit.updateSelectedTeamMembers(currentTeamMember, val);
                    },
                    teamMembersCubit: teamMembersCubit)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamCubit, TeamState>(
      listener: (context, state) {
        if (state is DeleteTeamError) {
          Constants.showToast(msg: "DeleteLoanError: " + state.msg);
        }

        if (state is EndDeleteTeam) {
          Constants.showToast(msg: "تم حذف التيم بنجاح", color: Colors.green);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final teamCubit = TeamCubit.get(context);

        if (state is StartDeleteTeam) {
          return const WaitingItemWidget();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("تفاصيل التيم"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("اسم التيم: " + teamDetailsArgs.teamModel.title),
                    const DefaultHeightSizedBox(),
                    const Text("التيم ليدر"),
                    const DefaultHeightSizedBox(),
                    if (teamDetailsArgs.teamModel.teamLeader != null)
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: ClipOval(
                                child: teamDetailsArgs
                                            .teamModel.teamLeader!.imageUrl !=
                                        null
                                    ? CachedNetworkImage(
                                        height: 50.0,
                                        width: 50.0,
                                        fit: BoxFit.cover,
                                        imageUrl: teamDetailsArgs
                                            .teamModel.teamLeader!.imageUrl!,
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
                                          teamDetailsArgs.teamModel.teamLeader!
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
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(teamDetailsArgs.teamModel.teamLeader!.fullName),
                        ],
                      ),
                    if (teamDetailsArgs.teamModel.teamLeader == null)
                      const Text("لا يوجد تيم ليدر"),
                    const DefaultHeightSizedBox(),
                    Text("تاريخ الانشاء: " +
                        Constants.dateTimeFromMilliSeconds(
                            teamDetailsArgs.teamModel.createDateTime)),
                    const DefaultHeightSizedBox(),
                    Text("بواسطه: " +
                        (teamDetailsArgs.teamModel.createdBy != null
                            ? teamDetailsArgs.teamModel.createdBy!.fullName
                            : "غير محدد")),
                    const DefaultHeightSizedBox(),
                    Text("ID: " + teamDetailsArgs.teamModel.teamId.toString()),
                    const Divider(),
                    _buildBodyTable(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: DefaultBottomNavigationWidget(
            onEditTapCallback: () {
              Navigator.pushNamed(context, Routes.modifyTeamRoute,
                  arguments: ModifyTeamArgs(
                      teamCubit: teamCubit,
                      teamModel: teamDetailsArgs.teamModel,
                      fromRoute: teamDetailsArgs.fromRoute));
            },
            omDeleteCallback: (bool result) {
              if (result) {
                teamCubit.deleteTeam(teamDetailsArgs.teamModel.teamId);
              }
            },
          ),
        );
      },
    );
  }
}

class TeamDetailsArgs {
  final TeamModel teamModel;
  final TeamCubit teamCubit;
  final String fromRoute;

  TeamDetailsArgs(
      {required this.teamModel,
      required this.teamCubit,
      required this.fromRoute});
}

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
        selected: teamMembersCubit.selectedTeamMembers.contains(currentTeamMember),
        onSelectChanged: (val) {
          onSelect(val, currentTeamMember);
        },
        cells: [
          DataCell(Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            child: ClipOval(
                child: currentTeamMember.employee.imageUrl != null
                    ? CachedNetworkImage(
                        height: 50.0,
                        width: 50.0,
                        fit: BoxFit.cover,
                        imageUrl: currentTeamMember.employee.imageUrl!,
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                            color: AppColors.hint.withOpacity(0.2),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 25.0,
                        child: Text(
                          currentTeamMember.employee.fullName.characters.first,
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
          )),
          DataCell(Text(currentTeamMember.employee.fullName)),
          DataCell(Text(Constants.dateTimeFromMilliSeconds(
              currentTeamMember.insertDateTime))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => teamMembersCubit.teamMembersTotalElements;

  @override
  int get selectedRowCount => 0;
}
