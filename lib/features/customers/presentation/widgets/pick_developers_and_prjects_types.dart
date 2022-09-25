
import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../developers_and_projects/presentation/screens/developers_screen.dart';


class PickDevelopersAndProjects extends StatefulWidget {
  final List<String> developers;
  final List<String> projects;

  final Function onPickedDevelopersAndProjectsCallback;
  final VoidCallback onRemoveCallback;
  const PickDevelopersAndProjects({Key? key, required this.developers,
    required this.onPickedDevelopersAndProjectsCallback,
    required this.onRemoveCallback,
    required this.projects}) : super(key: key);

  @override
  State<PickDevelopersAndProjects> createState() => _PickDevelopersAndProjectsState();
}

class _PickDevelopersAndProjectsState extends State<PickDevelopersAndProjects> {

  List<String> selectedDevelopers = [];
  List<String> selectedProjects = [];

  @override
  void initState() {
    super.initState();
    selectedDevelopers = widget.developers;
    selectedProjects = widget.projects;

  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: ListTile(
              onTap: () async {

                final response = await Navigator.pushNamed(context, Routes.developersRoute,
                    arguments: DevelopersArgs(developerType: DevelopersType.SELECT_DEVELOPERS.name,
                        selectedProjectsNames: selectedProjects ,
                        selectedDevelopersNames: selectedDevelopers));

                if (response != null && response is DeveloperResults) {

                  selectedProjects = response.selectedProjects;
                  selectedDevelopers = response.selectedDevelopers;

                  setState(() {
                  });

                  widget.onPickedDevelopersAndProjectsCallback(selectedDevelopers, selectedProjects);
                }


              },
              title: Text((selectedDevelopers.isNotEmpty && selectedProjects.isNotEmpty) ? "عدل المطورين والمشاريع" : "احتر المطورين والمشاريع"),
              subtitle: Text(selectedDevelopers.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
        if (selectedDevelopers.isNotEmpty && selectedProjects.isNotEmpty)
        IconButton(
          onPressed: () {
            selectedDevelopers = [];
            selectedProjects = [];

            setState(() {});

            widget.onRemoveCallback();
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}