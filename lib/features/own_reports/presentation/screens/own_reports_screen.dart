
import 'dart:math';

import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/core/widgets/error_item_widget.dart';
import 'package:crm_flutter_project/features/own_reports/presentation/cubit/own_reports_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../customers/data/models/customer_filters_model.dart';
import '../../../customers/presentation/screens/customers_screen.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../widget/own_reports_app_bar.dart';
import '../../../../config/locale/app_localizations.dart';

class OwnReportsScreen extends StatefulWidget {

  final _scrollController = ScrollController();

   OwnReportsScreen({Key? key}) : super(key: key) {
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

  @override
  State<OwnReportsScreen> createState() => _OwnReportsScreenState();
}

class _OwnReportsScreenState extends State<OwnReportsScreen>  with WindowListener {


  Widget _buildBody(OwnReportsCubit ownReportsCubit, OwnReportsState state, BuildContext context) {
    if (state is StartFetchEmployeeReports) {
      return const Center(child: CircularProgressIndicator(),);
    }

    if (state is FetchEmployeeReportsError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          ownReportsCubit.fetchEmployeeReports();
        },
      );
    }

    if (state is EndFetchEmployeeReports) {
      final customerTypesCount = state.employeeStatisticsResult
          .employeeCustomerTypesCount;
      final eventsTypes = state.employeeStatisticsResult
          .employeeLastEventsReportList;

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          controller: widget._scrollController,
          slivers: [
            SliverToBoxAdapter(
                child: Column(
                  children: [

                    Row(
                      children: [
                        Image.asset(ImgAssets.iconLauncher,
                          height: 100.0, width: 100.0, fit: BoxFit.cover,),
                        const SizedBox(height: 10.0,),

                        OutlinedButton(onPressed: () {
                          Navigator.pushNamed(context, Routes.customersRoute,
                              arguments: CustomersArgs()).then((value) {
                            ownReportsCubit.fetchEmployeeReports();
                          });
                          // "الي صفحة العملاء"
                        }, child: Text(AppLocalizations.of(context)!.translate('to_customers')!)),

                      ],
                    ),





                    const DefaultHeightSizedBox(),
                    const Divider(),
                    const DefaultHeightSizedBox(),
                  ],
                )
            ),


            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewMyAssignedLeads))

              SliverToBoxAdapter(
                child: Wrap(
                  runSpacing: 20.0,
                  spacing: 20.0,
                  direction: Axis.horizontal,
                  children: [

                    CustomElement(
                      onTapCallback: () {


                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),


                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId:


                            Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(
                                getCustomerTypeName(ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType))
                        );

                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });
                      },
                      title: "ALL",
                      value: customerTypesCount.all.toString(),
                    ),

                    CustomElement(
                      onTapCallback: () {


                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),
                            lastEventIds: const Wrapped.value([0]),
                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(
                                getCustomerTypeName(ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType))
                        );


                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },
                      title: "No Action",
                      value: customerTypesCount.noEvent.toString(),
                    ),

                    CustomElement(
                      onTapCallback: () {


                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),

                            reminderTypes: Wrapped.value(ReminderTypes.NOW.name),
                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(
                                getCustomerTypeName(ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType))
                        );
                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },
                      title: "TODAY",
                      value: customerTypesCount.now.toString(),
                    ),


                    CustomElement(
                      onTapCallback: () {

                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),

                            reminderTypes: Wrapped.value(ReminderTypes.DELAYED.name),
                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(
                                getCustomerTypeName(ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType))
                        );


                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                              assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                              [ownReportsCubit.selectedEmployee!]: null,
                              customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },
                      title: "UPCOMING",
                      value: customerTypesCount.delayed.toString(),
                    ),


                    CustomElement(
                      onTapCallback: () {


                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),

                            reminderTypes: Wrapped.value(ReminderTypes.SKIP.name),
                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(
                                getCustomerTypeName(ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType))
                        );
                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },

                      title: "DELAY",
                      value: customerTypesCount.skip.toString(),
                    ),



                  ],

                ),
              ),



            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewOwnLeads))
              SliverToBoxAdapter(

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultHeightSizedBox(),
                    CustomElement(
                      onTapCallback: () {


                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),

                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(CustomerTypes.OWN.name)
                        );
                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },
                      title: "OWN",
                      value: customerTypesCount.own.toString(),
                    ),

                    const Divider(),


                  ],
                ),
              ),



            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewAllStatistics) ||
                (Constants.currentEmployee!.permissions.contains(AppStrings.viewNotAssignedLeads)))
              SliverToBoxAdapter(

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DefaultHeightSizedBox(),
                    CustomElement(
                      onTapCallback: () {

                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(

                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),

                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null ? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(CustomerTypes.NOT_ASSIGNED.name)
                        );
                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },
                      title: "FRESH",
                      value: customerTypesCount.notAssigned.toString(),
                    ),

                    const Divider(),

                  ],
                ),
              ),




            const SliverToBoxAdapter(
              child: Text("علي حسب نوع الايفينت"),
            ),

            if (Constants.currentEmployee!.permissions.contains(AppStrings.viewMyAssignedLeads))
              SliverList(delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final currentItem = eventsTypes[index];

                    return ListTile(
                      onTap: () {
                        CustomerFiltersModel customerFiltersModel = CustomerFiltersModel.initial().copyWith(
                            startDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.startDate),
                            endDateTime: Wrapped.value(ownReportsCubit.countCustomerTypeFiltersModel.endDate),
                            lastEventIds:  Wrapped.value([currentItem.event.eventId]),
                            teamId: Wrapped.value(Constants.currentEmployee?.teamId),
                            assignedEmployeeIds:
                            ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType
                                == EmployeeReportType.SPECIFIC.name  &&
                                ownReportsCubit.countCustomerTypeFiltersModel.employeeId != null? Wrapped.value(
                                [ownReportsCubit.countCustomerTypeFiltersModel.employeeId!]
                            ) : const Wrapped.value(null),
                            employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                            customerTypes: Wrapped.value(
                                getCustomerTypeName(ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType))
                        );


                        Navigator.pushNamed(context, Routes.customersRoute,
                            arguments: CustomersArgs(
                              selectedEvents: [currentItem.event],
                                assignedEmployee: ownReportsCubit.selectedEmployee != null ?
                                [ownReportsCubit.selectedEmployee!]: null,
                                customerFiltersModel: customerFiltersModel
                            )).then((value) {
                          ownReportsCubit.fetchEmployeeReports();
                        });

                      },
                      title: Text(currentItem.event.name),
                      subtitle: Text(currentItem.count.toString()),
                    );
                  },
                  childCount: eventsTypes.length
              )),

          ],
        )
      );
    }

    return const Center(child: CircularProgressIndicator(),);
  }

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    widget._scrollController.dispose();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {

      final result = await Constants.showConfirmDialog(context: context, msg: 'هل تريد تأكيد الخروج ؟');

      if (result) {
        Navigator.pop(context);
        windowManager.destroy();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OwnReportsCubit, OwnReportsState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final ownReportsCubit = OwnReportsCubit.get(context);


          return Scaffold(
            appBar: OwnReportsAppBar(ownReportsCubit: ownReportsCubit,
              teamMembersCubit: BlocProvider.of<TeamMembersCubit>(context),),
            body: _buildBody(ownReportsCubit, state, context),
          );

      },
    );
  }

  String? getCustomerTypeName(String employeeReportType) {
    if (employeeReportType == EmployeeReportType.ME.name) {
      return CustomerTypes.ME.name;
    } else if (employeeReportType == EmployeeReportType.ME_AND_TEAM.name) {
      return CustomerTypes.ME_AND_TEAM.name;
    } else if (employeeReportType == EmployeeReportType.TEAM.name) {
      return CustomerTypes.TEAM.name;

    } else if (employeeReportType == EmployeeReportType.ALL.name) {
      return CustomerTypes.ALL.name;

    } else if (employeeReportType == EmployeeReportType.SPECIFIC.name) {

      if (Constants.currentEmployee!.permissions.contains(AppStrings.viewAllLeads)) {
        return CustomerTypes.ALL.name;
      } else if (Constants.currentEmployee?.teamId != null){
        return CustomerTypes.ME_AND_TEAM.name;
      }

      return CustomerTypes.OWN.name;

    }

    return null;
  }
}


class CustomElement extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTapCallback;
  const CustomElement({Key? key, required this.title, required this.value,  this.onTapCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),

          gradient: const LinearGradient(
            colors: [
              Colors.blueGrey,
              Colors.grey
            ]
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white),),
              const Divider(),
              Text(value, style: const TextStyle(fontSize: 30.0, color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
