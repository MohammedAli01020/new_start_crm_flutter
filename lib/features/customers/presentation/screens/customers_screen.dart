import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';

import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';

import 'package:flutter/material.dart';


import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/presentation/cubit/employee_cubit.dart';
import '../../../employees/presentation/screens/employee_details_screen.dart';
import '../../data/models/customer_filters_model.dart';
import '../../data/models/customer_model.dart';
import '../../data/models/event_model.dart';
import '../cubit/customer_cubit.dart';
import '../widgets/create_new_action_dailog.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/customers_app_bar.dart';
import '../widgets/customers_data_table.dart';
import '../widgets/duplicate_customers_widget.dart';
import 'customer_datails_screen.dart';

class CustomersScreen extends StatefulWidget {
  final _scrollController = ScrollController();

  final _gridScrollController = ScrollController();


  final CustomersArgs customersArgs;

  CustomersScreen({Key? key, required this.customersArgs}) : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? Constants.extraScrollSpeed
                  : -Constants.extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });

      _gridScrollController.addListener(() {
        ScrollDirection scrollDirection =
            _gridScrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _gridScrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? Constants.extraScrollSpeed
                  : -Constants.extraScrollSpeed);
          scrollEnd = min(_gridScrollController.position.maxScrollExtent,
              max(_gridScrollController.position.minScrollExtent, scrollEnd));
          _gridScrollController.jumpTo(scrollEnd);
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

  final _tableKey = GlobalKey<PaginatedDataTableState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final customerCubit = BlocProvider.of<CustomerCubit>(context);
    if (widget.customersArgs.customerFiltersModel != null) {

      customerCubit.updateFilter(widget.customersArgs.customerFiltersModel!);
      customerCubit.updateSelectedAssignEmployeeIds(widget.customersArgs.assignedEmployee);
      customerCubit.updateSelectedEvents(widget.customersArgs.selectedEvents);

      customerCubit.fetchCustomers(refresh: true);
    } else {
      Constants.refreshCustomers(customerCubit);
    }

  }

  Widget _buildBodyTable(
      {required CustomerCubit cubit, required CustomerState state}) {

    if (Constants.customerTableConfigModel.isVertical ?? false) {
      if (state is StartRefreshCustomers) {
        return const Center(child: CircularProgressIndicator());
      }
    }


    if (state is RefreshCustomersError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          Constants.refreshCustomers(cubit);
        },
      );
    }


    if (Constants.customerTableConfigModel.isVertical ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text("العملاء: " + cubit.customerTotalElements.toString(), style: const TextStyle(fontSize: 14.0),),
                const Spacer(),

                state is StartRefreshCustomers
                    ? const Center(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(),
                  ),
                )
                    : IconButton(
                    onPressed: () {
                      _tableKey.currentState?.pageTo(0);
                      cubit.updateTableIndex(1);
                      cubit.setSelectedCustomers([]);
                      Constants.refreshCustomers(cubit);

                      widget._gridScrollController.animateTo(0,
                          duration: const Duration(milliseconds: 500), curve: Curves.linear);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                int colCount = max(1, (constraints.maxWidth / 200).floor());

                return GridView.builder(
                    controller: widget._gridScrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: cubit.customers.length + 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: colCount,
                        childAspectRatio: 1,
                        mainAxisExtent: 425.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0),
                    itemBuilder: (context, index) {
                      if (index < cubit.customers.length) {
                        final currentCustomer = cubit.customers[index];

                        return GestureDetector(
                          onLongPress: () {

                            cubit.updateSelectedCustomers(currentCustomer,
                                !cubit.selectedCustomers.contains(currentCustomer));
                          },
                          onTap: () {
                            if (cubit.selectedCustomers.isEmpty) {
                              Navigator.pushNamed(context, Routes.customersDetailsRoute,
                                  arguments: CustomerDetailsArgs(
                                      customerModel: currentCustomer,
                                      customerCubit: cubit,
                                      fromRoute: Routes.customersRoute,
                                      teamMembersCubit:
                                      BlocProvider.of<TeamMembersCubit>(context)));
                            } else {
                              cubit.updateSelectedCustomers(currentCustomer,
                                  !cubit.selectedCustomers.contains(currentCustomer));
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: cubit.selectedCustomers.contains(currentCustomer)
                                  ? Colors.blueGrey[100]
                                  : Theme.of(context).highlightColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (Constants.customerTableConfigModel.showName)
                                  InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, Routes.customersDetailsRoute,
                                            arguments: CustomerDetailsArgs(
                                                customerModel: currentCustomer,
                                                customerCubit: cubit,
                                                fromRoute: Routes.customersRoute,
                                                teamMembersCubit:
                                                BlocProvider.of<TeamMembersCubit>(
                                                    context)));
                                      },
                                      child: Constants.currentEmployee!.permissions
                                          .contains(AppStrings.viewLeadName)
                                          ? Text(currentCustomer.fullName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center)
                                          : const Text("عرض التفاصيل",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center)),
                                if (Constants.customerTableConfigModel.showPhone)
                                  Constants.currentEmployee!.permissions
                                      .contains(AppStrings.viewLeadPhone)
                                      ? Column(
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
                                                      icon:
                                                      const Icon(Icons.call),
                                                      onPressed: () {
                                                        try {
                                                          Constants.launchCallerV2(
                                                              currentCustomer
                                                                  .phoneNumbers[0]);
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                          Constants.showToast(
                                                              msg: "تعذر الاتصال",
                                                              context: context);
                                                        }
                                                      },
                                                    ),
                                                    const DefaultHeightSizedBox(),
                                                    TextButton.icon(
                                                      label: const Text(
                                                          "رسالة واتس"),
                                                      icon: const Icon(
                                                          Icons.whatsapp),
                                                      onPressed: () {
                                                        try {
                                                          Constants.launchWhatsAppV2(
                                                              currentCustomer
                                                                  .phoneNumbers[0],
                                                              "message");
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                          Constants.showToast(
                                                              msg:
                                                              "تعذر فتح الواتس اب",
                                                              context: context);
                                                        }
                                                      },
                                                    ),
                                                    const DefaultHeightSizedBox(),
                                                    TextButton.icon(
                                                      label:
                                                      const Text("نسخ الرقم"),
                                                      icon: const Icon(
                                                        Icons.copy,
                                                      ),
                                                      onPressed: () {
                                                        try {
                                                          Constants.copyText(
                                                              currentCustomer
                                                                  .phoneNumbers
                                                                  .first)
                                                              .then((value) {
                                                            Constants.showToast(
                                                                msg: "تم النسخ",
                                                                context: context);
                                                          });
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                          Constants.showToast(
                                                              msg: "تعذر الاتصال",
                                                              context: context);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ));
                                          },
                                          child: Text(
                                            currentCustomer.phoneNumbers[0],
                                            style: Theme.of(context).textTheme.button,
                                          )),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      currentCustomer.phoneNumbers.length > 1
                                          ? InkWell(
                                          onTap: () {
                                            Constants.showDialogBox(
                                                context: context,
                                                title: "رقم الهاتف",
                                                content: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    TextButton.icon(
                                                      label:
                                                      const Text("اتصال"),
                                                      icon: const Icon(
                                                          Icons.call),
                                                      onPressed: () {
                                                        try {
                                                          Constants.launchCallerV2(
                                                              currentCustomer
                                                                  .phoneNumbers[1]);
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                          Constants.showToast(
                                                              msg:
                                                              "تعذر الاتصال",
                                                              context:
                                                              context);
                                                        }
                                                      },
                                                    ),
                                                    const DefaultHeightSizedBox(),
                                                    TextButton.icon(
                                                      label: const Text(
                                                          "رسالة واتس"),
                                                      icon: const Icon(
                                                          Icons.whatsapp),
                                                      onPressed: () {
                                                        try {
                                                          Constants.launchWhatsAppV2(
                                                              currentCustomer
                                                                  .phoneNumbers[1],
                                                              "message");
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                          Constants.showToast(
                                                              msg:
                                                              "تعذر فتح الواتس اب",
                                                              context:
                                                              context);
                                                        }
                                                      },
                                                    ),
                                                    const DefaultHeightSizedBox(),
                                                    TextButton.icon(
                                                      label: const Text(
                                                          "نسخ الرقم"),
                                                      icon: const Icon(
                                                        Icons.copy,
                                                      ),
                                                      onPressed: () {
                                                        try {
                                                          Constants.copyText(
                                                              currentCustomer
                                                                  .phoneNumbers[1])
                                                              .then((value) {
                                                            Constants.showToast(
                                                                msg:
                                                                "تم النسخ",
                                                                context:
                                                                context);
                                                          });
                                                        } catch (e) {
                                                          debugPrint(
                                                              e.toString());
                                                          Constants.showToast(
                                                              msg:
                                                              "تعذر الاتصال",
                                                              context:
                                                              context);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ));
                                          },
                                          child: Text(
                                              currentCustomer.phoneNumbers[1],
                                              style:Theme.of(context).textTheme.button,))
                                          : InkWell(
                                          onTap: () {},
                                          child: Text("no",
                                              style: Theme.of(context).textTheme.button,)),
                                    ],
                                  )
                                      : const Text("مخفي"),
                                if (Constants.customerTableConfigModel.showAssignedTo)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DefaultUserAvatarWidget(
                                        onTap: () {
                                          if (currentCustomer.assignedEmployee !=
                                              null) {
                                            Navigator.pushNamed(
                                                context, Routes.employeesDetailsRoute,
                                                arguments: EmployeeDetailsArgs(
                                                    employeeId: currentCustomer
                                                        .assignedEmployee!.employeeId,
                                                    employeeCubit:
                                                    BlocProvider.of<EmployeeCubit>(
                                                        context),
                                                    fromRoute: Routes.customersRoute));
                                          }
                                        },
                                        imageUrl: null,
                                        fullName:
                                        currentCustomer.assignedEmployee?.fullName,
                                        height: 25.0,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          currentCustomer.assignedEmployee != null
                                              ? currentCustomer
                                              .assignedEmployee!.fullName
                                              : "لا يوجد",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                if (Constants.customerTableConfigModel.showLastAction)
                                  (cubit.currentUpdateActions.contains(index)
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
                                          title:
                                          currentCustomer.lastAction == null
                                              ? "ادخل حدث جديد"
                                              : "غير الحدث او عدلة",
                                          content: CreateNewAction(
                                            lastActionModel:
                                            currentCustomer.lastAction,
                                            onConfirmAction:
                                                (UpdateCustomerLastActionParam
                                            param) {
                                              cubit.updateCustomerLastAction(
                                                  param, index);
                                              Navigator.of(context).pop(true);
                                            },
                                            customerId:
                                            currentCustomer.customerId,
                                          ),
                                        );
                                      } else {
                                        Constants.showToast(
                                            msg: "غير مصرح", context: context);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: _getColor(currentCustomer.lastAction?.event),
                                          shape: BoxShape.rectangle,
                                          border: Border.all(color: Colors.blueGrey)),
                                      child: Text(
                                        currentCustomer.lastAction != null &&
                                            currentCustomer
                                                .lastAction!.event !=
                                                null
                                            ? currentCustomer
                                            .lastAction!.event!.name +
                                            "\n"
                                            : "لا يوجد" "\n",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )),
                                if (Constants.customerTableConfigModel.showLastComment)
                                  Text(
                                    currentCustomer.lastAction != null &&
                                        currentCustomer
                                            .lastAction!.actionDescription !=
                                            null &&
                                        currentCustomer.lastAction!
                                            .actionDescription!.isNotEmpty
                                        ? currentCustomer
                                        .lastAction!.actionDescription! +
                                        "\n"
                                        : "لا يوجد" "\n",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (Constants.customerTableConfigModel.showUnitTypes)
                                  Text(
                                    currentCustomer.unitTypes.isNotEmpty
                                        ? currentCustomer.unitTypes.length > 2
                                        ? currentCustomer.unitTypes
                                        .sublist(0, 2)
                                        .map((e) => e)
                                        .toString() +
                                        ", ${currentCustomer.unitTypes.length - 2} "
                                        : currentCustomer.unitTypes
                                        .map((e) => e)
                                        .toString()
                                        : "لا يوجد",
                                    maxLines: 1,
                                  ),
                                if (Constants.customerTableConfigModel.showDevelopers)
                                  Text(
                                    currentCustomer.developers.isNotEmpty
                                        ? currentCustomer.developers.length > 2
                                        ? currentCustomer.developers
                                        .sublist(0, 2)
                                        .map((e) => e)
                                        .toString() +
                                        ", ${currentCustomer.developers.length - 2} "
                                        : currentCustomer.developers
                                        .map((e) => e)
                                        .toString()
                                        : "لا يوجد",
                                    maxLines: 1,
                                  ),
                                if (Constants.customerTableConfigModel.showProjects)
                                  Text(
                                    currentCustomer.projects.isNotEmpty
                                        ? currentCustomer.projects.length > 2
                                        ? currentCustomer.projects
                                        .sublist(0, 2)
                                        .map((e) => e)
                                        .toString() +
                                        ", ${currentCustomer.projects.length - 2} "
                                        : currentCustomer.projects
                                        .map((e) => e)
                                        .toString()
                                        : "لا يوجد",
                                    maxLines: 1,
                                  ),
                                if (Constants
                                    .customerTableConfigModel.showLastActionTime)
                                  (Text("اخر اكشن: " +
                                      Constants.timeAgoSinceDate(
                                          currentCustomer.lastAction?.dateTime))),
                                if (Constants.customerTableConfigModel.showInsertDate)
                                  Text("ادخال: " +
                                      Constants.timeAgoSinceDate(
                                          currentCustomer.createDateTime)),
                                if (Constants.customerTableConfigModel.showReminderTime)
                                  (Text(currentCustomer.lastAction != null &&
                                      currentCustomer
                                          .lastAction!.postponeDateTime !=
                                          null
                                      ? Constants.dateTimeFromMilliSeconds(
                                      currentCustomer.lastAction!.postponeDateTime)
                                      : "لا يوجد")),

                                const Spacer(),

                                if (Constants.customerTableConfigModel.showDuplicateNumber)
                                  (Row(
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
                                                    currentCustomer.duplicateNo
                                                        .toString(),
                                                content: DuplicatesCustomers(
                                                  phoneNumbersWrapper:
                                                  PhoneNumbersWrapper(
                                                      phoneNumbers: currentCustomer
                                                          .phoneNumbers),
                                                  teamMembersCubit:
                                                  BlocProvider.of<TeamMembersCubit>(
                                                      context),
                                                  customerCubit: cubit,
                                                  employeeCubit:
                                                  BlocProvider.of<EmployeeCubit>(
                                                      context),
                                                ));
                                          },
                                          icon: Icon(
                                            Icons.visibility_outlined,
                                            color: currentCustomer.duplicateNo == 0 ||
                                                !Constants
                                                    .currentEmployee!.permissions
                                                    .contains(AppStrings
                                                    .viewDuplicatesLeads)
                                                ? Colors.grey
                                                : AppColors.primary,
                                          ),
                                        ),
                                    ],
                                  )),
                                if (Responsive.isDesktopDevice)
                                  Checkbox(
                                      value: cubit.selectedCustomers
                                          .contains(currentCustomer),
                                      onChanged: (val) {
                                        cubit.updateSelectedCustomers(
                                            currentCustomer, val ?? false);
                                      }),
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
                          if (state is StartLoadingCustomers) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return ElevatedButton(
                              onPressed: () {
                                _getPageCustomers();
                              },
                              child: const Text("حمل المزيد"),
                            );
                          }
                        }
                      }
                    });
              },
            ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        controller: widget._scrollController,
        child: SizedBox(
          width: context.width,
          child: PaginatedDataTable(

            key: _tableKey,
              columns: [
                if (Constants.customerTableConfigModel.showName)
                  const DataColumn(label: Text('الاسم')),
                if (Constants.customerTableConfigModel.showPhone)
                  const DataColumn(label: Text('رقم التليفون')),
                if (Constants.customerTableConfigModel.showAssignedTo)
                  const DataColumn(label: Text('معين إلي')),
                if (Constants.customerTableConfigModel.showLastAction)
                  const DataColumn(label: Text('أخر حالة')),
                if (Constants.customerTableConfigModel.showLastComment)
                  const DataColumn(label: Text('اخر تعليق')),
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
              header: Text("العملاء: " + cubit.customerTotalElements.toString(), style: const TextStyle(fontSize: 14.0),),
              actions: [
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
                    _tableKey.currentState?.pageTo(0);
                    cubit.updateTableIndex(1);
                    cubit.setSelectedCustomers([]);

                    cubit.fetchCustomers(refresh: true);

                    // Constants.refreshCustomers(cubit);
                  },
                  icon: const Icon(Icons.refresh))
              ],

              // showFirstLastButtons: true,
              showCheckboxColumn: Responsive.isDesktopDevice || cubit.selectedCustomers.isNotEmpty,
              rowsPerPage: cubit.customerFiltersModel.pageSize ~/ 2,
              onPageChanged: (pageIndex) async {

                await cubit.fetchCustomers();
              },

              onSelectAll: (val) async {

                if (val != null && val == false) {
                  cubit.setSelectedCustomers([]);
                } else {
                  if (state is StartUpdateSelectedCustomers) {
                    Constants.showToast(msg: "انتظر جاري التحميل ...", context: context);
                    return;
                  }
                  await cubit.fetchAllCustomers();
                }
              },
              source: CustomersDataTable(
                customerCubit: cubit,
                onSelect: (val, CustomerModel currentCustomer) {

                  if (Responsive.isDesktopDevice) {
                    cubit.updateSelectedCustomers(currentCustomer, val);
                  } else {
                    if (cubit.selectedCustomers.isEmpty) {
                      Navigator.pushNamed(context, Routes.customersDetailsRoute,
                          arguments: CustomerDetailsArgs(
                              customerModel: currentCustomer,
                              customerCubit: cubit,
                              fromRoute: Routes.customersRoute,
                              teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context)));
                    } else {
                      cubit.updateSelectedCustomers(currentCustomer, val);
                    }
                  }


                },
                onLongPressCallback: (CustomerModel currentCustomer) {
                  cubit.updateSelectedCustomers(currentCustomer, true);
                },
                context: context,
                teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context),
                employeeCubit: BlocProvider.of<EmployeeCubit>(context),
                customerState: state,
              )),
        ),
      );
    }
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
          cubit.setSelectedCustomers([]);
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
        return WillPopScope(
          onWillPop: () async {
            if (customerCubit.selectedCustomers.isNotEmpty) {
              customerCubit.setSelectedCustomers([]);
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomersAppBar(
              customerCubit: customerCubit,
              customerState: state,
              onSearchChangeCallback: (search) {

                customerCubit.updateFilter(customerCubit.customerFiltersModel
                    .copyWith(fullNameOrPhoneNumber: Wrapped.value(search)));

                Constants.refreshCustomers(customerCubit).then((value) {
                  _tableKey.currentState?.pageTo(0);
                });

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
              onFilterChangeCallback: () {
                _tableKey.currentState?.pageTo(0);
                customerCubit.updateTableIndex(1);

                widget._gridScrollController.animateTo(0,
                    duration: const Duration(milliseconds: 500), curve: Curves.linear);
              },
              onTapDrawer: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            body: _buildBodyTable(cubit: customerCubit, state: state),
            drawer: CustomDrawer(customerCubit: customerCubit),
          ),
        );
      },
    );
  }


  Color? _getColor(EventModel? event) {

    if (event == null || event.name == "No Action") return null;

    if (event.name == "Cancellation") {
      return Colors.red;
    } else if (event.name == "Contract") {
      return Colors.green;
    }

    return Colors.yellow;


  }


  @override
  void dispose() {
    widget._scrollController.dispose();
    widget._gridScrollController.dispose();
    super.dispose();
  }
}





class CustomersArgs {

  final CustomerFiltersModel? customerFiltersModel;
  final List<EmployeeModel>? assignedEmployee;
  final List<EventModel>? selectedEvents;

  CustomersArgs({this.customerFiltersModel, this.assignedEmployee, this.selectedEvents, });

}
