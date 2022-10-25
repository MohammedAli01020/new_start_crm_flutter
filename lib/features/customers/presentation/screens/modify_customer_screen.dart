
import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import '../../../employees/data/models/employee_response_model.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../../data/models/create_action_request_model.dart';
import '../../domain/use_cases/customer_use_cases.dart';
import '../widgets/assign_to_employee.dart';
import '../widgets/pick_developers_and_prjects_types.dart';
import '../widgets/pick_sources.dart';
import '../widgets/pick_unit_types.dart';

class ModifyCustomerScreen extends StatefulWidget {
  final ModifyCustomerArgs modifyCustomerArgs;

  const ModifyCustomerScreen({Key? key, required this.modifyCustomerArgs})
      : super(key: key);

  @override
  State<ModifyCustomerScreen> createState() => _ModifyCustomerScreenState();
}

class _ModifyCustomerScreenState extends State<ModifyCustomerScreen> {
  final formKey = GlobalKey<FormState>();

  int? customerId;

  final _fullNameController = TextEditingController();

  int createDateTime = DateTime.now().millisecondsSinceEpoch;

  final _descriptionController = TextEditingController();

  final _firstPhoneController = TextEditingController();
  final _secondPhoneController = TextEditingController();

  List<String> projects = [];
  List<String> unitTypes = [];
  List<String> sources = [];

  List<String> developers = [];

  late List<String> phoneNumbers;

  int? createdByEmployeeId = Constants.currentEmployee?.employeeId;

  CreateActionRequestModel? createActionRequest;

  EmployeeResponseModel? assignedEmployee;

  int? assignedEmployeeId;
  int? assignedByEmployeeId;
  int? assignedDateTime;

  bool? viewPreviousLog;

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _descriptionController.dispose();
    _firstPhoneController.dispose();
    _secondPhoneController.dispose();
  }

  @override
  void initState() {

    super.initState();
    if (widget.modifyCustomerArgs.customerModel != null) {
      customerId = widget.modifyCustomerArgs.customerModel!.customerId;



      viewPreviousLog = widget.modifyCustomerArgs.customerModel!.viewPreviousLog;

      assignedDateTime =
          widget.modifyCustomerArgs.customerModel!.assignedDateTime;
      assignedByEmployeeId =
          widget.modifyCustomerArgs.customerModel!.assignedBy?.employeeId;

      assignedEmployeeId =
          widget.modifyCustomerArgs.customerModel!.assignedEmployee?.employeeId;

      assignedEmployee =
          widget.modifyCustomerArgs.customerModel!.assignedEmployee;

      createDateTime = widget.modifyCustomerArgs.customerModel!.createDateTime;

      sources = widget.modifyCustomerArgs.customerModel!.sources;
      projects = widget.modifyCustomerArgs.customerModel!.projects;
      unitTypes = widget.modifyCustomerArgs.customerModel!.unitTypes;
      developers =  widget.modifyCustomerArgs.customerModel!.developers;
      _fullNameController.text =
          widget.modifyCustomerArgs.customerModel!.fullName;

      _descriptionController.text =
          widget.modifyCustomerArgs.customerModel!.description != null &&
                  widget
                      .modifyCustomerArgs.customerModel!.description!.isNotEmpty
              ? widget.modifyCustomerArgs.customerModel!.description!
              : "";

      phoneNumbers = widget.modifyCustomerArgs.customerModel!.phoneNumbers;

      if (phoneNumbers.length == 1) {
        _firstPhoneController.text = phoneNumbers.first;
      } else if (phoneNumbers.length == 2) {
        _firstPhoneController.text = phoneNumbers.first;
        _secondPhoneController.text = phoneNumbers.elementAt(1);
      }

      createActionRequest = CreateActionRequestModel(
        dateTime: widget.modifyCustomerArgs.customerModel!.lastAction?.dateTime,
        postponeDateTime: widget
            .modifyCustomerArgs.customerModel!.lastAction?.postponeDateTime,
        eventId:
            widget.modifyCustomerArgs.customerModel!.lastAction?.event?.eventId,
        lastActionByEmployeeId: widget.modifyCustomerArgs.customerModel!
            .lastAction?.lastActionBy?.employeeId,
        actionDescription: widget
            .modifyCustomerArgs.customerModel!.lastAction?.actionDescription,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerCubit, CustomerState>(
      listener: (context, state) {
        if (state is ModifyCustomerError) {
          Constants.showToast(
              msg: "ModifyCustomerError: " + state.msg, context: context);
        }

        if (state is EndModifyCustomer) {
          // edit
          if (widget.modifyCustomerArgs.customerModel != null) {
            Constants.showToast(
                msg: "تم تعديل العميل بنجاح",
                color: Colors.green,
                context: context);
          } else {
            Constants.showToast(
                msg: "تم أضافة العميل بنجاح",
                color: Colors.green,
                context: context);
          }

          Navigator.popUntil(context,
              ModalRoute.withName(widget.modifyCustomerArgs.fromRoute));
        }
      },
      builder: (context, state) {
        final cubit = CustomerCubit.get(context);

        if (state is StartModifyCustomer) {
          return const WaitingItemWidget();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.modifyCustomerArgs.customerModel != null
                ? "عدل العميل"
                : "أضف العميل"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomEditText(
                        controller: _fullNameController,
                        hint: "الاسم بالكامل",
                        maxLength: 50,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }

                          if (v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }

                          if (v.length < 2) {
                            return "اقل عدد احرف 2";
                          }

                          return null;
                        },
                        inputType: TextInputType.text),
                    const DefaultHeightSizedBox(),


                    CustomEditText(
                        controller: _firstPhoneController,
                        hint: "رقم الهاتف الأول",
                        maxLength: 50,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }

                          if (v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }

                          if (v.length < 11) {
                            return "اقل عدد احرف 11";
                          }

                          return null;
                        },
                        inputType: TextInputType.phone),
                    const DefaultHeightSizedBox(),
                    CustomEditText(
                        controller: _secondPhoneController,
                        hint: "رقم الهاتف الثاني",
                        maxLength: 50,
                        validator: (v) {

                          if (v != null && v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }


                          if (v != null && v.isNotEmpty && v.length < 11) {
                            return "اقل عدد احرف 11";
                          }

                          return null;
                        },
                        inputType: TextInputType.phone),
                    const DefaultHeightSizedBox(),

                    CustomEditText(
                        controller: _descriptionController,
                        hint: "ملاحظة عن العميل",
                        validator: (v) {

                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }

                          if ( v.isNotEmpty) {
                            if (v.length > 5000) {
                              return "اقصي عدد احرف 5000";
                            }
                          }

                          return null;
                        },
                        inputType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 14,
                        maxLength: 5000),
                    const DefaultHeightSizedBox(),
                    PickUnitTypes(
                      onPickedUnitTypesCallback: (List<String> newUnitTypes) {
                        unitTypes = newUnitTypes;
                      },
                      unitTypes: unitTypes,
                      onRemoveCallback: () {
                        unitTypes = [];
                      },
                    ),
                    const DefaultHeightSizedBox(),

                    PickDevelopersAndProjects(
                      projects: projects,
                      developers: developers,
                      onRemoveCallback: () {
                        projects = [];
                        developers = [];
                      },
                      onPickedDevelopersAndProjectsCallback: (List<String> selectedDevelopers, List<String> selectedProjects) {
                        projects = selectedProjects;
                        developers  = selectedDevelopers;
                      },


                    ),

                    const DefaultHeightSizedBox(),
                    PickSources(
                      onPickedSourcesCallback: (List<String> newSources) {
                        sources = newSources;
                      },
                      sources: sources,
                      onRemoveCallback: () {
                        sources = [];
                      },
                    ),
                    const DefaultHeightSizedBox(),
                    AssignToEmployee(
                      currentEmployee: assignedEmployee,
                      onAssignedCallback: (EmployeeResponseModel? newAssignedEmployee, bool? viewLog) {
                        assignedEmployeeId = newAssignedEmployee?.employeeId;
                        assignedEmployee = newAssignedEmployee;
                        assignedByEmployeeId =
                            Constants.currentEmployee?.employeeId;
                        assignedDateTime =
                            DateTime.now().millisecondsSinceEpoch;
                        viewPreviousLog = viewLog;

                      },
                      teamMembersCubit:
                          widget.modifyCustomerArgs.teamMembersCubit,
                      onRemoveCallback: () {
                        assignedEmployeeId = null;
                        assignedEmployee = null;
                        assignedByEmployeeId = null;
                        assignedDateTime = null;
                        viewPreviousLog = null;

                      }, viewPreviousLog: viewPreviousLog,
                    ),
                    const DefaultHeightSizedBox(),



                    const DefaultHeightSizedBox(),
                    const DefaultHeightSizedBox(),
                    DefaultButtonWidget(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {

                            if (_firstPhoneController.text.trim() == _secondPhoneController.text.trim() ) {
                              Constants.showToast(msg: "الرقمين متشابهين", context: context);
                              return;
                            }


                            if (_firstPhoneController.text.isNotEmpty && _secondPhoneController.text.isNotEmpty) {
                              phoneNumbers = [
                                _firstPhoneController.text.trim(),
                                _secondPhoneController.text.trim()
                              ];
                            } else {
                              phoneNumbers = [
                                _firstPhoneController.text.trim()
                              ];
                            }

                            if (unitTypes.isEmpty) {
                              Constants.showToast(msg: "يجب تحديد اهتمامات العميل", context: context);
                              return;
                            }

                            if (sources.isEmpty) {
                              Constants.showToast(msg: "يجب تحديد مصدر العميل", context: context);
                              return;
                            }

                            if (developers.isEmpty || projects.isEmpty ) {
                              Constants.showToast(msg: "يجب تحديد المطورين والمشاريع", context: context);
                              return;
                            }



                            cubit.modifyCustomer(ModifyCustomerParam(
                                customerId: customerId,
                                fullName: _fullNameController.text,
                                phoneNumbers: phoneNumbers,
                                createDateTime: createDateTime,
                                description: _descriptionController.text,
                                developers: developers,
                                projects: projects,
                                unitTypes: unitTypes,
                                sources: sources,
                                createdByEmployeeId: createdByEmployeeId,
                                createActionRequest: createActionRequest,
                                assignedEmployeeId: assignedEmployeeId,
                                assignedByEmployeeId: assignedByEmployeeId,
                                assignedDateTime: assignedDateTime,
                                logByEmployeeId:
                                    Constants.currentEmployee?.employeeId,
                                viewPreviousLog: assignedEmployeeId != null ? viewPreviousLog : true));
                          }
                        },
                        text: widget.modifyCustomerArgs.customerModel != null
                            ? "عدل العميل"
                            : "أضف العميل")
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModifyCustomerArgs {
  final CustomerModel? customerModel;
  final CustomerCubit customerCubit;
  final TeamMembersCubit teamMembersCubit;
  final String fromRoute;

  ModifyCustomerArgs(
      {this.customerModel,
      required this.customerCubit,
      required this.teamMembersCubit,
      required this.fromRoute});
}
