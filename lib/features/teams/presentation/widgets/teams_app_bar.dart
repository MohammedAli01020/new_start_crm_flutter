import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/filter_item.dart';
import '../../../../core/widgets/filter_item_for_date.dart';
import '../cubit/team_cubit.dart';
import '../cubit/team_members/team_members_cubit.dart';
import '../screens/modify_team_screen.dart';

class TeamsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final TeamCubit teamCubit;
  final TeamMembersCubit teamMembersCubit;

  const TeamsAppBar(
      {Key? key,
      required this.onSearchChangeCallback,
      required this.onCancelTapCallback,
      required this.teamCubit,
      required this.teamMembersCubit})
      : super(key: key);

  @override
  State<TeamsAppBar> createState() => _TeamsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _TeamsAppBarState extends State<TeamsAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                hintText: "اسم التيم او الوصف",
              ),
              onChanged: (search) {
                widget.onSearchChangeCallback(search);
              },
            )
          : const Text("المجموعات"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),
        if (Constants.currentEmployee!.permissions
            .contains(AppStrings.createGroups))
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.modifyTeamRoute,
                  arguments: ModifyTeamArgs(
                      teamMembersCubit: widget.teamMembersCubit,
                      teamCubit: widget.teamCubit,
                      fromRoute: Routes.teamsRoute),
                );
              },
              icon: const Icon(Icons.group_add))
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
              if (Constants.currentEmployee!.permissions
                  .contains(AppStrings.viewAllGroups))
                FilterItem(
                  currentValue: widget.teamCubit.teamFiltersModel.teamTypes,
                  onTapCallback: () {
                    widget.teamCubit.updateFilter(
                        widget.teamCubit.teamFiltersModel.copyWith(
                            teamTypes: Wrapped.value(TeamTypes.ALL.name)));
                    widget.teamCubit
                        .fetchTeams(refresh: true, isWebPagination: true);
                  },
                  text: 'الكل',
                  value: TeamTypes.ALL.name,
                ),

              if (Constants.currentEmployee!.permissions.contains(AppStrings.viewOwnGroups) )
                FilterItem(
                    currentValue: widget.teamCubit.teamFiltersModel.teamTypes,
                    onTapCallback: () {
                      widget.teamCubit.updateFilter(
                          widget.teamCubit.teamFiltersModel.copyWith(
                              createdByEmployeeId: Wrapped.value(
                                  Constants.currentEmployee!.employeeId),
                              teamTypes: Wrapped.value(TeamTypes.ME.name),
                              teamLeaderId: Wrapped.value(
                                  Constants.currentEmployee!.employeeId)));
                      widget.teamCubit
                          .fetchTeams(refresh: true, isWebPagination: true);
                    },
                    text: 'اللي ضفتهم والتابعين لي',
                    value: TeamTypes.ME.name),

              const VerticalDivider(
                thickness: 2.0,
              ),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.teamCubit.updateFilter(
                        widget.teamCubit.teamFiltersModel.copyWith(
                            startDateTime: const Wrapped.value(null),
                            endDateTime: const Wrapped.value(null)));
                    widget.teamCubit
                        .fetchTeams(refresh: true, isWebPagination: true);
                  },
                  text: "كل الاوقات",
                  startDateMillis: null,
                  endDateMillis: null,
                  currentStartDateMillis:
                      widget.teamCubit.teamFiltersModel.startDateTime,
                  currentEndDateMillis:
                      widget.teamCubit.teamFiltersModel.endDateTime),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.teamCubit.updateFilter(
                        widget.teamCubit.teamFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimeOfCurrentMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfCurrentMonthMillis)));
                    widget.teamCubit
                        .fetchTeams(refresh: true, isWebPagination: true);
                  },
                  text: "هذا الشهر",
                  startDateMillis: DateTime.now().firstTimeOfCurrentMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfCurrentMonthMillis,
                  currentStartDateMillis:
                      widget.teamCubit.teamFiltersModel.startDateTime,
                  currentEndDateMillis:
                      widget.teamCubit.teamFiltersModel.endDateTime),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.teamCubit.updateFilter(
                        widget.teamCubit.teamFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimePreviousMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfPreviousMonthMillis)));

                    widget.teamCubit
                        .fetchTeams(refresh: true, isWebPagination: true);
                  },
                  text: "الشهر السابق",
                  startDateMillis: DateTime.now().firstTimePreviousMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfPreviousMonthMillis,
                  currentStartDateMillis:
                      widget.teamCubit.teamFiltersModel.startDateTime,
                  currentEndDateMillis:
                      widget.teamCubit.teamFiltersModel.endDateTime),
            ],
          ),
        ),
      ),
    );
  }
}
