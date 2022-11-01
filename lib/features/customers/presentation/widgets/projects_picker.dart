
import 'dart:math';

import 'package:crm_flutter_project/core/widgets/custom_edit_text.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../developers_and_projects/domain/use_cases/projects_use_case.dart';
import '../../../developers_and_projects/presentation/cubit/project/project_cubit.dart';

class ProjectsPicker extends StatefulWidget {
  final List<String> selectedProjects;
  final Function onConfirmCallback;
  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  ProjectsPicker(
      {Key? key, required this.selectedProjects, required this.onConfirmCallback})
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

  @override
  State<ProjectsPicker> createState() => _ProjectsPickerState();
}

class _ProjectsPickerState extends State<ProjectsPicker> {


  final _projectNameSearch = TextEditingController();




  @override
  void initState() {
    super.initState();
    _projectNameSearch.addListener(() {

      setState(() {});
    });
  }

  @override
  void dispose() {

    super.dispose();
    _projectNameSearch.dispose();
    widget._scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProjectCubit>()
        ..setSelectedProjects(widget.selectedProjects)
        ..getAllProjectsWithFilters(const ProjectFilters()),

      child: BlocBuilder<ProjectCubit, ProjectState>(
        builder: (context, state) {
          final projectCubit = ProjectCubit.get(context);
          if (state is StartGetAllProjectsWithFilters) {
            return const SizedBox(
                height: 500.0,
                width: 500.0,
                child: Center(child: CircularProgressIndicator()));
          }

          if (state is GetAllProjectsWithFiltersError) {
            return SizedBox(
              height: 500.0,
              width: 500.0,
              child: ErrorItemWidget(
                msg: state.msg,
                onPress: () {
                  projectCubit.getAllProjectsWithFilters(const ProjectFilters());
                },
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        widget.onConfirmCallback(projectCubit.selectedProjectsNames);
                      },
                      style: TextButton.styleFrom(

                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('تأكيد'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        projectCubit.setSelectedProjects([]);
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.red,
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('مسح الكل'),
                    ),
                  ],
                ),
                CustomEditText(
                  onChangedCallback: (String val) {
                    projectCubit.filterProjects(val);
                  },
                  suffixIcon: _projectNameSearch.text.isEmpty
                      ? null
                      : IconButton(
                      onPressed: () {
                        projectCubit.resetFilters();
                        _projectNameSearch.clear();
                      },
                      icon: const Icon(Icons.clear)),
                  controller: _projectNameSearch,
                  inputType: TextInputType.text,
                hint: "اسم المشروع",
                ),
                SizedBox(
                  height: 500.0,
                  width: 500.0,
                  child: ListView.separated(
                    controller: widget._scrollController,
                    itemBuilder: (context, index) {
                      final currentProject = projectCubit.filteredProjects[index];
                      return ListTile(
                        onTap: () {
                          projectCubit.updateSelectedProjects(currentProject.name);
                        },
                        // selectedTileColor: Colors.blueGrey[100],
                        selected:
                            projectCubit.selectedProjectsNames.contains(currentProject.name),
                        title: Text(currentProject.name),
                      );
                    },
                    itemCount: projectCubit.filteredProjects.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
