import 'dart:math';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/cubit/developer/developer_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/features/developers_and_projects/data/models/developer_model.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/cubit/project/project_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../domain/use_cases/projects_use_case.dart';
import '../widgets/modify_project_widget.dart';
import '../widgets/project_app_bar.dart';

class ProjectsScreen extends StatelessWidget {
  final ProjectsArgs projectsArgs;
  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  ProjectsScreen({Key? key, required this.projectsArgs}) : super(key: key) {
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


  Widget _buildBody(ProjectCubit projectCubit, ProjectState state) {
    if (state is StartGetAllProjectsWithFilters ||
        state is StartFilterProjects) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllProjectsWithFiltersError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          projectCubit.getAllProjectsWithFilters(ProjectFilters(
              developerId: projectsArgs.developerModel.developerId
          ));
        },
      );
    }

    return Scrollbar(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentProject = projectCubit.filteredProjects[index];
          return ListTile(
            onTap: () {
              if (projectsArgs.developerType ==
                  DevelopersType.SELECT_DEVELOPERS.name) {
                projectCubit.updateSelectedProjects(currentProject.name);

              } else if (projectsArgs.developerType ==
                  DevelopersType.VIEW_DEVELOPERS.name) {

                if (Constants.currentEmployee!.permissions
                    .contains(AppStrings.editProjects)) {

                  Constants.showDialogBox(
                      context: context,
                      title: "عدل المشروع",
                      content: ModifyProjectWidget(
                        projectModel: currentProject,
                        projectCubit: projectCubit,
                        state: state,
                        developerId: projectsArgs.developerModel.developerId,
                      ));
                }
              }
            },
            selectedTileColor: Colors.blueGrey[100],
            selected: projectCubit.selectedProjectsNames
                .contains(currentProject.name),
            title: Text(currentProject.name),
          );
        },
        itemCount: projectCubit.filteredProjects.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is ModifyProjectError) {
          Constants.showToast(
              msg: "ModifyProjectError: " + state.msg, context: context);
        }

        if (state is EndModifyProject) {
          Constants.showToast(
              msg: "تم بنجاح", color: Colors.green, context: context);
        }
      },
      builder: (context, state) {
        final projectCubit = ProjectCubit.get(context);
        return Scaffold(
          appBar: ProjectsAppBar(
            developerModel: projectsArgs.developerModel,
            developerType: projectsArgs.developerType,
            onSearchChangeCallback: (String search) {
              projectCubit.filterProjects(search);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                projectCubit.resetFilters();
              }
            },
            onDoneTapCallback: () {

              Navigator.pop(context, ProjectReturnResult(
                  developerModel: projectsArgs.developerModel,
                  selectedProjectsNames: projectCubit.selectedProjectsNames));

              projectCubit.setSelectedProjects([]);

            },
            onNewTapCallback: () {

              Constants.showDialogBox(
                  context: context,
                  title: "أضف مشروع جديد",
                  content: ModifyProjectWidget(
                    projectCubit: projectCubit,
                    state: state,
                    developerId: projectsArgs.developerModel.developerId,
                  ));


            },
          ),

          body: _buildBody(projectCubit, state),


        );
      },
    );
  }
}


class ProjectsArgs {
  final String developerType;
  final DeveloperModel developerModel;
  final List<String>? selectedProjectsNames;

  ProjectsArgs({
    required this.developerType,
    required this.developerModel,
    this.selectedProjectsNames});

}


class ProjectReturnResult {
  final List<String>? selectedProjectsNames;
  final DeveloperModel developerModel;

  ProjectReturnResult({this.selectedProjectsNames, required this.developerModel});


  factory ProjectReturnResult.fromJson(Map<String, dynamic> json) => ProjectReturnResult(
    selectedProjectsNames: json["selectedProjectsNames"],
    developerModel: json["developerModel"],
  );

  Map<String, dynamic> toJson() => {
    "selectedProjectsNames": selectedProjectsNames,
    "developerModel": developerModel,
  };

}