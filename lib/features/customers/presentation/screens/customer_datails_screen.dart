import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/widgets/default_bottom_navigation_widget.dart';

import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_model.dart';
import 'package:crm_flutter_project/features/customer_logs/presentation/cubit/customer_logs_cubit.dart';
import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/modify_customer_desc_widget.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/screens/developers_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:crm_flutter_project/features/unit_types/presentation/screens/unit_types_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkwell/linkwell.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/default_user_avatar_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/presentation/cubit/employee_cubit.dart';
import '../../../employees/presentation/screens/employee_details_screen.dart';
import '../../../sources/presentation/screens/sources_screen.dart';
import '../../../employees/presentation/screens/employee_picker_screen.dart';
import '../widgets/customer_log_data_table.dart';
import '../widgets/edit_customer_phone_widget.dart';
import '../widgets/modify_customer_name_widget.dart';
import 'modify_customer_screen.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerDetailsArgs customerDetailsArgs;

  final _scrollController = ScrollController();
  final _secondScrollController = ScrollController();

  CustomerDetailsScreen({Key? key, required this.customerDetailsArgs})
      : super(key: key) {
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


      _secondScrollController.addListener(() {
        ScrollDirection scrollDirection =
            _secondScrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _secondScrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? Constants.extraScrollSpeed
                  : -Constants.extraScrollSpeed);
          scrollEnd = min(_secondScrollController.position.maxScrollExtent,
              max(_secondScrollController.position.minScrollExtent, scrollEnd));
          _secondScrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  void _getPageCustomerLogs(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<CustomerLogsCubit>(context)
        .fetchCustomerLogs(refresh: refresh);
  }

  // late int customerId;
  // String fullName;
  // PhoneNumberModel phoneNumber;
  // int createDateTime;
  // String? description;
  // List<String> projects;
  // List<String> unitTypes;
  // List<String> sources;
  // EmployeeModel? createdBy;
  // LastActionModel? lastAction;
  // EmployeeModel? assignedEmployee;
  // EmployeeModel? assignedBy;
  // int? assignedDateTime;
  //
  // int? duplicateNo;

  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<CustomerCubit>(context);
    cubit.updateCurrentCustomerModel(CustomerModel.fromJson(
        widget.customerDetailsArgs.customerModel.toJson()));
  }

  @override
  void dispose() {
    super.dispose();
    widget._scrollController.dispose();
    widget._secondScrollController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is DeleteCustomerError) {
          Constants.showToast(
              msg: "DeleteCustomerError: " + state.msg, context: context);
        }

        if (state is EndDeleteCustomer) {
          Constants.showToast(
              msg: "تم حذف العميل بنجاح",
              color: Colors.green,
              context: context);
          Navigator.pop(context);
        }


        if (state is EndUpdateCustomerFullName) {
          Constants.showToast(
              msg: "تم تحديث اسم العميل بنجاح",
              color: Colors.green,
              context: context);
        }

        if (state is UpdateCustomerFullNameError) {
          Constants.showToast(
              msg: "UpdateCustomerFullNameError: " + state.msg,
              context: context);
        }


        if (state is EndUpdateCustomerDescription) {
          Constants.showToast(
              msg: "تم تحديث وصف العميل بنجاح",
              color: Colors.green,
              context: context);
        }

        if (state is UpdateCustomerDescriptionError) {
          Constants.showToast(
              msg: "UpdateCustomerDescriptionError: " + state.msg,
              context: context);
        }

        if (state is EndUpdateCustomerSources) {
          Constants.showToast(
              msg: "تم تحديث مصادر العميل بنجاح",
              color: Colors.green,
              context: context);
        }


        if (state is UpdateCustomerSourcesError) {
          Constants.showToast(
              msg: "UpdateCustomerSourcesError: " + state.msg,
              context: context);
        }


        if (state is EndDeleteCustomerAssignedEmployee) {
          Constants.showToast(
              msg: "تم الغاء تعيين الموظف بنجاح",
              color: Colors.green,
              context: context);
        }

        if (state is DeleteCustomerAssignedEmployeeError) {
          Constants.showToast(
              msg: "DeleteCustomerAssignedEmployeeError: " + state.msg,
              context: context);
        }

        if (state is EndUpdateCustomerAssignedEmployee) {
          Constants.showToast(
              msg: "تم تعيين الموظف بنجاح",
              color: Colors.green,
              context: context);
        }

        if (state is UpdateCustomerAssignedEmployeeError) {
          Constants.showToast(
              msg: "UpdateCustomerAssignedEmployeeError: " + state.msg,
              context: context);
        }


        if (state is EndUpdateCustomerPhone) {
          Constants.showToast(
              msg: "تم تغير رقم الموظف بنجاح",
              color: Colors.green,
              context: context);
        }

        if (state is UpdateCustomerPhoneError) {
          Constants.showToast(
              msg: "UpdateCustomerPhoneError: " + state.msg,
              context: context);
        }
      },
      builder: (context, state) {

        if (state is StartDeleteCustomer) {
          return const WaitingItemWidget();
        }

        final cubit = CustomerCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("تفاصل العميل"),
          ),
          body: SingleChildScrollView(
            controller: widget._scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewLeadName))
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("اسم العميل: " + cubit.currentCustomer.fullName),
                        const Spacer(),
                        if (Constants.currentEmployee!.permissions
                            .contains(AppStrings.editLeadName))
                          state is StartUpdateCustomerFullName
                              ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                              : IconButton(
                              onPressed: () {
                                Constants.showDialogBox(
                                    context: context,
                                    title: "عدل الاسم",
                                    content: ModifyCustomerNameWidget(
                                        customerModel:
                                        cubit.currentCustomer,
                                        customerCubit: cubit,
                                        onTapCallBack:
                                            (String updatedName) {
                                          cubit.updateCustomerFullName(
                                              UpdateCustomerNameOrDescParam(
                                                  updatedByEmployeeId:
                                                  Constants
                                                      .currentEmployee!
                                                      .employeeId,
                                                  customerId: cubit
                                                      .currentCustomer
                                                      .customerId,
                                                  updatedFullNameOrDesc:
                                                  updatedName));

                                          Navigator.pop(context);
                                        }));
                              },
                              icon: const Icon(Icons.edit))
                      ],
                    ),
                  const DefaultHeightSizedBox(),
                  if (Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewLeadPhone))
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text("ارقام العميل: " +
                              cubit.currentCustomer.phoneNumbers.toString()),
                        ),

                        if (Constants.currentEmployee!.permissions
                            .contains(AppStrings.editLeadPhone))


                          state is StartUpdateCustomerPhone
                              ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                              :
                          IconButton(
                              onPressed: () {

                                Constants.showDialogBox(
                                    context: context, title: "تعديل رقم الهاتف",
                                    content: EditCustomerPhoneNumber(
                                      phoneNumbers:  cubit.currentCustomer.phoneNumbers,
                                      onDoneCallback: (List<String> updatedPhoneNumbers) {

                                        cubit.updateCustomerPhone(UpdateCustomerPhoneNumberParam(
                                            phoneNumbers: updatedPhoneNumbers,
                                            updatedByEmployeeId: Constants.currentEmployee!.employeeId,
                                            customerId: cubit.currentCustomer.customerId
                                        ));
                                      },
                                    ));
                              },
                              icon: const Icon(Icons.edit))

                      ],
                    ),
                  const DefaultHeightSizedBox(),
                  if (Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewLeadDescription))
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2.0, color: Colors.grey)
                            ),
                            child: LinkWell(
                                "ملاحظات عن العميل: " +
                                (cubit.currentCustomer.description != null
                                    ? cubit.currentCustomer.description!
                                    : "لا يوجد"),
                            style: Theme.of(context).textTheme.bodyText1,),
                          ),
                        ),


                        if (Constants.currentEmployee!.permissions
                            .contains(AppStrings.editLeadDescription))
                          state is StartUpdateCustomerDescription
                              ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ))
                              :
                          IconButton(
                              onPressed: () {
                                Constants.showDialogBox(
                                    context: context,
                                    title: "عدل الملاحظات",
                                    content: ModifyCustomerDescWidget(
                                        customerModel:
                                        cubit.currentCustomer,
                                        customerCubit: cubit,
                                        onTapCallBack:
                                            (String updatedNameOrDesc) {
                                          cubit.updateCustomerDescription(
                                              UpdateCustomerNameOrDescParam(
                                                  updatedByEmployeeId:
                                                  Constants
                                                      .currentEmployee!
                                                      .employeeId,
                                                  customerId: cubit
                                                      .currentCustomer
                                                      .customerId,
                                                  updatedFullNameOrDesc:
                                                  updatedNameOrDesc));

                                          Navigator.pop(context);
                                        }));
                              },
                              icon: const Icon(Icons.edit))
                      ],
                    ),
                  const DefaultHeightSizedBox(),


                if (Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadSources))
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Text("المصدر: " + cubit.currentCustomer
                          .sources.toString())),

                      if (Constants.currentEmployee!.permissions
                          .contains(AppStrings.editLeadSources))
                        state is StartUpdateCustomerSources
                            ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                            :
                        IconButton(
                            onPressed: () async {
                              final pickedSources = await Navigator.pushNamed(
                                  context, Routes.sourcesRoute,
                                  arguments: SourcesArgs(
                                      sourceType: SourceType.SELECT_SOURCES
                                          .name,
                                      selectedSourcesNames: cubit
                                          .currentCustomer.sources));

                              if (pickedSources != null &&
                                  pickedSources is List<String>) {
                                cubit.updateCustomerSources(
                                    UpdateCustomerSourcesOrUnitTypesParam(
                                        updatedByEmployeeId: Constants
                                            .currentEmployee!.employeeId,
                                        customerId: cubit.currentCustomer
                                            .customerId,
                                        updatedData: pickedSources));
                              }
                            },
                            icon: const Icon(Icons.edit))
                    ],
                  ),
                if (Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadSources))
                  const DefaultHeightSizedBox(),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text("الاهتمامات: " +
                            cubit.currentCustomer.unitTypes.toString()),
                      ),


                      if (Constants.currentEmployee!.permissions
                          .contains(AppStrings.editLeadUnitTyps))
                        state is StartUpdateCustomerUnitTypes
                            ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                            :
                        IconButton(
                            onPressed: () async {
                              final pickedUnitTypes = await Navigator.pushNamed(
                                  context, Routes.unitTypesRoute,
                                  arguments: UnitTypesArgs(
                                      unitTypesType: UnitTypesType
                                          .SELECT_UNIT_TYPES.name,
                                      selectedUnitTypesNames: cubit
                                          .currentCustomer.unitTypes));

                              if (pickedUnitTypes != null &&
                                  pickedUnitTypes is List<String>) {
                                cubit.updateCustomerUnitTypes(
                                    UpdateCustomerSourcesOrUnitTypesParam(
                                        updatedByEmployeeId: Constants
                                            .currentEmployee!.employeeId,
                                        customerId: cubit.currentCustomer
                                            .customerId,
                                        updatedData: pickedUnitTypes));
                              }
                            },
                            icon: const Icon(Icons.edit))
                    ],
                  ),

                  const DefaultHeightSizedBox(),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Text("المطورين والمشاريع: " + cubit.currentCustomer
                          .developers.toString() + ", " + cubit.currentCustomer
                          .projects.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,)),

                      if (Constants.currentEmployee!.permissions
                          .contains(AppStrings.editDevelopers))
                        state is StartUpdateCustomerDevelopersAndProjects
                            ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                            :
                        IconButton(
                            onPressed: () async {
                              final response = await Navigator.pushNamed(
                                  context, Routes.developersRoute,
                                  arguments: DevelopersArgs(
                                      developerType: DevelopersType.SELECT_DEVELOPERS.name,
                                      selectedProjectsNames: cubit.currentCustomer.projects,
                                  selectedDevelopersNames: cubit.currentCustomer.developers));



                              if (response != null && response is DeveloperResults) {

                                cubit.updateCustomerDevelopersAndProjects(
                                    UpdateCustomerDevelopersAndProjectsParam(
                                        updatedByEmployeeId: Constants
                                            .currentEmployee!.employeeId,
                                        customerId: cubit.currentCustomer
                                            .customerId,
                                        updatedDevelopers: response.selectedDevelopers,
                                    updatedProjects: response.selectedProjects));

                              }

                            },
                            icon: const Icon(Icons.edit))
                    ],
                  ),

                  const DefaultHeightSizedBox(),



                  const DefaultHeightSizedBox(),
                  if (Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewLeadCreator))
                    Text("مدخل بواسطة: " +
                        (cubit.currentCustomer.createdBy != null
                            ? cubit.currentCustomer.createdBy!.fullName
                            : "لا يوجد")),
                  const DefaultHeightSizedBox(),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("معين الي: " +
                          (cubit.currentCustomer.assignedEmployee != null
                              ? cubit.currentCustomer.assignedEmployee!.fullName
                              : "لا يوجد")),
                      const Spacer(),
                      if (Constants.currentEmployee!.permissions
                          .contains(AppStrings.assignEmployees))

                        state is StartUpdateCustomerAssignedEmployee
                            ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                            :
                        IconButton(
                            onPressed: () async {
                              final pickedEmployee = await Navigator.pushNamed(
                                  context, Routes.employeePickerRoute,
                                  arguments: EmployeePickerArgs(
                                    teamMembersCubit: BlocProvider.of<
                                        TeamMembersCubit>(context),
                                    employeePickerTypes: EmployeePickerTypes
                                        .ASSIGN_MEMBER.name,
                                  ));

                              if (pickedEmployee != null &&
                                  pickedEmployee is Map<String, dynamic>) {
                                EmployeeModel employeeModel = EmployeeModel
                                    .fromJson(pickedEmployee);

                                cubit.updateCustomerAssignedEmployee(
                                    UpdateCustomerAssignedEmployeeParam(
                                        updatedByEmployeeId: Constants
                                            .currentEmployee!.employeeId,
                                        customerId: cubit.currentCustomer
                                            .customerId,
                                        assignedEmployee: employeeModel
                                            .employeeId));
                              }
                            },
                            icon: const Icon(Icons.edit)),

                      if (cubit.currentCustomer.assignedEmployee != null)
                      if (Constants.currentEmployee!.permissions
                          .contains(AppStrings.assignEmployees))
                        state is StartDeleteCustomerAssignedEmployee
                            ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ))
                            :
                        IconButton(
                            onPressed: () async {
                              final result = await Constants.showConfirmDialog(
                                  context: context,
                                  msg: "هل تريد تأكيد الغاء تعيين هذا الموظف");

                              if (result) {
                                cubit.deleteCustomerAssignedEmployee(
                                    DeleteCustomerAssignedEmployeeParam(
                                        customerId: cubit.currentCustomer
                                            .customerId,
                                        updatedByEmployeeId: Constants
                                            .currentEmployee!.employeeId

                                    ));
                              }
                            },
                            icon: const Icon(Icons.delete)),

                    ],
                  ),
                  const DefaultHeightSizedBox(),
                  Text("معين بواسطة: " +
                      (cubit.currentCustomer.assignedBy != null
                          ? cubit.currentCustomer.assignedBy!.fullName
                          : "لا يوجد")),
                  const DefaultHeightSizedBox(),
                  Text("تاريخ الادخال: " +
                      Constants.dateFromMilliSeconds(
                          cubit.currentCustomer.createDateTime)),
                  const DefaultHeightSizedBox(),


                if (Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadLog) ||
                    (Constants.currentEmployee!.employeeId == cubit.currentCustomer.assignedEmployee?.employeeId))
                  Card(
                    color: Theme.of(context).highlightColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(" اخر حدث: " +
                              (cubit.currentCustomer.lastAction != null &&
                                  cubit.currentCustomer.lastAction!.event !=
                                      null
                                  ? cubit
                                  .currentCustomer.lastAction!.event!.name
                                  : "لا يوجد")),
                          const DefaultHeightSizedBox(),
                          Text(" تاريخ اخر اكشن: " +
                              Constants.dateFromMilliSeconds(
                                  cubit.currentCustomer.lastAction?.dateTime)),
                          const DefaultHeightSizedBox(),
                          Text("تعليق: " +
                              (cubit.currentCustomer.lastAction != null &&
                                  cubit.currentCustomer.lastAction!
                                      .actionDescription !=
                                      null
                                  ? cubit.currentCustomer.lastAction!
                                  .actionDescription!
                                  : "لا يوجد")),
                          const DefaultHeightSizedBox(),
                          Text("تاريخ المتابعه: " +
                              (cubit.currentCustomer.lastAction != null &&
                                  cubit.currentCustomer.lastAction!
                                      .postponeDateTime !=
                                      null
                                  ? Constants.dateFromMilliSeconds(cubit
                                  .currentCustomer
                                  .lastAction!
                                  .postponeDateTime!)
                                  : "لا يوجد")),
                          const DefaultHeightSizedBox(),
                          Text("بواسطة: " +
                              (cubit.currentCustomer.lastAction != null &&
                                  cubit.currentCustomer.lastAction!
                                      .lastActionBy !=
                                      null
                                  ? cubit.currentCustomer.lastAction!
                                  .lastActionBy!.fullName
                                  : "لا يوجد")),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 16.0,
                    color: Colors.blueGrey,
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                  ),

                  if (Constants.currentEmployee!.permissions.contains(AppStrings.viewLeadLog) ||
                    (Constants.currentEmployee!.employeeId == cubit.currentCustomer.assignedEmployee?.employeeId))


                    BlocBuilder<CustomerLogsCubit, CustomerLogsState>(
                      builder: (context, state) {
                        final cubit = CustomerLogsCubit.get(context);
                        return _buildList(cubit, state, context);
                      },
                    ),
                    
                    // _buildCustomerLogs(),
                ],
              ),
            ),
          ),
          bottomNavigationBar: DefaultBottomNavigationWidget(
            withDelete: Constants.currentEmployee!.permissions
                .contains(AppStrings.deleteAllLeads) ||
                (Constants.currentEmployee!.permissions
                    .contains(AppStrings.deleteMyAssignedLeads) &&
                    cubit.currentCustomer.assignedEmployee?.employeeId ==
                        Constants.currentEmployee!.employeeId) ||
                (Constants.currentEmployee!.permissions
                    .contains(AppStrings.deleteNotAssignedLeads) &&
                    cubit.currentCustomer.assignedEmployee?.employeeId ==
                        null) ||
                (Constants.currentEmployee!.permissions
                    .contains(AppStrings.deleteOwnLeads) &&
                    cubit.currentCustomer.createdBy?.employeeId ==
                        Constants.currentEmployee!.employeeId),
            omDeleteCallback: (bool result) {

              if (result) {
                cubit.deleteCustomer(cubit.currentCustomer.customerId);
              }


            },


            withEdit: false,

            // withEdit: Constants.currentEmployee!.permissions
            //         .contains(AppStrings.editAllLeads) ||
            //     (Constants.currentEmployee!.permissions
            //             .contains(AppStrings.editMyAssignedLeads) &&
            //         cubit.currentCustomer.assignedEmployee?.employeeId ==
            //             Constants.currentEmployee!.employeeId) ||
            //     (Constants.currentEmployee!.permissions
            //             .contains(AppStrings.editNotAssignedLeads) &&
            //         cubit.currentCustomer.assignedEmployee?.employeeId ==
            //             null) ||
            //     (Constants.currentEmployee!.permissions
            //             .contains(AppStrings.editOwnLeads) &&
            //         cubit.currentCustomer.assignedEmployee?.createdBy ==
            //             Constants.currentEmployee!.employeeId),


            onEditTapCallback: () {
              Navigator.pushNamed(context, Routes.modifyCustomerRoute,
                  arguments: ModifyCustomerArgs(
                      customerCubit: widget.customerDetailsArgs.customerCubit,
                      fromRoute: widget.customerDetailsArgs.fromRoute,
                      customerModel: cubit.currentCustomer,
                      teamMembersCubit:
                      widget.customerDetailsArgs.teamMembersCubit));
            },
          ),
        );
      },
    );
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

        SizedBox(
          height: 500.0,
          child: Scrollbar(
            controller: widget._secondScrollController,
            child: ListView.separated(
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

                          const SizedBox(height: 5.0,),
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
        ),

      ],
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
  
  Widget _buildCustomerLogs() {
    return BlocBuilder<CustomerLogsCubit, CustomerLogsState>(
      builder: (context, state) {
        final customerLogsCubit = CustomerLogsCubit.get(context);

        // if (state is StartRefreshCustomerLogs ||
        //     state is StartLoadingCustomerLogs) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        if (state is RefreshCustomerLogsError) {
          return ErrorItemWidget(
            msg: state.msg,
            onPress: () {
              _getPageCustomerLogs(context: context, refresh: true);
            },
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                  visible: state is StartRefreshCustomerLogs || state is StartLoadingCustomerLogs,
                  child: const LinearProgressIndicator()),

              SizedBox(
                width: context.width,
                child: PaginatedDataTable(
                    columns: const [
                      DataColumn(label: Text('الوصف')),
                      DataColumn(label: Text('التاريخ')),
                    ],
                    showCheckboxColumn: false,
                    dataRowHeight: 65.0,
                    header: Text("سجلات العميل " +
                        customerLogsCubit.customerLogTotalElements.toString()),
                    rowsPerPage: 5,
                    onPageChanged: (pageIndex) {
                      customerLogsCubit.updateFilter(customerLogsCubit
                          .customerLogFiltersModel
                          .copyWith(pageNumber: Wrapped.value(pageIndex)));

                      _getPageCustomerLogs(context: context);
                    },
                    source: CustomerLogsDataTable(
                        onSelect: (val, CustomerLogModel customerLogModel) {},
                        customerLogsCubit: customerLogsCubit)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomerDetailsArgs {
  final CustomerModel customerModel;
  final CustomerCubit customerCubit;
  final TeamMembersCubit teamMembersCubit;
  final String fromRoute;

  CustomerDetailsArgs({required this.customerModel,
    required this.customerCubit,
    required this.teamMembersCubit,
    required this.fromRoute});
}






