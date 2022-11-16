import 'package:crm_flutter_project/config/routes/app_routes.dart';
import 'package:crm_flutter_project/core/utils/app_colors.dart';
import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/customers/data/models/event_model.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/customer_datails_screen.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../domain/use_cases/customer_use_cases.dart';
import 'create_new_action_dailog.dart';
import 'duplicate_customers_widget.dart';

class CustomersDataTable extends DataTableSource {
  final CustomerCubit customerCubit;
  final CustomerState customerState;
  final TeamMembersCubit teamMembersCubit;
  final EmployeeCubit employeeCubit;
  final Function onSelect;
  final Function onLongPressCallback;
  final BuildContext context;

  CustomersDataTable({
    required this.customerCubit,
    required this.customerState,
    required this.teamMembersCubit,
    required this.employeeCubit,
    required this.onSelect,
    required this.onLongPressCallback,
    required this.context,
  });

  @override
  DataRow? getRow(int index) {
    try {
      final currentCustomer = customerCubit.customers[index];

      return DataRow.byIndex(
          index: index,

          selected: customerCubit.selectedCustomers.contains(currentCustomer),
          onSelectChanged: (val) {
            onSelect(val, currentCustomer);
          },

          onLongPress: () {
            onLongPressCallback(currentCustomer);
          },
          cells: [
            if (Constants.customerTableConfigModel.showName)
              DataCell(InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.customersDetailsRoute,
                        arguments: CustomerDetailsArgs(
                            customerModel: currentCustomer,
                            customerCubit: customerCubit,
                            fromRoute: Routes.customersRoute,
                            teamMembersCubit: teamMembersCubit));
                  },
                  child: Container(
                          color: currentCustomer.duplicateNo != null && currentCustomer.duplicateNo! > 0 ?
                          Theme.of(context).hintColor : Theme.of(context).highlightColor,
                          padding: const EdgeInsets.all(8.0),
                          child: Constants.currentEmployee!.permissions
                              .contains(AppStrings.viewLeadName) ? Text(currentCustomer.fullName.length < 15
                              ? currentCustomer.fullName
                              : "${currentCustomer.fullName.substring(0, 15)}...") : const Text("عرض التفاصيل"),
                        )
                     )),
            if (Constants.customerTableConfigModel.showPhone)
              DataCell(Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewLeadPhone)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              Constants.showDialogBox(
                                  context: context,
                                  title: "رقم الهاتف",
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextButton.icon(
                                        label: const Text("اتصال"),
                                        icon: const Icon(Icons.call),
                                        onPressed: () {
                                          try {
                                            Constants.launchCallerV2(
                                                currentCustomer
                                                    .phoneNumbers[0]);
                                          } catch (e) {
                                            debugPrint(e.toString());
                                            Constants.showToast(
                                                msg: "تعذر الاتصال",
                                                context: context);
                                          }
                                        },
                                      ),
                                      const DefaultHeightSizedBox(),
                                      TextButton.icon(
                                        label: const Text("رسالة واتس"),
                                        icon: const Icon(Icons.whatsapp),
                                        onPressed: () {
                                          try {
                                            Constants.launchWhatsAppV2(
                                                currentCustomer.phoneNumbers[0],
                                                "message");
                                          } catch (e) {
                                            debugPrint(e.toString());
                                            Constants.showToast(
                                                msg: "تعذر فتح الواتس اب",
                                                context: context);
                                          }
                                        },
                                      ),
                                      const DefaultHeightSizedBox(),
                                      TextButton.icon(
                                        label: const Text("نسخ الرقم"),
                                        icon: const Icon(
                                          Icons.copy,
                                        ),
                                        onPressed: () {
                                          try {
                                            Constants.copyText(currentCustomer
                                                    .phoneNumbers.first)
                                                .then((value) {
                                              Constants.showToast(
                                                  msg: "تم النسخ",
                                                  context: context);
                                            });
                                          } catch (e) {
                                            debugPrint(e.toString());
                                            Constants.showToast(
                                                msg: "تعذر الاتصال",
                                                context: context);
                                          }
                                        },
                                      ),
                                    ],
                                  ));
                            },
                            child: Text(currentCustomer.phoneNumbers[0], style: Theme.of(context).textTheme.button,)),
                        if (currentCustomer.phoneNumbers.length > 1)
                          const Text(" - "),
                        if (currentCustomer.phoneNumbers.length > 1)
                          InkWell(
                              onTap: () {
                                Constants.showDialogBox(
                                    context: context,
                                    title: "رقم الهاتف",
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton.icon(
                                          label: const Text("اتصال"),
                                          icon: const Icon(Icons.call),
                                          onPressed: () {
                                            try {
                                              Constants.launchCallerV2(
                                                  currentCustomer
                                                      .phoneNumbers[1]);
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              Constants.showToast(
                                                  msg: "تعذر الاتصال",
                                                  context: context);
                                            }
                                          },
                                        ),
                                        const DefaultHeightSizedBox(),
                                        TextButton.icon(
                                          label: const Text("رسالة واتس"),
                                          icon: const Icon(Icons.whatsapp),
                                          onPressed: () {
                                            try {
                                              Constants.launchWhatsAppV2(
                                                  currentCustomer
                                                      .phoneNumbers[1],
                                                  "message");
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              Constants.showToast(
                                                  msg: "تعذر فتح الواتس اب",
                                                  context: context);
                                            }
                                          },
                                        ),
                                        const DefaultHeightSizedBox(),
                                        TextButton.icon(
                                          label: const Text("نسخ الرقم"),
                                          icon: const Icon(
                                            Icons.copy,
                                          ),
                                          onPressed: () {
                                            try {
                                              Constants.copyText(currentCustomer
                                                      .phoneNumbers[1])
                                                  .then((value) {
                                                Constants.showToast(
                                                    msg: "تم النسخ",
                                                    context: context);
                                              });
                                            } catch (e) {
                                              debugPrint(e.toString());
                                              Constants.showToast(
                                                  msg: "تعذر الاتصال",
                                                  context: context);
                                            }
                                          },
                                        ),
                                      ],
                                    ));
                              },
                              child: Text(currentCustomer.phoneNumbers[1], style: Theme.of(context).textTheme.button)),
                      ],
                    )
                  : const Text("مخفي")),
            if (Constants.customerTableConfigModel.showAssignedTo)
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultUserAvatarWidget(
                    onTap: () {
                      if (currentCustomer.assignedEmployee != null) {
                        Navigator.pushNamed(
                            context, Routes.employeesDetailsRoute,
                            arguments: EmployeeDetailsArgs(
                                employeeId: currentCustomer
                                    .assignedEmployee!.employeeId,
                                employeeCubit: employeeCubit,
                                fromRoute: Routes.customersRoute));
                      }
                    },
                    imageUrl: currentCustomer.assignedEmployee?.imageUrl,
                    fullName: currentCustomer.assignedEmployee?.fullName,
                    height: 40.0,
                  ),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  // Text(currentCustomer.assignedEmployee != null
                  //     ? (currentCustomer.assignedEmployee!.fullName.length < 15
                  //         ? currentCustomer.assignedEmployee!.fullName
                  //         : "${currentCustomer.assignedEmployee!.fullName.substring(0, 15)}...")
                  //     : "لا يوجد")
                ],
              )),
            if (Constants.customerTableConfigModel.showLastAction)
              DataCell(customerCubit.currentUpdateActions.contains(index)
                  ? const Center(
                      child: SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator()),
                    )
                  : InkWell(
                      onTap: () {
                        if (Constants.currentEmployee!.permissions
                            .contains(AppStrings.createActions)) {


                          Constants.showDialogBox(
                            context: context,
                            title: currentCustomer.lastAction == null
                                ? "ادخل حدث جديد"
                                : "غير الحدث او عدلة",
                            content: CreateNewAction(
                              lastActionModel: currentCustomer.lastAction,
                              onConfirmAction:
                                  (UpdateCustomerLastActionParam param) {
                                customerCubit.updateCustomerLastAction(
                                    param, index);
                                Navigator.of(context).pop(true);
                              },
                              customerId: currentCustomer.customerId,
                            ),
                          );
                        } else {
                          Constants.showToast(
                              msg: "غير مصرح", context: context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: _getColor(currentCustomer.lastAction?.event),
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.blueGrey)),
                        child: Text(currentCustomer.lastAction != null &&
                                currentCustomer.lastAction!.event != null
                            ? currentCustomer.lastAction!.event!.name
                            : "لا يوجد"),
                      ),
                    )),
            if (Constants.customerTableConfigModel.showLastComment)
              DataCell(Text(
                currentCustomer.lastAction != null &&
                        currentCustomer.lastAction!.actionDescription != null &&
                        currentCustomer
                            .lastAction!.actionDescription!.isNotEmpty
                    ? (currentCustomer.lastAction!.actionDescription!.length >
                            20
                        ? currentCustomer.lastAction!.actionDescription!
                                .substring(0, 20) +
                            " ..."
                        : currentCustomer.lastAction!.actionDescription!)
                    : "لا يوجد",
                maxLines: 1,
              )),
            if (Constants.customerTableConfigModel.showSources)
              DataCell(Text(
                Constants.currentEmployee!.permissions
                        .contains(AppStrings.viewLeadSources)
                    ? currentCustomer.sources.isNotEmpty
                        ? currentCustomer.sources.length > 2
                            ? currentCustomer.sources
                                    .sublist(0, 2)
                                    .map((e) => e)
                                    .toString() +
                                ", ${currentCustomer.sources.length - 2} "
                            : currentCustomer.sources.map((e) => e).toString()
                        : "لا يوجد" : "مخفي",
                maxLines: 1,
              )),
            if (Constants.customerTableConfigModel.showUnitTypes)
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
            if (Constants.customerTableConfigModel.showDevelopers)
              DataCell(Text(
                currentCustomer.developers.isNotEmpty
                    ? currentCustomer.developers.length > 2
                        ? currentCustomer.developers
                                .sublist(0, 2)
                                .map((e) => e)
                                .toString() +
                            ", ${currentCustomer.developers.length - 2} "
                        : currentCustomer.developers.map((e) => e).toString()
                    : "لا يوجد",
                maxLines: 1,
              )),
            if (Constants.customerTableConfigModel.showProjects)
              DataCell(Text(
                currentCustomer.projects.isNotEmpty
                    ? currentCustomer.projects.length > 2
                        ? currentCustomer.projects
                                .sublist(0, 2)
                                .map((e) => e)
                                .toString() +
                            ", ${currentCustomer.projects.length - 2} "
                        : currentCustomer.projects.map((e) => e).toString()
                    : "لا يوجد",
                maxLines: 1,
              )),
            if (Constants.customerTableConfigModel.showLastActionTime)
              DataCell(Text(Constants.timeAgoSinceDate(
                  currentCustomer.lastAction?.dateTime))),
            if (Constants.customerTableConfigModel.showInsertDate)
              DataCell(Text(
                  Constants.timeAgoSinceDate(currentCustomer.createDateTime))),
            if (Constants.customerTableConfigModel.showCreateBy)
              DataCell(Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewLeadCreator)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DefaultUserAvatarWidget(
                          onTap: () {
                            if (currentCustomer.createdBy != null) {
                              Navigator.pushNamed(
                                  context, Routes.employeesDetailsRoute,
                                  arguments: EmployeeDetailsArgs(
                                      employeeId:
                                          currentCustomer.createdBy!.employeeId,
                                      employeeCubit: employeeCubit,
                                      fromRoute: Routes.customersRoute));
                            }
                          },
                          imageUrl: currentCustomer.createdBy?.imageUrl,
                          fullName: currentCustomer.createdBy?.fullName,
                          height: 40.0,
                        ),
                        // const SizedBox(
                        //   width: 5.0,
                        // ),
                        // Text(currentCustomer.createdBy != null
                        //     ? currentCustomer.createdBy!.fullName
                        //     : "لا يوجد")
                      ],
                    )
                  : const Text("مخفي")),
            if (Constants.customerTableConfigModel.showAssignedBy)
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultUserAvatarWidget(
                    onTap: () {
                      if (currentCustomer.assignedBy != null) {
                        Navigator.pushNamed(
                            context, Routes.employeesDetailsRoute,
                            arguments: EmployeeDetailsArgs(
                                employeeId:
                                    currentCustomer.assignedBy!.employeeId,
                                employeeCubit: employeeCubit,
                                fromRoute: Routes.customersRoute));
                      }
                    },
                    imageUrl: currentCustomer.assignedBy?.imageUrl,
                    fullName: currentCustomer.assignedBy?.fullName,
                    height: 40.0,
                  ),
                  // const SizedBox(
                  //   width: 5.0,
                  // ),
                  // Text(currentCustomer.assignedBy != null
                  //     ? currentCustomer.assignedBy!.fullName
                  //     : "لا يوجد")
                ],
              )),
            if (Constants.customerTableConfigModel.showReminderTime)
              DataCell(Text(currentCustomer.lastAction != null &&
                      currentCustomer.lastAction!.postponeDateTime != null
                  ? Constants.dateTimeFromMilliSeconds(
                      currentCustomer.lastAction!.postponeDateTime)
                  : "لا يوجد")),
            if (Constants.customerTableConfigModel.showDuplicateNumber)
              DataCell(Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currentCustomer.duplicateNo.toString()),
                  const SizedBox(
                    width: 10.0,
                  ),
                  if (Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewDuplicatesLeads))

                    IconButton(
                      onPressed: () {
                        if (currentCustomer.duplicateNo == 0) {
                          Constants.showToast(
                              msg: "لا يوجد تكرارات لهذا العميل",
                              context: context);
                          return;
                        }

                        Constants.showDialogBox(
                            context: context,
                            title: "تكرارات العميل" " " +
                                currentCustomer.duplicateNo.toString(),
                            content: DuplicatesCustomers(
                              phoneNumbersWrapper: PhoneNumbersWrapper(
                                  phoneNumbers: currentCustomer.phoneNumbers),
                              teamMembersCubit: teamMembersCubit,
                              customerCubit: customerCubit,
                              employeeCubit: employeeCubit,
                            ));
                      },
                      icon: Icon(
                        Icons.visibility_outlined,
                        color: currentCustomer.duplicateNo == 0 ||
                                !Constants.currentEmployee!.permissions
                                    .contains(AppStrings.viewDuplicatesLeads)
                            ? Colors.grey
                            : AppColors.primary,
                      ),
                    ),
                ],
              ))
          ]);
    } catch (e) {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customerCubit.customerTotalElements;

  @override
  int get selectedRowCount => 0;

  Color? _getColor(EventModel? event) {

    if (event == null || event.name == "No Action") return null;

    if (event.name == "Cancellation") {
      return Colors.red;
    } else if (event.name == "Contract") {
      return Colors.green;
    }

    return Colors.yellow;


  }
}
