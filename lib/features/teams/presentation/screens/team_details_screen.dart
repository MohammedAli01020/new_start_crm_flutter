import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/widgets/default_bottom_navigation_widget.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_member_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/user_team_id_model.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/employee_picker_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/modify_team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import '../cubit/team_members/team_members_cubit.dart';
import '../widgets/team_member_data_table.dart';

class TeamDetailsScreen extends StatelessWidget {
  final TeamDetailsArgs teamDetailsArgs;

  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  TeamDetailsScreen({Key? key, required this.teamDetailsArgs})
      : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? _extraScrollSpeed
                  : -_extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  void _getPageEmployees(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<TeamMembersCubit>(context)
        .fetchTeamMembers(refresh: refresh);
  }


  Widget _buildBodyTable() {
    return BlocConsumer<TeamMembersCubit, TeamMembersState>(
      listener: (context, state) {

        if (state is EndDeleteAllTeamMembersByIds) {
          Constants.showToast(msg: "تم حذف الاعضاء المحددين", context: context);
        }

        if (state is DeleteAllTeamMembersByIdsError) {
          Constants.showErrorDialog(context: context, msg: "DeleteAllTeamMembersByIdsError: " + state.msg);
        }

      },
      builder: (context, state) {
        final teamMembersCubit = TeamMembersCubit.get(context);

        // if (state is StartRefreshTeamMembers ||
        //     state is StartLoadingTeamMembers) {
        //   return const Center(child: CircularProgressIndicator());
        // }


        if (state is RefreshTeamMembersError) {
          return ErrorItemWidget(
            msg: state.msg,
            onPress: () {
              _getPageEmployees(refresh: true, context: context);
            },
          );
        }

        return SingleChildScrollView(
          child: Column(

            children: [

              Visibility(
                  visible: state is StartRefreshTeamMembers || state is StartLoadingTeamMembers,
                  child: const LinearProgressIndicator()),
              SizedBox(
                width: context.width,
                child: PaginatedDataTable(

                    columns: const [
                      DataColumn(label: Text('صورة العضو')),
                      DataColumn(label: Text('اسم العضو')),
                      DataColumn(label: Text('تاريخ الاضافة')),
                      DataColumn(label: Text('بواسطة')),

                    ],
                    header: const Text("الاعضاء"),
                    actions: [
                      if (teamMembersCubit.selectedTeamMembersIds.isNotEmpty &&
                          Constants.currentEmployee!.permissions.contains(AppStrings.deleteGroupMembers))
                        state is StartDeleteAllTeamMembersByIds ?
                        const Center(child: SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator())) :IconButton(onPressed: () async {

                        final response = await Constants.showConfirmDialog(context: context, msg: "هل تريد تأكيد الحذف؟");

                        if (response) {
                          List<UserTeamIdModel> userTeamIds = teamMembersCubit.selectedTeamMembersIds.map((e) {
                            return  UserTeamIdModel(employeeId: e, teamId: teamDetailsArgs.teamModel.teamId);
                          }).toList();

                          teamMembersCubit.deleteAllTeamMembersByIds(userTeamIds);
                        }

                      }, icon: const Icon(Icons.delete)),


                      if (Constants.currentEmployee!.permissions.contains(AppStrings.addGroupMembers))
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.employeePickerRoute,
                                arguments: EmployeePickerArgs(
                                    teamMembersCubit: teamMembersCubit,
                                    excludeTeamLeader: teamDetailsArgs.teamModel.teamLeader != null ?
                                    teamDetailsArgs.teamModel.teamLeader!.employeeId : null,
                                    employeePickerTypes:
                                    EmployeePickerTypes.SELECT_TEAM_MEMBER.name,
                                    notInThisTeamId:
                                    teamDetailsArgs.teamModel.teamId));
                          },
                          icon: const Icon(Icons.group_add)),
                    ],
                    rowsPerPage: 5,

                    showCheckboxColumn: true,
                    onSelectAll: (val) {

                      if (val != null && val == false ) {
                        teamMembersCubit.resetSelectedTeamMembers();
                      } else {
                        teamMembersCubit.fetchAllTeamMembersByTeamId(teamDetailsArgs.teamModel.teamId);
                      }
                    },

                    onPageChanged: (pageIndex) {
                      _getPageEmployees(context: context);
                    },
                    source: TeamMembersDataTable(
                        onSelect: (val,TeamMemberModel currentTeamMember) {
                          teamMembersCubit.updateSelectedTeamMembersIds(currentTeamMember.employee.employeeId, val);
                        },
                        teamMembersCubit: teamMembersCubit,
                        context: context)),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildTeamMemberDetails(TeamModel teamModel, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("اسم التيم: " + teamModel.title),
        const DefaultHeightSizedBox(),
        const Text("التيم ليدر"),
        const DefaultHeightSizedBox(),
        if (teamModel.teamLeader != null)
          Row(
            children: [
              DefaultUserAvatarWidget(
                  imageUrl: teamModel.teamLeader?.imageUrl,
                  height: 50.0,
                  fullName: teamModel.teamLeader?.fullName),
              const SizedBox(
                width: 10.0,
              ),
              Text(teamModel.teamLeader!.fullName),
            ],
          ),

        if (teamModel.teamLeader == null)
          const Text("لا يوجد تيم ليدر"),
        const DefaultHeightSizedBox(),
        Text("تاريخ الانشاء: " +
            Constants.dateTimeFromMilliSeconds(
                teamModel.createDateTime)),
        const DefaultHeightSizedBox(),
        Text("بواسطه: " +
            (teamModel.createdBy != null
                ? teamModel.createdBy!.fullName
                : "غير محدد")),
        const DefaultHeightSizedBox(),


        const Divider(),
        const Text("الوصف"),
        const DefaultHeightSizedBox(),
        if (teamModel.description != null)
        InkWell(
          onTap: () {
            if (teamModel.description!.length > 100) {
              Navigator.pushNamed(context, Routes.teamDescriptionRoute,
                  arguments: teamModel.description!);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  teamModel.description!.length > 100
                      ?  teamModel.description!.substring(0, 100) +
                      "..."
                      :  teamModel.description!,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500

                  )),
              if ( teamModel.description!.length > 100)
                TextButton(
                    onPressed: () {

                      Navigator.pushNamed(context, Routes.teamDescriptionRoute,
                          arguments: teamModel.description!);
                    },
                    child: const Text("افرأ اكثر"))
            ],
          ),
        ),

        if (teamModel.description == null)
        const Text("لا يوجد وصف"),
        const DefaultHeightSizedBox(),
        Text("ID: " + teamModel.teamId.toString()),
        const Divider(),
        _buildBodyTable(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamCubit, TeamState>(
      listener: (context, state) {
        if (state is DeleteTeamError) {
          Constants.showToast(msg: "DeleteTeamError: " + state.msg, context: context);
        }

        if (state is EndDeleteTeam) {
          Constants.showToast(msg: "تم حذف التيم بنجاح", color: Colors.green, context: context);
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
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                child: _buildTeamMemberDetails(teamDetailsArgs.teamModel, context),
              ),
            ),
          ),

          bottomNavigationBar: DefaultBottomNavigationWidget(

            withEdit: Constants.currentEmployee!.permissions.contains(AppStrings.editGroups),
            withDelete: Constants.currentEmployee!.permissions.contains(AppStrings.deleteGroups),
            onEditTapCallback: () {
                Navigator.pushNamed(context, Routes.modifyTeamRoute,
                    arguments: ModifyTeamArgs(
                        teamCubit: teamCubit,
                        teamModel: teamDetailsArgs.teamModel,
                        fromRoute: teamDetailsArgs.fromRoute,
                        teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context)));
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


