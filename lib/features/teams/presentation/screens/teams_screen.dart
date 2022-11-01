import 'dart:math';

import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/team_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../widgets/teams_app_bar.dart';

class TeamsScreen extends StatelessWidget {
  const TeamsScreen({Key? key}) : super(key: key);

  void _getPageTeams({bool refresh = false, required BuildContext context}) {
    BlocProvider.of<TeamCubit>(context).fetchTeams(refresh: refresh);
  }


  Widget _buildList(TeamCubit cubit, TeamState state, BuildContext context) {
    if (state is StartRefreshTeams || state is StartLoadingTeams) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RefreshTeamsError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _getPageTeams(refresh: true, context: context);
        },
      );
    }


    if (cubit.teams.isEmpty) {
      return const Center(child: Text("فارع ابدأ بالاضافة عن طريق علامة +"));
    }

    return Scrollbar(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {

            int colCount = max(1, (constraints.maxWidth / 150).floor());

            return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: cubit.teams.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: colCount,
                    childAspectRatio: 1,
                    mainAxisExtent: 300.0,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0
                ),
                itemBuilder: (context, index) {


                  if (index < cubit.teams.length) {

                    final currentTeam = cubit.teams[index];

                    return InkWell(
                      onTap: () {

                        Navigator.pushNamed(context, Routes.teamsDetailsRoute,
                            arguments: TeamDetailsArgs(teamModel: currentTeam, teamCubit: cubit, fromRoute: Routes.teamsRoute));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(currentTeam.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.center,),
                            const Divider(),

                            Text(
                              currentTeam.description ?? "لا يوجد",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const Divider(),

                            Text("اليدر: " + (currentTeam.teamLeader != null ? currentTeam.teamLeader!.fullName : "لا يوجد")),


                            Text("بواسطة: " + (currentTeam.createdBy != null ? currentTeam.createdBy!.fullName : "لا يوجد"), style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),),
                            Text("بتاريخ: " + Constants.dateTimeFromMilliSeconds(currentTeam.createDateTime), style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),)

                          ],
                        ),
                      ),
                    );
                  } else {
                    if (cubit.isNoMoreData) {
                      return const Text("وصلت للنهاية", style: TextStyle(fontSize: 15.0),);
                    }  else {


                      if( state is StartLoadingTeams) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            _getPageTeams(context: context);
                          },
                          child: const Text("حمل المزيد"),
                        );
                      }
                    }
                  }

                });

          },


        ));

  }


  // Widget _buildBody(
  //     {required TeamCubit cubit,
  //     required TeamState state,
  //     required BuildContext context}) {
  //
  //   return Column(
  //     children: [
  //
  //       Expanded(child: _buildList(cubit, state, context)),
  //
  //       if (cubit.teams.isNotEmpty) SizedBox(
  //         width: context.width,
  //         child: NumberPaginator(
  //             onPageChange: (index) {
  //
  //               cubit.setCurrentPage(index);
  //               cubit.updateFilter(cubit.teamFiltersModel.copyWith(
  //                 pageNumber: Wrapped.value(index)
  //               ));
  //               _getPageTeams(context: context, refresh: true);
  //             },
  //
  //             initialPage: cubit.teamCurrentPage,
  //             numberPages: cubit.teamPagesCount),
  //       ),
  //
  //
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamCubit, TeamState>(
      builder: (context, state) {
        final teamCubit = TeamCubit.get(context);
        return Scaffold(
          appBar: TeamsAppBar(
            onSearchChangeCallback: (String search) {

              teamCubit.updateFilter(teamCubit.teamFiltersModel.copyWith(
                search: Wrapped.value(search)
              ));

              teamCubit.fetchTeams(refresh: true);
            },
            onCancelTapCallback: () {

              teamCubit.updateFilter(teamCubit.teamFiltersModel.copyWith(
                  search: const Wrapped.value(null)
              ));

              teamCubit.fetchTeams(refresh: true);
            },
            teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context),
            teamCubit: teamCubit,
          ),
          body: _buildList(teamCubit, state, context),
        );
      },
    );
  }
}
