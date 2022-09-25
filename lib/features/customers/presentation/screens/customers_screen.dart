import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/customers_data_table.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../cubit/customer_cubit.dart';
import '../widgets/bulk_actions_widget.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/customers_app_bar.dart';

class CustomersScreen extends StatefulWidget {
  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  CustomersScreen({Key? key}) : super(key: key) {
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
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  void _getPageCustomers({bool refresh = false}) {
    BlocProvider.of<CustomerCubit>(context).fetchCustomers(refresh: refresh);
  }

  @override
  void initState() {
    super.initState();

    final customerCubit = BlocProvider.of<CustomerCubit>(context);

    Constants.refreshCustomers(customerCubit);
  }

  Widget _buildBodyTable(
      {required CustomerCubit cubit, required CustomerState state}) {
    if (state is StartRefreshCustomers || state is StartLoadingCustomers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RefreshCustomersError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          Constants.refreshCustomers(cubit);
        },
      );
    }

    return SingleChildScrollView(
      controller: widget._scrollController,
      child: SizedBox(
        width: context.width,
        child: PaginatedDataTable(
            columns: [
              if (Constants.customerTableConfigModel.showName)
                const DataColumn(label: Text('الاسم')),
              if (Constants.customerTableConfigModel.showPhone)
                const DataColumn(label: Text('رقم التليفون')),
              if (Constants.customerTableConfigModel.showAssignedTo)
                const DataColumn(label: Text('معين إلي')),
              if (Constants.customerTableConfigModel.showLastAction)
                const DataColumn(label: Text('أخر حالة')),
              if (Constants.customerTableConfigModel.showSources)
                const DataColumn(label: Text('المصادر')),
              if (Constants.customerTableConfigModel.showUnitTypes)
                const DataColumn(label: Text('الاهتمامات')),
              if (Constants.customerTableConfigModel.showDevelopers)
                const DataColumn(label: Text('المطورين')),
              if (Constants.customerTableConfigModel.showProjects)
                const DataColumn(label: Text('المشاريع')),
              if (Constants.customerTableConfigModel.showLastActionTime)
                const DataColumn(label: Text('اخر تحديث للحالة')),
              if (Constants.customerTableConfigModel.showLastComment)
                const DataColumn(label: Text('اخر تعليق')),
              if (Constants.customerTableConfigModel.showInsertDate)
                const DataColumn(label: Text('تاريخ الادخال')),
              if (Constants.customerTableConfigModel.showCreateBy)
                const DataColumn(label: Text('مدخل بواسطة')),
              if (Constants.customerTableConfigModel.showAssignedBy)
                const DataColumn(label: Text('معين بواسطة')),
              if (Constants.customerTableConfigModel.showReminderTime)
                const DataColumn(label: Text('موعد التذكير')),
              if (Constants.customerTableConfigModel.showDuplicateNumber)
                const DataColumn(label: Text('عدد التكرارات')),
            ],
            rowsPerPage: 50,
            header: Text("العملاء: " + cubit.customerTotalElements.toString()),
            actions: [
              if (Constants.currentEmployee!.permissions
                  .contains(AppStrings.bulkActions))
                if (cubit.selectedCustomersIds.isNotEmpty)
                  IconButton(
                      onPressed: () async {
                        Constants.showToast(
                            msg: "not implemented yet", context: context);
                        return;

                        final response = await Constants.showConfirmDialog(
                            context: context, msg: "هل تريد تأكيد الحذف؟");

                        // if (response) {
                        //   List<UserTeamIdModel> userTeamIds = teamMembersCubit.selectedTeamMembersIds.map((e) {
                        //     return  UserTeamIdModel(employeeId: e, teamId: teamDetailsArgs.teamModel.teamId);
                        //   }).toList();
                        //
                        //   teamMembersCubit.deleteAllTeamMembersByIds(userTeamIds);
                        // }
                      },
                      icon: const Icon(Icons.delete)),
              if (Constants.currentEmployee!.permissions
                  .contains(AppStrings.bulkActions))
                if (cubit.selectedCustomersIds.isNotEmpty)
                  state is StartUpdateBulkCustomers
                      ? const Center(
                          child: SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator()))
                      : IconButton(
                          onPressed: () async {
                            Constants.showDialogBox(
                                context: context,
                                title: "العمليات المجمعة",
                                content: BulkActionsWidget(
                                  onConfirmAction: (UpdateCustomerParam
                                      updateCustomerParam) {
                                    cubit.updateBulkCustomers(
                                        updateCustomerParam);
                                    Navigator.of(context).pop(true);
                                  },
                                  selectedCustomersIds:
                                      cubit.selectedCustomersIds,
                                  teamMembersCubit:
                                      BlocProvider.of<TeamMembersCubit>(
                                          context),
                                ));
                          },
                          icon: const Icon(Icons.assignment_turned_in)),
              if (Constants.currentEmployee!.permissions
                  .contains(AppStrings.exportLeads))
                if (cubit.selectedCustomersIds.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        Constants.showToast(
                            msg: "not implemented yet", context: context);
                      },
                      icon: const FaIcon(FontAwesomeIcons.fileExport)),
              state is StartRefreshCustomers || state is StartLoadingCustomers
                  ? const Center(
                      child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        Constants.refreshCustomers(cubit);
                      },
                      icon: const Icon(Icons.refresh))
            ],
            showCheckboxColumn: true,
            onPageChanged: (pageIndex) {
              cubit.updateFilter(cubit.customerFiltersModel
                  .copyWith(pageNumber: Wrapped.value(pageIndex)));

              cubit.fetchCustomers();
            },
            onSelectAll: (val) {
              cubit.resetSelectedCustomers();

              // if (val != null && val) {
              // } else {
              //   cubit.resetSelectedCustomers();
              // }
            },
            source: CustomersDataTable(
              customerCubit: cubit,
              onSelect: (val, CustomerModel currentCustomer) {
                cubit.updateSelectedCustomersIds(
                    currentCustomer.customerId, val);

                // Navigator.pushNamed(
                //     context, Routes.modifyEmployeeRoute,
                //     arguments: ModifyEmployeeArgs(
                //         employeeModel: currentEmployee,
                //         customerCubit: cubit,
                //         fromRoute: Routes.employeesRoute));
              },
              context: context,
              teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context),
              employeeCubit: BlocProvider.of<EmployeeCubit>(context),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        final cubit = CustomerCubit.get(context);
        if (state is EndUpdateCustomerLastAction) {
          Constants.showToast(
              msg: "تم تحديث الحدث", color: Colors.green, context: context);
        }

        if (state is UpdateCustomerLastActionError) {
          Constants.showToast(
              msg: "UpdateCustomerLastActionError" + state.msg,
              color: Colors.red,
              context: context);
        }

        if (state is EndUpdateBulkCustomers) {
          cubit.resetSelectedCustomers();
          Constants.showToast(
              msg: "تم تحديث العملاء", color: Colors.green, context: context);
        }

        if (state is UpdateBulkCustomersError) {
          Constants.showToast(
              msg: "UpdateBulkCustomersError" + state.msg,
              color: Colors.red,
              context: context);
        }
      },
      builder: (context, state) {
        final customerCubit = CustomerCubit.get(context);
        return Scaffold(
          appBar: CustomersAppBar(
            customerCubit: customerCubit,
            onSearchChangeCallback: (search) {
              customerCubit.updateFilter(customerCubit.customerFiltersModel
                  .copyWith(fullNameOrPhoneNumber: Wrapped.value(search)));

              Constants.refreshCustomers(customerCubit);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                customerCubit.updateFilter(customerCubit.customerFiltersModel
                    .copyWith(
                        fullNameOrPhoneNumber: const Wrapped.value(null)));

                Constants.refreshCustomers(customerCubit);
              }
            },
            teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context),
          ),
          body: _buildBodyTable(cubit: customerCubit, state: state),
          drawer: CustomDrawer(customerCubit: customerCubit),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget._scrollController.dispose();
  }
}
