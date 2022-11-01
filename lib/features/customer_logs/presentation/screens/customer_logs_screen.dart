
import 'dart:math';

import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/widgets/default_user_avatar_widget.dart';
import 'package:crm_flutter_project/features/customer_logs/presentation/cubit/customer_logs_cubit.dart';
import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/customer_datails_screen.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkwell/linkwell.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../customers/presentation/widgets/DateFilterPicker.dart';
import '../../../customers/presentation/widgets/filter_field.dart';

class CustomerLogsScreen extends StatelessWidget {
  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;
   CustomerLogsScreen({Key? key}) : super(key: key) {
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
     }
   }

  void _getPageCustomerLogs(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<CustomerLogsCubit>(context)
        .fetchCustomerLogs(refresh: refresh);
  }

  Widget _buildList(CustomerLogsCubit customerLogsCubit,
      CustomerLogsState state, BuildContext context) {

    if (state is StartRefreshCustomerLogs) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RefreshCustomerLogsError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _getPageCustomerLogs(context: context, refresh: true);
        },
      );
    }

    if (customerLogsCubit.customerLogs.isEmpty &&
        (state is EndRefreshCustomerLogs)) {
      return const Center(
        child: Text("فارغ"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("النتائج: ${customerLogsCubit.customerLogTotalElements}"),
        ),

        Expanded(
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {

              if (index < customerLogsCubit.customerLogs.length) {
                final currentLog = customerLogsCubit.customerLogs[index];
                return ListTile(
                  leading:  SizedBox(
                    width: 50.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DefaultUserAvatarWidget(
                          onTap: () {
                            if (currentLog.employee != null) {
                              Navigator.pushNamed(context, Routes.employeesDetailsRoute,
                                  arguments: EmployeeDetailsArgs(
                                      employeeId: currentLog.employee!.employeeId,
                                      employeeCubit: BlocProvider.of<EmployeeCubit>(context),
                                      fromRoute: Routes.customerLogsRoute));
                            }
                          },
                          imageUrl: currentLog.employee?.imageUrl,
                          height: 50.0,
                          fullName: currentLog.employee?.fullName),

                        Text(currentLog.employee != null ?
                        currentLog.employee!.fullName : "غير معرف", style: const TextStyle(
                          fontSize: 9.0
                        ),)
                      ],
                    ),
                  ),
                  title: LinkWell(
                    currentLog.description != null
                        ? (currentLog.description!)
                        : "لا يوجد",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            if (currentLog.customer != null) {
                              Navigator.pushNamed(context, Routes.customersDetailsRoute,
                                  arguments: CustomerDetailsArgs(
                                      customerModel: currentLog.customer!,
                                      customerCubit: BlocProvider.of<CustomerCubit>(context),
                                      teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context),
                                      fromRoute: Routes.customerLogsRoute));
                            }

                          },
                          child: Text(getCustomerName(
                              currentLog.customer), style: const TextStyle(
                              fontSize: 14.0
                          )),
                        ),
                      ),
                      const SizedBox(height: 5.0,),
                      Text(Constants.timeAgoSinceDate(currentLog.dateTime), style: const TextStyle(fontSize: 14.0))

                    ],
                  ),


                );
              } else {
                if (customerLogsCubit.isNoMoreData) {
                  return const Text("وصلت للنهاية", style: TextStyle(fontSize: 15.0),);
                }  else {
                  if( state is StartLoadingCustomerLogs) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        _getPageCustomerLogs(context: context);
                      },
                      child: const Text("حمل المزيد"),
                    );
                  }
                }
              }

            },


            itemCount: customerLogsCubit.customerLogs.length + 1,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),

        // if (customerLogsCubit.customerLogs.isNotEmpty)
        //   SizedBox(
        //     width: context.width,
        //     child: NumberPaginator(
        //         onPageChange: (index) {
        //           customerLogsCubit.setCurrentPage(index);
        //
        //           customerLogsCubit.updateFilter(customerLogsCubit
        //               .customerLogFiltersModel
        //               .copyWith(pageNumber: Wrapped.value(index)));
        //
        //           _getPageCustomerLogs(context: context, refresh: true);
        //         },
        //         initialPage: customerLogsCubit.customerLogCurrentPage,
        //         numberPages: customerLogsCubit.customerLogPagesCount),
        //   ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerLogsCubit, CustomerLogsState>(
      builder: (context, state) {
        final customerLogsCubit = CustomerLogsCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("سجلات العملاء"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(45),
              child: SizedBox(
                height: 45,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 5.0),
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Constants.showDialogBox(
                              context: context,
                              title: "فلتر حسب التاريخ",
                              content: DateFilterPicker(
                                startDateTime: customerLogsCubit
                                    .customerLogFiltersModel.startDateTime,
                                endDateTime: customerLogsCubit
                                    .customerLogFiltersModel.endDateTime,
                                onSelectTypeCallback: (int? start, int? end) {
                                  customerLogsCubit.updateFilter(
                                      customerLogsCubit.customerLogFiltersModel
                                          .copyWith(
                                    startDateTime: Wrapped.value(start),
                                    endDateTime: Wrapped.value(end),
                                  ));

                                  customerLogsCubit.fetchCustomerLogs(
                                      refresh: true);
                                },
                              ));
                        },
                        child: FilterField(
                          text: Row(
                            children: [
                              Text(Constants.getDateType(
                                customerLogsCubit
                                    .customerLogFiltersModel.startDateTime,
                                customerLogsCubit
                                    .customerLogFiltersModel.endDateTime,
                              )),
                              Icon(
                                Icons.arrow_drop_down,
                                color: customerLogsCubit.customerLogFiltersModel
                                                .startDateTime !=
                                            null &&
                                        customerLogsCubit
                                                .customerLogFiltersModel
                                                .endDateTime !=
                                            null
                                    ? AppColors.primary
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        )),

                    SelectPersonItem(
                      onSelectPersonCallback: (int employeeId) {

                        customerLogsCubit.updateFilter(customerLogsCubit
                            .customerLogFiltersModel
                            .copyWith(employeeId: Wrapped.value(employeeId)));

                        customerLogsCubit.resetData();

                        customerLogsCubit.fetchCustomerLogs(
                             refresh: true);

                      }, onClearTapCallback: () {

                      customerLogsCubit.updateFilter(customerLogsCubit
                          .customerLogFiltersModel
                          .copyWith(
                          employeeId: const Wrapped.value(null)));


                      customerLogsCubit.resetData();

                      customerLogsCubit.fetchCustomerLogs(
                           refresh: true);

                    }, employeeId: customerLogsCubit.customerLogFiltersModel.employeeId,
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _buildList(customerLogsCubit, state, context),
        );
      },
    );
  }

  String getCustomerName(
      CustomerModel? customerModel) {
    String customerName = customerModel != null
        ? "العميل: " + customerModel.fullName
        : "غير معرف";


    return customerName;
  }

  String getEmployeeName(
      EmployeeModel? employeeModel) {

    String employeeName = employeeModel != null
        ? "بواسطة: " + employeeModel.fullName
        : "غير معرف";

    return  employeeName;
  }

}

class SelectPersonItem extends StatefulWidget {
  final Function onSelectPersonCallback;
  final VoidCallback onClearTapCallback;
  final int? employeeId;
  const SelectPersonItem({Key? key,
    required this.onSelectPersonCallback,
    required this.onClearTapCallback,
    required this.employeeId,})
      : super(key: key);

  @override
  State<SelectPersonItem> createState() => _SelectPersonItemState();
}

class _SelectPersonItemState extends State<SelectPersonItem> {
  String? personName;
  int? employeeId;

  @override
  void initState() {
    super.initState();
    employeeId = widget.employeeId;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.employeePickerRoute,
            arguments: EmployeePickerArgs(
                employeePickerTypes:
                EmployeePickerTypes.SELECT_EMPLOYEE.name,
                teamMembersCubit:
                BlocProvider.of<TeamMembersCubit>(context)))
            .then((value) {
          if (value != null && value is Map<String, dynamic>) {
            debugPrint(value.toString());
            EmployeeModel em = EmployeeModel.fromJson(value);
            personName = em.fullName;
            employeeId = em.employeeId;

            setState(() {});

            widget.onSelectPersonCallback(em.employeeId);
          }
        });
      },
      child: FilterField(
        text: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text((personName != null && employeeId != null) ? personName! : "كل الموظفون"),
            const SizedBox(width: 10.0,),

            if (personName != null && employeeId != null)
            InkWell(
                onTap: () {
                  personName = null;
                  employeeId = null;

                  setState(() {});

                  widget.onClearTapCallback();

                },
                child:  Text("مسح الفلتر", style: TextStyle(color: AppColors.primary),)),

          ],
        ),
      ),
    );
  }
}
