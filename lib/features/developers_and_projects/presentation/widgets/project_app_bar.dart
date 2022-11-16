import 'package:crm_flutter_project/features/developers_and_projects/data/models/developer_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';

class ProjectsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final Function onDoneTapCallback;
  final VoidCallback onNewTapCallback;

  final String developerType;
  final DeveloperModel? developerModel;

  const ProjectsAppBar(
      {Key? key,
      required this.onSearchChangeCallback,
      required this.onCancelTapCallback,
      required this.onNewTapCallback,
      required this.developerType,
      required this.onDoneTapCallback,
      this.developerModel})
      : super(key: key);

  @override
  _ProjectsAppBarState createState() => _ProjectsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ProjectsAppBarState extends State<ProjectsAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(

      title: isSearch
          ? TextField(
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                hintText: "اسم المشروع",
              ),
              onChanged: (search) {
                widget.onSearchChangeCallback(search);
              },
            )
          : Text((widget.developerModel != null
                  ? widget.developerModel!.name
                  : ""), style: const TextStyle(fontSize: 16.0),),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),
        if (widget.developerType == DevelopersType.SELECT_DEVELOPERS.name)
          IconButton(
              onPressed: () {
                widget.onDoneTapCallback();
              },
              icon: const Icon(Icons.done)),
        if (Constants.currentEmployee!.permissions
            .contains(AppStrings.createProjects))
          if (widget.developerType == DevelopersType.VIEW_DEVELOPERS.name)
            IconButton(
                onPressed: widget.onNewTapCallback, icon: const Icon(Icons.add))
      ],
    );
  }
}
