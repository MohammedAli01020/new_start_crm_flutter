import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:flutter/material.dart';


import '../../../../core/widgets/default_user_avatar_widget.dart';

class SelectedEmployeeListView extends StatelessWidget {
  final List<EmployeeModel> selectedEmployees;
  final Function onRemoveEmployeeCallback;
  const SelectedEmployeeListView({Key? key, required this.selectedEmployees, required this.onRemoveEmployeeCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final currentEmployee = selectedEmployees[index];
          return GestureDetector(
            onTap: () {


              onRemoveEmployeeCallback(currentEmployee);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              // padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      DefaultUserAvatarWidget(imageUrl: currentEmployee.imageUrl,
                          height: 50.0,
                          fullName: currentEmployee.fullName),
                      Container(
                        child: const Center(
                            child: Icon(
                              Icons.clear,
                              color: Colors.white,
                            )),
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    currentEmployee.fullName,
                    style: const TextStyle(
                        fontSize: 14.0),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: selectedEmployees.length);
  }
}
