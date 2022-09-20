import 'package:crm_flutter_project/core/utils/app_colors.dart';
import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/data/models/phoneNumber_model.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../../data/models/create_action_request_model.dart';
import '../../domain/use_cases/customer_use_cases.dart';
import '../widgets/assign_to_employee.dart';
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

  List<String> projects = [];
  List<String> unitTypes = [];
  List<String> sources = [];

  int? createdByEmployeeId = Constants.currentEmployee?.employeeId;

  CreateActionRequestModel? createActionRequest;

  EmployeeModel? assignedEmployee;

  int? assignedEmployeeId;
  int? assignedByEmployeeId;
  int? assignedDateTime;

  @override
  void initState() {
    final cubit = BlocProvider.of<CustomerCubit>(context);

    super.initState();
    if (widget.modifyCustomerArgs.customerModel != null) {
      customerId = widget.modifyCustomerArgs.customerModel!.customerId;

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

      _fullNameController.text =
          widget.modifyCustomerArgs.customerModel!.fullName;

      _descriptionController.text =
          widget.modifyCustomerArgs.customerModel!.description != null &&
                  widget
                      .modifyCustomerArgs.customerModel!.description!.isNotEmpty
              ? widget.modifyCustomerArgs.customerModel!.description!
              : "";

      cubit.updateCustomerPhoneNumber(PhoneNumberModel(
        phone: widget.modifyCustomerArgs.customerModel!.phoneNumber.phone
            .substring(1),
        isoCode: widget.modifyCustomerArgs.customerModel!.phoneNumber.isoCode,
        countryCode:
            widget.modifyCustomerArgs.customerModel!.phoneNumber.countryCode,
      ));

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
    } else {
      cubit.updateCustomerPhoneNumber(
          const PhoneNumberModel(phone: "", isoCode: "EG", countryCode: '+20'));
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
                        controller: _descriptionController,
                        hint: "ملاحظة عن العميل",
                        validator: (v) {
                          if (v == null && v!.isNotEmpty) {
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
                    ),
                    const DefaultHeightSizedBox(),
                    Card(
                      child: ListTile(
                        onTap: () {},
                        title: const Text("اختر المطورين والمشاريع"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                    const DefaultHeightSizedBox(),
                    PickSources(
                      onPickedSourcesCallback: (List<String> newSources) {
                        sources = newSources;
                      },
                      sources: sources,
                    ),
                    const DefaultHeightSizedBox(),
                    AssignToEmployee(
                      currentEmployee: assignedEmployee,
                      onAssignedCallback: (EmployeeModel? newAssignedEmployee) {
                        assignedEmployeeId = newAssignedEmployee?.employeeId;
                        assignedEmployee = newAssignedEmployee;
                      },
                      teamMembersCubit:
                          widget.modifyCustomerArgs.teamMembersCubit,
                    ),
                    const DefaultHeightSizedBox(),
                    Text(
                      "ملحوطة عند ادخل الرقم تجاهل اول رقم مثلا 010XXXXXXXXX اكتبها من غير الصفر الاول",
                      style: TextStyle(color: AppColors.hint, fontSize: 16.0),
                    ),
                    const DefaultHeightSizedBox(),
                    IntlPhoneField(
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                      validator: (v) {
                        if (v != null) {
                          return AppStrings.required;
                        }

                        return null;
                      },
                      invalidNumberMessage: "هذا الرقم غير صحيح",
                      initialValue: cubit.phoneNumber?.phone,
                      initialCountryCode: cubit.phoneNumber?.isoCode,
                      onChanged: (phone) {
                        cubit.updateCustomerPhoneNumber(PhoneNumberModel(
                            phone: phone.number,
                            isoCode: phone.countryISOCode,
                            countryCode: phone.countryCode));
                      },
                    ),
                    const DefaultHeightSizedBox(),
                    const DefaultHeightSizedBox(),
                    const DefaultHeightSizedBox(),
                    DefaultButtonWidget(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (cubit.phoneNumber == null) {
                              Constants.showToast(
                                  msg: "رقم الهاتف مطلوب!", context: context);
                              return;
                            }
                            cubit.modifyCustomer(ModifyCustomerParam(
                                customerId: customerId,
                                fullName: _fullNameController.text,
                                phoneNumber: cubit.phoneNumber!,
                                createDateTime: createDateTime,
                                description: _descriptionController.text,
                                projects: projects,
                                unitTypes: unitTypes,
                                sources: sources,
                                createdByEmployeeId: createdByEmployeeId,
                                createActionRequest: createActionRequest,
                                assignedEmployeeId: assignedEmployeeId,
                                assignedByEmployeeId: assignedByEmployeeId,
                                assignedDateTime: assignedDateTime,
                                logByEmployeeId:
                                    Constants.currentEmployee?.employeeId));
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
