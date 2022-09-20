import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../employees/data/models/phoneNumber_model.dart';
import '../../../employees/presentation/cubit/employee_cubit.dart';
import '../../../employees/presentation/screens/employee_details_screen.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../cubit/customer_cubit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/duplicates/duplicates_cubit.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;

import '../screens/customer_datails_screen.dart';
class DuplicatesCustomers extends StatelessWidget {
  final PhoneNumberModel phoneNumberModel;
  final CustomerCubit customerCubit;
  final TeamMembersCubit teamMembersCubit;
  final EmployeeCubit employeeCubit;

  const DuplicatesCustomers({Key? key, required this.phoneNumberModel,
    required this.customerCubit, required this.teamMembersCubit, required this.employeeCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create:  (context) => di.sl<DuplicatesCubit>()..findDistinctCustomersByPhoneNumber(phoneNumberModel),
      child: BlocBuilder<DuplicatesCubit, DuplicatesState>(
        builder: (context, state) {
          final cubit = DuplicatesCubit.get(context);

          if (state is StartFindDuplicateCustomers) {
            return const SizedBox(
                height: 500.0,
                width: 500.0,
                child: Center(child: CircularProgressIndicator(),));
          }

          if (state is FindDuplicateCustomersError) {
            return SizedBox(
              height: 500.0,
              width: 500.0,
              child: ErrorItemWidget(
                msg: state.msg,
                onPress: () {
                  cubit.findDistinctCustomersByPhoneNumber(phoneNumberModel);
                },
              ),
            );
          }

          return SizedBox(
            width: 500.0,
            height: 500.0,
            child: Scrollbar(
              child: ListView.builder(itemBuilder: (context, index) {
                final currentCustomer = cubit.duplicates[index];

                return Card(
                    child: Row(
                      children: [
                        Expanded(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DefaultUserAvatarWidget(
                              height: 50.0,
                              imageUrl: null,
                              fullName: currentCustomer.fullName,
                              onTap: () {
                                Navigator.pushNamed(context, Routes.customersDetailsRoute,
                                    arguments: CustomerDetailsArgs
                                      (customerModel: currentCustomer,
                                        customerCubit: customerCubit,
                                        teamMembersCubit: teamMembersCubit,
                                        fromRoute: Routes.employeesRoute));
                              },
                            ),
                            const SizedBox(height: 5.0,),
                            Text(currentCustomer.fullName)
                          ],
                        )),
                        const Text("معين إلي"),
                        Expanded(child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DefaultUserAvatarWidget(
                              height: 50.0,
                              imageUrl: currentCustomer.assignedEmployee?.imageUrl,
                              fullName: currentCustomer.assignedEmployee?.fullName,
                              onTap: () {

                                if (currentCustomer.assignedEmployee != null) {
                                  Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                                      arguments: EmployeeDetailsArgs(
                                          employeeModel: currentCustomer.assignedEmployee!,
                                          employeeCubit: employeeCubit,
                                          fromRoute: Routes.customersRoute));
                                }

                              },
                            ),
                            const SizedBox(height: 5.0,),
                            Text(currentCustomer.assignedEmployee != null ? currentCustomer.assignedEmployee!.fullName : "غير معرف")
                          ],
                        )),
                      ],
                    )
                );

              },
                itemCount: cubit.duplicates.length,),
            ),
          );
        },
      ),
    );
  }
}