import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/widgets/default_bottom_navigation_widget.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import '../cubit/employee_cubit.dart';
import 'modify_employee_screen.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final EmployeeDetailsArgs employeeDetailsArgs;

  const EmployeeDetailsScreen({Key? key, required this.employeeDetailsArgs}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is DeleteEmployeeError) {
          Constants.showToast(msg: "DeleteEmployeeError: " + state.msg, context: context);
        }

        if (state is EndDeleteEmployee) {
          Constants.showToast(msg: "تم حذف الموظف بنجاح", color: Colors.green, context: context);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final employeeCubit = EmployeeCubit.get(context);


        if (state is StartGetEmployeeById) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        }


        if (state is GetEmployeeByIdError) {

          return Scaffold(
            body: ErrorItemWidget(
              msg: state.msg,
              onPress: () {
                employeeCubit.getEmployeeById(employeeDetailsArgs.employeeId);
              },
            ),
          );
        }


        if (state is StartDeleteEmployee) {
          return const WaitingItemWidget();
        }



        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [

                  DefaultUserAvatarWidget(
                    imageUrl: employeeCubit.currentEmployee.imageUrl,
                    fullName: employeeCubit.currentEmployee.fullName,
                    height: 150.0,),


                  const Divider(),

                  const DefaultHeightSizedBox(),

                  Text("الاسم بالكامل: "  + employeeCubit.currentEmployee.fullName),
                  const DefaultHeightSizedBox(),
                  Text("تاريخ الاضافة: " + Constants.dateTimeFromMilliSeconds(
                      employeeCubit.currentEmployee.createDateTime)),
                  const DefaultHeightSizedBox(),


                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("رقم الهاتف: "),
                      const SizedBox(width: 10.0,),
                      TextButton(
                          onPressed: () {
                            Constants.launchCallerV2(employeeCubit.currentEmployee.phoneNumber);
                          },

                          child: Text(employeeCubit.currentEmployee.phoneNumber)),
                    ],
                  ),


                  const DefaultHeightSizedBox(),
                  Text("الحالة: " + (employeeCubit.currentEmployee.enabled ? "نشط" : "متوقف")),
                  const DefaultHeightSizedBox(),
                  Text("الايميل: "  + employeeCubit.currentEmployee.username),

                  const DefaultHeightSizedBox(),
                  Text("ID: "  + employeeCubit.currentEmployee.employeeId.toString()),
                ],
              ),
            ),
          ),
          bottomNavigationBar: DefaultBottomNavigationWidget(

            withEdit: Constants.currentEmployee!.permissions.contains(AppStrings.editEmployees),
            withDelete: Constants.currentEmployee!.permissions.contains(AppStrings.deleteEmployees),

            omDeleteCallback: (bool result) {

              if (result) {
                employeeCubit.deleteEmployee(employeeCubit.currentEmployee.employeeId);
              }

            },
            onEditTapCallback: () {

              Navigator.pushNamed(
                  context, Routes.modifyEmployeeRoute,
                  arguments: ModifyEmployeeArgs(
                      employeeModel: employeeCubit.currentEmployee,
                      employeeCubit: employeeCubit,
                      fromRoute: employeeDetailsArgs.fromRoute)).then((value) {
                        if (value != null && value is EmployeeModel) {
                          employeeCubit.updateCurrentEmployeeModel(value);
                        }
              });
            },

          ),

        );
      },
    );
  }
}

class EmployeeDetailsArgs {
  final int employeeId;
  final EmployeeCubit employeeCubit;
  final String fromRoute;

  EmployeeDetailsArgs(
      {required this.employeeId, required this.employeeCubit, required this.fromRoute});
}
