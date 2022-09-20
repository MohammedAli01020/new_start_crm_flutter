import 'package:crm_flutter_project/config/routes/app_routes.dart';
import 'package:crm_flutter_project/core/utils/app_colors.dart';
import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/duplicates/duplicates_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/customer_datails_screen.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../employees/data/models/phoneNumber_model.dart';
import '../../domain/use_cases/customer_use_cases.dart';
import 'create_new_action_dailog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;

import 'duplicate_customers_widget.dart';


class CustomersDataTable extends DataTableSource {
  final CustomerCubit customerCubit;
  final TeamMembersCubit teamMembersCubit;
  final EmployeeCubit employeeCubit;
  final Function onSelect;
  final BuildContext context;

  CustomersDataTable( {
    required this.customerCubit,
    required this.teamMembersCubit,
    required this.employeeCubit,
    required this.onSelect,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    final currentCustomer = customerCubit.customers[index];

    return DataRow.byIndex(
        index: index,
        selected: customerCubit.selectedCustomersIds
            .contains(currentCustomer.customerId),
        onSelectChanged: (val) {
          onSelect(val, currentCustomer);
        },
        cells: [
          DataCell(

              InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.customersDetailsRoute,
                arguments: CustomerDetailsArgs(
                    customerModel: currentCustomer,
                    customerCubit: customerCubit,
                    fromRoute: Routes.customersRoute,
                    teamMembersCubit: teamMembersCubit));
              },
              child: Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadName) ?
              Text(currentCustomer.fullName) : const Text("عرض التفاصيل")) ),
          DataCell( Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadPhone)  ? TextButton(
              onPressed: () {
                Constants.showDialogBox(context: context, title: "رقم الهاتف",
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      label: const Text("اتصال"),
                      icon: const Icon(Icons.call),
                      onPressed: () {
                        try {
                          Constants.launchCaller(currentCustomer.phoneNumber);
                        } catch (e) {
                          debugPrint(e.toString());
                          Constants.showToast(msg: "تعذر الاتصال", context: context);
                        }

                      },

                    ),
                    const DefaultHeightSizedBox(),

                    TextButton.icon(
                      label: const Text("رسالة واتس"),
                      icon: const Icon(Icons.whatsapp),
                      onPressed: () {
                        try {
                          Constants.launchWhatsApp(currentCustomer.phoneNumber, "message");
                        } catch (e) {
                          debugPrint(e.toString());
                          Constants.showToast(msg: "تعذر فتح الواتس اب", context: context);
                        }

                      },

                    ),
                    const DefaultHeightSizedBox(),

                    TextButton.icon(
                      label: const Text("نسخ الرقم"),
                      icon: const Icon(Icons.copy,),
                      onPressed: () {
                        try {

                          Constants.copyText(currentCustomer.phoneNumber.countryCode + currentCustomer.phoneNumber.phone.substring(1)).then((value) {

                            Constants.showToast(msg: "تم النسخ", context: context);

                          });

                        } catch (e) {
                          debugPrint(e.toString());
                          Constants.showToast(msg: "تعذر الاتصال", context: context);
                        }

                      },

                    ),
                  ],
                ));
              },
              child: Text(currentCustomer.phoneNumber.phone)) : const Text("مخفي")  ),
          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultUserAvatarWidget(
                onTap: () {
                  if (currentCustomer.assignedEmployee != null) {
                    Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                        arguments: EmployeeDetailsArgs(
                            employeeModel: currentCustomer.assignedEmployee!,
                            employeeCubit: employeeCubit,
                            fromRoute: Routes.customersRoute));
                  }

                },
                imageUrl: currentCustomer.assignedEmployee?.imageUrl,
                fullName: currentCustomer.assignedEmployee?.fullName,
                height: 40.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(currentCustomer.assignedEmployee != null
                  ? currentCustomer.assignedEmployee!.fullName
                  : "لا يوجد")
            ],
          )),


          DataCell(customerCubit.currentUpdateActions.contains(index)
              ? const Center(
                  child: SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator()),
                )
              : InkWell(
                  onTap: () {

                    if (Constants.currentEmployee!.permissions.contains(AppStrings.createActions)) {
                      Constants.showDialogBox(
                        context: context,
                        title: currentCustomer.lastAction == null
                            ? "ادخل حدث جديد"
                            : "غير الحدث او عدلة",
                        content: CreateNewAction(
                          lastActionModel: currentCustomer.lastAction,
                          onConfirmAction: (UpdateCustomerLastActionParam param) {
                            customerCubit.updateCustomerLastAction(param, index);
                            Navigator.of(context).pop(true);
                          },
                          customerId: currentCustomer.customerId,
                        ),
                      );
                    } else {
                      Constants.showToast(msg: "غير مصرح", context: context);
                    }

                  },
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.blueGrey)),
                    child: Text(currentCustomer.lastAction != null &&
                            currentCustomer.lastAction!.event != null
                        ? currentCustomer.lastAction!.event!.name
                        : "لا يوجد"),
                  ),
                )),


          DataCell(Text(
            currentCustomer.sources.isNotEmpty
                ? currentCustomer.sources.length > 2
                    ? currentCustomer.sources
                            .sublist(0, 2)
                            .map((e) => e)
                            .toString() +
                        ", ${currentCustomer.sources.length - 2} "
                    : currentCustomer.sources.map((e) => e).toString()
                : "لا يوجد",
            maxLines: 1,
          )),

          DataCell(Text(
            currentCustomer.unitTypes.isNotEmpty
                ? currentCustomer.unitTypes.length > 2
                ? currentCustomer.unitTypes
                .sublist(0, 2)
                .map((e) => e)
                .toString() +
                ", ${currentCustomer.unitTypes.length - 2} "
                : currentCustomer.unitTypes.map((e) => e).toString()
                : "لا يوجد",
            maxLines: 1,
          )),
          DataCell(Text(Constants.timeAgoSinceDate(
              currentCustomer.lastAction?.dateTime))),

          DataCell(Text( currentCustomer.lastAction != null && currentCustomer.lastAction!.actionDescription != null &&
              currentCustomer.lastAction!.actionDescription!.isNotEmpty ?

          (currentCustomer.lastAction!.actionDescription!.length > 20 ?
          currentCustomer.lastAction!.actionDescription!.substring(0, 20) + " ..." : currentCustomer.lastAction!.actionDescription! )   : "لا يوجد",
            maxLines: 1,
          )),

          DataCell(Text(Constants.timeAgoSinceDate(
              currentCustomer.createDateTime))),

          DataCell(
              Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadCreator) ?
              Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              DefaultUserAvatarWidget(
                onTap: () {
                  if (currentCustomer.createdBy != null) {
                    Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                        arguments: EmployeeDetailsArgs(
                            employeeModel: currentCustomer.createdBy!,
                            employeeCubit: employeeCubit,
                            fromRoute: Routes.customersRoute));
                  }
                },
                imageUrl: currentCustomer.createdBy?.imageUrl,
                fullName: currentCustomer.createdBy?.fullName,
                height: 40.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(currentCustomer.createdBy != null
                  ? currentCustomer.createdBy!.fullName
                  : "لا يوجد")
            ],
          ) : const Text("مخفي")),
          DataCell(
              Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultUserAvatarWidget(
                onTap: () {

                  if (currentCustomer.assignedBy != null) {
                    Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                        arguments: EmployeeDetailsArgs(
                            employeeModel: currentCustomer.assignedBy!,
                            employeeCubit: employeeCubit,
                            fromRoute: Routes.customersRoute));
                  }

                },
                imageUrl: currentCustomer.assignedBy?.imageUrl,
                fullName: currentCustomer.assignedBy?.fullName,
                height: 40.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(currentCustomer.assignedBy != null
                  ? currentCustomer.assignedBy!.fullName
                  : "لا يوجد")
            ],
          )),
          DataCell(Text(currentCustomer.lastAction != null &&
                  currentCustomer.lastAction!.postponeDateTime != null
              ? Constants.dateTimeFromMilliSeconds(
                  currentCustomer.lastAction!.postponeDateTime)
              : "لا يوجد")),

          DataCell(Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currentCustomer.duplicateNo.toString()),
              const SizedBox(width: 10.0,),
              IconButton(
                onPressed: () {

                  if (!Constants.currentEmployee!.permissions.contains(AppStrings.viewDuplicatesLeads)) {
                    Constants.showToast(msg: "غير مصرح", context: context);
                    return;
                  }

                  if (currentCustomer.duplicateNo == 0) {
                    Constants.showToast(msg: "لا يوجد تكرارات لهذا العميل", context: context);
                    return;
                  }


                  Constants.showDialogBox(context: context, title: "تكرارات العميل" " " + currentCustomer.duplicateNo.toString(),
                  content: DuplicatesCustomers(phoneNumberModel: currentCustomer.phoneNumber,
                    teamMembersCubit: teamMembersCubit,
                     customerCubit: customerCubit, employeeCubit: employeeCubit,));

                },
                icon:  Icon(Icons.visibility_outlined, color: currentCustomer.duplicateNo == 0 ? Colors.grey : AppColors.primary,),
              ),
            ],
          ))
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customerCubit.customerTotalElements;

  @override
  int get selectedRowCount => 0;
}




