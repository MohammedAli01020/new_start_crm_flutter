import 'dart:math';

import 'package:crm_flutter_project/config/routes/app_routes.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/cubit/developer/developer_cubit.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/screens/projects_screen.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/widgets/developer_app_bar.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/widgets/modify_developer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';

class DevelopersScreen extends StatelessWidget {
  final DevelopersArgs developersArgs;
  final _scrollController = ScrollController();


  DevelopersScreen({Key? key, required this.developersArgs}) : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? Constants.extraScrollSpeed
                  : -Constants.extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  Widget _buildBody(DeveloperCubit developerCubit, DeveloperState state) {
    if (state is StartGetAllDevelopersByNameLike ||
        state is StartFilterDevelopers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllDevelopersByNameLikeError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          developerCubit.getAllDevelopersByNameLike();
        },
      );
    }

    return Scrollbar(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentDeveloper = developerCubit.filteredDevelopers[index];
          return ListTile(
            onTap: () async {
              if (developersArgs.developerType ==
                  DevelopersType.SELECT_DEVELOPERS.name) {

                final result = await Navigator.pushNamed(context, Routes.projectsRoute,
                    arguments: ProjectsArgs(
                        developerType: developersArgs.developerType,
                        developerModel: currentDeveloper,
                        selectedProjectsNames:
                        developerCubit.selectedProjectsNames));

                if (result != null && result is ProjectReturnResult) {

                  if (result.selectedProjectsNames != null && result.selectedProjectsNames!.isNotEmpty ) {
                    developerCubit.addDeveloperName(result.developerModel.name);
                    developerCubit.setSelectedProjects(result.selectedProjectsNames ?? []);

                  } else {
                    developerCubit.removeDeveloperName(result.developerModel.name);
                    developerCubit.setSelectedProjects(result.selectedProjectsNames ?? []);
                  }

                }

              } else if (developersArgs.developerType ==
                  DevelopersType.VIEW_DEVELOPERS.name) {
                if (Constants.currentEmployee!.permissions
                    .contains(AppStrings.editDevelopers)) {
                  Constants.showDialogBox(
                      context: context,
                      title: "عدل الحدث",
                      content: ModifyDeveloperWidget(
                        developerModel: currentDeveloper,
                        developerCubit: developerCubit,
                        state: state,
                      ));
                }
              }
            },
            trailing: Constants.currentEmployee!.permissions
                    .contains(AppStrings.viewProjects)
                ? IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.projectsRoute,
                          arguments: ProjectsArgs(
                              developerType: developersArgs.developerType,
                              developerModel: currentDeveloper,
                              selectedProjectsNames:
                                  developerCubit.selectedProjectsNames));
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                : null,
            selectedTileColor: Colors.blueGrey[100],
            selected: developerCubit.selectedDevelopersNames
                .contains(currentDeveloper.name),
            title: Text(currentDeveloper.name),
          );
        },
        itemCount: developerCubit.filteredDevelopers.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeveloperCubit, DeveloperState>(
      listener: (context, state) {

        if (state is ModifyDeveloperError) {
          Constants.showToast(
              msg: "ModifyDeveloperError: " + state.msg, context: context);
        }

        if (state is EndModifyDeveloper) {
          Constants.showToast(
              msg: "تم بنجاح", color: Colors.green, context: context);
        }

      },


      builder: (context, state) {
        final developerCubit = DeveloperCubit.get(context);

        return Scaffold(
          appBar: DevelopersAppBar(
            developerType: developersArgs.developerType,
            onSearchChangeCallback: (String search) {
              developerCubit.filterDevelopers(search);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                developerCubit.resetFilters();
              }
            },
            onDoneTapCallback: () {
              Navigator.pop(context, DeveloperResults(
                selectedDevelopers: developerCubit.selectedDevelopersNames,
              selectedProjects: developerCubit.selectedProjectsNames,));
            },
            onNewTapCallback: () {
              Constants.showDialogBox(
                  context: context,
                  title: "أضف مطور جديد",
                  content: ModifyDeveloperWidget(
                    developerCubit: developerCubit,
                    state: state,
                  ));
            },
          ),
          body: _buildBody(developerCubit, state),
        );
      },
    );
  }
}

class DevelopersArgs {
  final String developerType;
  final List<String>? selectedDevelopersNames;
  final List<String>? selectedProjectsNames;

  DevelopersArgs(
      {required this.developerType,
      this.selectedDevelopersNames,
      this.selectedProjectsNames});
}


class DeveloperResults {
  final List<String> selectedDevelopers;
  final List<String> selectedProjects;

  DeveloperResults({required this.selectedDevelopers, required this.selectedProjects});

}