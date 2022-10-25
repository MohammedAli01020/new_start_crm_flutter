import 'dart:math';

import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../employees/presentation/cubit/employee_cubit.dart';
class EmployeesGridView extends StatelessWidget {

  final List<EmployeeModel> selectedEmployees;
  final EmployeeCubit cubit;
  final EmployeeState state;
  final Function onEmployeeSelectCallback;

  const EmployeesGridView({Key? key,
    required this.selectedEmployees,
    required this.onEmployeeSelectCallback,
    required this.cubit,
    required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int colCount = max(1, (constraints.maxWidth / 135).floor());


        return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: cubit.employees.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: colCount,
                childAspectRatio: 1,
                mainAxisExtent: 100.0,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0),
            itemBuilder: (context, index) {


              if (index < cubit.employees.length) {
                final currentEmployee = cubit.employees[index];
                return InkWell(
                  onTap: () {
                    onEmployeeSelectCallback(currentEmployee);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: ClipOval(
                                  child: currentEmployee.imageUrl != null
                                      ? CachedNetworkImage(
                                    height: 50.0,
                                    width: 50.0,
                                    fit: BoxFit.cover,
                                    imageUrl: currentEmployee.imageUrl!,
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
                                        currentEmployee
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
                            if (selectedEmployees.contains(currentEmployee))
                              Container(
                                child: const Center(
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )),
                                decoration: BoxDecoration(
                                    color: Colors.green[300],
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
              } else {
                if (cubit.isNoMoreData) {
                  return Text(
                    "وصلت للنهاية",
                    style: TextStyle(fontSize: 15.0, color: AppColors.hint),
                  );
                } else {
                  if (state is StartLoadingEmployees) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        cubit.fetchEmployees();
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
}
