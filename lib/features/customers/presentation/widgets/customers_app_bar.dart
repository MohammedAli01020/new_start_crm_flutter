import 'package:crm_flutter_project/core/utils/app_colors.dart';
import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/responsive.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/filter_field.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/sources_picker.dart';
import 'package:crm_flutter_project/features/customers/presentation/widgets/unit_types_picker.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/presentation/screens/employee_picker_screen.dart';
import '../../data/models/customer_filters_model.dart';
import '../../data/models/event_model.dart';
import '../../domain/use_cases/customer_use_cases.dart';
import '../screens/modify_customer_screen.dart';
import 'CustomerTypePicker.dart';
import 'DateFilterPicker.dart';
import 'ReminderTypePicker.dart';
import 'bulk_actions_widget.dart';
import 'developers_picker.dart';
import 'event_picker.dart';
import 'export_button_widget.dart';
import 'projects_picker.dart';

class CustomersAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final CustomerCubit customerCubit;
  final CustomerState customerState;
  final TeamMembersCubit teamMembersCubit;
  final VoidCallback onFilterChangeCallback;
  final VoidCallback onTapDrawer;

  const CustomersAppBar({
    Key? key,
    required this.onSearchChangeCallback,
    required this.onCancelTapCallback,
    required this.customerCubit,
    required this.customerState,
    required this.teamMembersCubit,
    required this.onFilterChangeCallback,
    required this.onTapDrawer,
  }) : super(key: key);

  @override
  State<CustomersAppBar> createState() => _CustomersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _CustomersAppBarState extends State<CustomersAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: widget.customerCubit.selectedCustomers.isNotEmpty
          ? IconButton(
              onPressed: () {
                widget.customerCubit.setSelectedCustomers([]);
              },
              icon: const Icon(Icons.arrow_back))
          : IconButton(
              onPressed: () {
                widget.onTapDrawer();
              },
              icon: const Icon(Icons.menu)),
      title: isSearch
          ? TextField(
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                hintText: "اسم العميل او رقمة",
              ),
              onChanged: (search) {
                widget.onSearchChangeCallback(search);
              },
            )
          : Text(
              widget.customerCubit.selectedCustomers.isNotEmpty
                  ? widget.customerCubit.selectedCustomers.length.toString()
                  : "العملاء",
              style: const TextStyle(),
            ),
      actions: [
        if (Responsive.isMobileDevice &&
            widget.customerCubit.selectedCustomers.isNotEmpty)
          Checkbox(
              value: widget.customerCubit.selectedCustomers.length ==
                  widget.customerCubit.customerTotalElements,
              onChanged: (val) async {
                if (val != null && val == false) {
                  widget.customerCubit.setSelectedCustomers([]);
                } else {
                  if (widget.customerState is StartUpdateSelectedCustomers) {
                    Constants.showToast(
                        msg: "انتظر جاري التحميل ...", context: context);
                    return;
                  }
                  await widget.customerCubit.fetchAllCustomers();
                }
              }),
        if (Constants.currentEmployee!.permissions
            .contains(AppStrings.bulkActions))
          if (widget.customerCubit.selectedCustomers.isNotEmpty)
            widget.customerState is StartDeleteAllCustomersByIds
                ? const Center(
                    child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator()))
                : IconButton(
                    onPressed: () async {
                      final response = await Constants.showConfirmDialog(
                          context: context, msg: "هل تريد تأكيد الحذف؟");

                      if (response) {
                        List<int> customerIds = widget
                            .customerCubit.selectedCustomers
                            .map((e) => e.customerId)
                            .toList();
                        widget.customerCubit.deleteAllCustomersByIds(
                            customerIds, Constants.currentEmployee!.employeeId);
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                    )),
        if (widget.customerCubit.selectedCustomers.isNotEmpty &&
            (Constants.currentEmployee!.permissions
                    .contains(AppStrings.assignEmployees) ||
                (Constants.currentEmployee!.permissions
                        .contains(AppStrings.assignMyTeamMembers) &&
                    Constants.currentEmployee?.teamId != null) ||
                Constants.currentEmployee!.permissions
                    .contains(AppStrings.bulkActions)))
          widget.customerState is StartUpdateBulkCustomers
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
                            onConfirmAction:
                                (UpdateCustomerParam updateCustomerParam) {
                              widget.customerCubit
                                  .updateBulkCustomers(updateCustomerParam);
                              Navigator.of(context).pop(true);
                            },
                            selectedCustomersIds: widget
                                .customerCubit.selectedCustomers
                                .map((e) => e.customerId)
                                .toList(),
                            teamMembersCubit: widget.teamMembersCubit));
                  },
                  icon: const Icon(Icons.assignment_turned_in)),
        if (Constants.currentEmployee!.permissions
            .contains(AppStrings.exportLeads))
          if (widget.customerCubit.selectedCustomers.isNotEmpty)
            ExportButtonWidget(
              selectedCustomers: widget.customerCubit.selectedCustomers,
            ),
        if (widget.customerCubit.selectedCustomers.isEmpty)
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = !isSearch;
                });

                widget.onCancelTapCallback(isSearch);
              },
              icon: Icon(isSearch ? Icons.cancel : Icons.search)),
        if (widget.customerCubit.selectedCustomers.isEmpty &&
            Constants.currentEmployee!.permissions
                .contains(AppStrings.creatLead))
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.modifyCustomerRoute,
                  arguments: ModifyCustomerArgs(
                      customerCubit: widget.customerCubit,
                      fromRoute: Routes.customersRoute,
                      teamMembersCubit: widget.teamMembersCubit));
            },
            icon: const Icon(Icons.person_add),
          ),
        if (widget.customerCubit.selectedCustomers.isEmpty)
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.grid_view_sharp)),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: SizedBox(
          height: 45,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                  onTap: () {
                    widget.customerCubit
                        .updateFilter(CustomerFiltersModel.initial());

                    widget.customerCubit.updateSelectedEvents([]);
                    widget.customerCubit.updateSelectedSources([]);
                    widget.customerCubit.updateSelectedUnitTypes([]);

                    widget.customerCubit.updateSelectedDevelopers([]);
                    widget.customerCubit.updateSelectedProjects([]);

                    widget.customerCubit.setSelectedCustomers([]);

                    widget.customerCubit.updateSelectedAssignEmployeeIds([]);
                    widget.customerCubit.updateSelectedCreatedByEmployeeIds([]);

                    widget.onFilterChangeCallback();

                    Constants.refreshCustomers(widget.customerCubit);
                  },
                  child: FilterField(
                    backgroundColor: Theme.of(context).highlightColor,
                    text: const Text("حذف الفلاتر"),
                  )),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                      context: context,
                      title: "حدد العملاء",
                      content: CustomerTypePicker(
                        customerTypes: widget
                            .customerCubit.customerFiltersModel.customerTypes,
                        onSelectTypeCallback: (String? customerTypes) {
                          widget.customerCubit.updateFilter(widget
                              .customerCubit.customerFiltersModel
                              .copyWith(
                            customerTypes: Wrapped.value(customerTypes),
                            teamId: Wrapped.value(
                                Constants.currentEmployee?.teamId),
                            employeeId: Wrapped.value(
                                Constants.currentEmployee?.employeeId),
                          ));

                          widget.customerCubit.setSelectedCustomers([]);

                          widget.onFilterChangeCallback();
                          widget.customerCubit.fetchCustomers(refresh: true);
                        },
                      ),
                    );
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(_getCustomerType(widget
                            .customerCubit.customerFiltersModel.customerTypes)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.customerCubit.customerFiltersModel
                                          .customerTypes !=
                                      null &&
                                  widget.customerCubit.customerFiltersModel
                                          .customerTypes !=
                                      CustomerTypes.ALL.name
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب التذكير",
                        content: ReminderTypePicker(
                          reminderTypes: widget
                              .customerCubit.customerFiltersModel.reminderTypes,
                          onSelectTypeCallback: (String? reminderTypes) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                              reminderTypes: Wrapped.value(reminderTypes),
                            ));

                            widget.customerCubit.setSelectedCustomers([]);

                            widget.onFilterChangeCallback();
                            widget.customerCubit.fetchCustomers(refresh: true);
                            // Constants.refreshCustomers(widget.customerCubit);
                          },
                        ));
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(_getReminderType(widget
                            .customerCubit.customerFiltersModel.reminderTypes)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.customerCubit.customerFiltersModel
                                          .reminderTypes !=
                                      null &&
                                  widget.customerCubit.customerFiltersModel
                                          .reminderTypes !=
                                      ReminderTypes.ALL.name
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                      context: context,
                      title: "حدد الحدث",
                      content: EventsPicker(
                        selectedEvents:
                            widget.customerCubit.selectedEvents ?? [],
                        onConfirmCallback: (List<EventModel> selected) {
                          widget.customerCubit.updateFilter(widget
                              .customerCubit.customerFiltersModel
                              .copyWith(
                                  lastEventIds: Wrapped.value(selected.isEmpty
                                      ? null
                                      : selected
                                          .map((e) => e.eventId)
                                          .toList())));

                          widget.customerCubit.updateSelectedEvents(
                              selected.isEmpty ? null : selected);

                          widget.customerCubit.setSelectedCustomers([]);

                          widget.onFilterChangeCallback();
                          widget.customerCubit.fetchCustomers(refresh: true);
                          // Constants.refreshCustomers(widget.customerCubit);

                          Navigator.of(context).pop(false);
                        },
                      ),
                    );
                  },
                  child: FilterField(
                      text: Row(
                    children: [
                      Text(
                        widget.customerCubit.selectedEvents != null &&
                                widget.customerCubit.selectedEvents!.isNotEmpty
                            ? (widget.customerCubit.selectedEvents!.length > 1
                                ? widget.customerCubit.selectedEvents!
                                        .map((e) => e.name)
                                        .toList()
                                        .sublist(0, 1)
                                        .toString() +
                                    ", ${widget.customerCubit.selectedEvents!.length - 1} other"
                                : widget.customerCubit.selectedEvents!
                                    .map((e) => e.name)
                                    .toList()
                                    .toString())
                            : "كل الاحداث",
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: widget.customerCubit.selectedEvents != null &&
                                  widget
                                      .customerCubit.selectedEvents!.isNotEmpty
                              ? AppColors.primary
                              : Colors.grey),
                    ],
                  ))),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب التاريخ",
                        content: DateFilterPicker(
                          startDateTime: widget
                              .customerCubit.customerFiltersModel.startDateTime,
                          endDateTime: widget
                              .customerCubit.customerFiltersModel.endDateTime,
                          onSelectTypeCallback: (int? start, int? end) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                              startDateTime: Wrapped.value(start),
                              endDateTime: Wrapped.value(end),
                            ));

                            widget.customerCubit.setSelectedCustomers([]);

                            widget.onFilterChangeCallback();
                            widget.customerCubit.fetchCustomers(refresh: true);
                            // Constants.refreshCustomers(widget.customerCubit);
                          },
                        ));
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(Constants.getDateType(
                          widget
                              .customerCubit.customerFiltersModel.startDateTime,
                          widget.customerCubit.customerFiltersModel.endDateTime,
                        )),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.customerCubit.customerFiltersModel
                                          .startDateTime !=
                                      null &&
                                  widget.customerCubit.customerFiltersModel
                                          .endDateTime !=
                                      null
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر انواع الوحدات",
                        content: UnitTypesPicker(
                          selectedUnitTypes: widget.customerCubit
                                  .customerFiltersModel.unitTypes ??
                              [],
                          onConfirmCallback: (List<String> selectedUnitTypes) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                                    unitTypes: Wrapped.value(
                                        selectedUnitTypes.isEmpty
                                            ? null
                                            : selectedUnitTypes)));

                            widget.customerCubit.updateSelectedUnitTypes(
                                selectedUnitTypes.isEmpty
                                    ? null
                                    : selectedUnitTypes);
                            widget.customerCubit.setSelectedCustomers([]);

                            widget.onFilterChangeCallback();
                            widget.customerCubit.fetchCustomers(refresh: true);
                            // Constants.refreshCustomers(widget.customerCubit);
                            Navigator.of(context).pop(false);
                          },
                        ));
                  },
                  child: FilterField(
                      text: Row(
                    children: [
                      Text(
                        widget.customerCubit.selectedUnitTypes != null &&
                                widget
                                    .customerCubit.selectedUnitTypes!.isNotEmpty
                            ? (widget.customerCubit.selectedUnitTypes!.length >
                                    1
                                ? widget.customerCubit.selectedUnitTypes!
                                        .sublist(0, 1)
                                        .toString() +
                                    ", ${widget.customerCubit.selectedUnitTypes!.length - 1} other"
                                : widget.customerCubit.selectedUnitTypes!
                                    .toString())
                            : "كل الوحدات",
                      ),
                      Icon(Icons.arrow_drop_down,
                          color:
                              widget.customerCubit.selectedUnitTypes != null &&
                                      widget.customerCubit.selectedUnitTypes!
                                          .isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                    ],
                  ))),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب المصادر",
                        content: SourcesPicker(
                          selectedSources: widget
                                  .customerCubit.customerFiltersModel.sources ??
                              [],
                          onConfirmCallback: (List<String> selectedSources) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                                    sources: Wrapped.value(
                                        selectedSources.isEmpty
                                            ? null
                                            : selectedSources)));

                            widget.customerCubit.updateSelectedSources(
                                selectedSources.isEmpty
                                    ? null
                                    : selectedSources);

                            widget.customerCubit.setSelectedCustomers([]);

                            widget.onFilterChangeCallback();
                            widget.customerCubit.fetchCustomers(refresh: true);
                            // Constants.refreshCustomers(widget.customerCubit);

                            Navigator.of(context).pop(false);
                          },
                        ));
                  },
                  child: FilterField(
                      text: Row(
                    children: [
                      Text(
                        widget.customerCubit.selectedSources != null &&
                                widget.customerCubit.selectedSources!.isNotEmpty
                            ? (widget.customerCubit.selectedSources!.length > 1
                                ? widget.customerCubit.selectedSources!
                                        .sublist(0, 1)
                                        .toString() +
                                    ", ${widget.customerCubit.selectedSources!.length - 1} other"
                                : widget.customerCubit.selectedSources!
                                    .toString())
                            : "كل المصادر",
                      ),
                      Icon(Icons.arrow_drop_down,
                          color: widget.customerCubit.selectedSources != null &&
                                  widget
                                      .customerCubit.selectedSources!.isNotEmpty
                              ? AppColors.primary
                              : Colors.grey),
                    ],
                  ))),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب المطورين",
                        content: DevelopersPicker(
                          selectedDevelopers: widget.customerCubit
                                  .customerFiltersModel.developers ??
                              [],
                          onConfirmCallback: (List<String> selectedDevelopers) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                                    developers: Wrapped.value(
                                        selectedDevelopers.isEmpty
                                            ? null
                                            : selectedDevelopers)));

                            widget.customerCubit.updateSelectedDevelopers(
                                selectedDevelopers.isEmpty
                                    ? null
                                    : selectedDevelopers);

                            widget.customerCubit.setSelectedCustomers([]);

                            widget.onFilterChangeCallback();
                            widget.customerCubit.fetchCustomers(refresh: true);
                            // Constants.refreshCustomers(widget.customerCubit);

                            Navigator.of(context).pop(false);
                          },
                        ));
                  },
                  child: FilterField(
                      text: Row(
                    children: [
                      Text(
                        widget.customerCubit.selectedDevelopers != null &&
                                widget.customerCubit.selectedDevelopers!
                                    .isNotEmpty
                            ? (widget.customerCubit.selectedDevelopers!.length >
                                    1
                                ? widget.customerCubit.selectedDevelopers!
                                        .sublist(0, 1)
                                        .toString() +
                                    ", ${widget.customerCubit.selectedDevelopers!.length - 1} other"
                                : widget.customerCubit.selectedDevelopers!
                                    .toString())
                            : "كل المطورين",
                      ),
                      Icon(Icons.arrow_drop_down,
                          color:
                              widget.customerCubit.selectedDevelopers != null &&
                                      widget.customerCubit.selectedDevelopers!
                                          .isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                    ],
                  ))),
              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب المشاريع",
                        content: ProjectsPicker(
                          selectedProjects: widget.customerCubit
                                  .customerFiltersModel.projects ??
                              [],
                          onConfirmCallback: (List<String> selectedProjects) {
                            widget.customerCubit.updateFilter(widget
                                .customerCubit.customerFiltersModel
                                .copyWith(
                                    projects: Wrapped.value(
                                        selectedProjects.isEmpty
                                            ? null
                                            : selectedProjects)));

                            widget.customerCubit.updateSelectedProjects(
                                selectedProjects.isEmpty
                                    ? null
                                    : selectedProjects);

                            widget.customerCubit.setSelectedCustomers([]);

                            widget.onFilterChangeCallback();
                            widget.customerCubit.fetchCustomers(refresh: true);
                            // Constants.refreshCustomers(widget.customerCubit);

                            Navigator.of(context).pop(false);
                          },
                        ));
                  },
                  child: FilterField(
                      text: Row(
                    children: [
                      Text(
                        widget.customerCubit.selectedProjects != null &&
                                widget
                                    .customerCubit.selectedProjects!.isNotEmpty
                            ? (widget.customerCubit.selectedProjects!.length > 1
                                ? widget.customerCubit.selectedProjects!
                                        .sublist(0, 1)
                                        .toString() +
                                    ", ${widget.customerCubit.selectedProjects!.length - 1} other"
                                : widget.customerCubit.selectedProjects!
                                    .toString())
                            : "كل المشاريع",
                      ),
                      Icon(Icons.arrow_drop_down,
                          color:
                              widget.customerCubit.selectedProjects != null &&
                                      widget.customerCubit.selectedProjects!
                                          .isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                    ],
                  ))),
              if (Constants.currentEmployee?.teamId != null ||
                  Constants.currentEmployee!.permissions
                      .contains(AppStrings.viewAllLeads))
                GestureDetector(
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                          context, Routes.employeePickerRoute,
                          arguments: EmployeePickerArgs(
                              employeePickerTypes: Constants
                                      .currentEmployee!.permissions
                                      .contains(AppStrings.viewAllLeads)
                                  ? EmployeePickerTypes
                                      .SELECT_MULTIPLE_EMPLOYEE.name
                                  : EmployeePickerTypes
                                      .SELECT_MULTIPLE_FROM_TEAM_MEMBERS.name,
                              teamMembersCubit: widget.teamMembersCubit));

                      if (result != null && result is List<EmployeeModel>) {
                        widget.customerCubit.updateFilter(
                            widget.customerCubit.customerFiltersModel.copyWith(
                                assignedEmployeeIds: Wrapped.value(
                                    result.isEmpty
                                        ? null
                                        : result
                                            .map((e) => e.employeeId)
                                            .toList())));

                        widget.customerCubit
                            .updateSelectedAssignEmployeeIds(result);
                        widget.customerCubit.setSelectedCustomers([]);

                        widget.onFilterChangeCallback();
                        widget.customerCubit.fetchCustomers(refresh: true);
                      }
                    },
                    child: FilterField(
                        text: Row(
                      children: [
                        Text(
                          widget.customerCubit.assignEmployees != null &&
                                  widget
                                      .customerCubit.assignEmployees!.isNotEmpty
                              ? (widget.customerCubit.assignEmployees!.length >
                                      1
                                  ? "معين الي " +
                                      widget.customerCubit.assignEmployees!
                                          .map((e) => e.fullName)
                                          .toList()
                                          .sublist(0, 1)
                                          .toString() +
                                      ", ${widget.customerCubit.assignEmployees!.length - 1} other"
                                  : widget.customerCubit.assignEmployees!
                                      .map((e) => e.fullName)
                                      .toString())
                              : "علي حسب ميعن إلي",
                        ),
                        Icon(Icons.arrow_drop_down,
                            color:
                                widget.customerCubit.assignEmployees != null &&
                                        widget.customerCubit.assignEmployees!
                                            .isNotEmpty
                                    ? AppColors.primary
                                    : Colors.grey),
                        if (widget.customerCubit.assignEmployees != null &&
                            widget.customerCubit.assignEmployees!.isNotEmpty)
                          InkWell(
                              onTap: () {
                                widget.customerCubit.updateFilter(widget
                                    .customerCubit.customerFiltersModel
                                    .copyWith(
                                        assignedEmployeeIds:
                                            const Wrapped.value(null)));

                                widget.customerCubit
                                    .updateSelectedAssignEmployeeIds([]);
                                widget.customerCubit.setSelectedCustomers([]);

                                widget.onFilterChangeCallback();
                                widget.customerCubit
                                    .fetchCustomers(refresh: true);
                              },
                              child: const Text("مسح"))
                      ],
                    ))),
              GestureDetector(
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                        context, Routes.employeePickerRoute,
                        arguments: EmployeePickerArgs(
                            employeePickerTypes: EmployeePickerTypes
                                .SELECT_MULTIPLE_EMPLOYEE.name,
                            teamMembersCubit: widget.teamMembersCubit));

                    if (result != null && result is List<EmployeeModel>) {
                      widget.customerCubit.updateFilter(
                          widget.customerCubit.customerFiltersModel.copyWith(
                              createdByIds: Wrapped.value(result.isEmpty
                                  ? null
                                  : result.map((e) => e.employeeId).toList())));

                      widget.customerCubit
                          .updateSelectedCreatedByEmployeeIds(result);
                      widget.customerCubit.setSelectedCustomers([]);

                      widget.onFilterChangeCallback();
                      widget.customerCubit.fetchCustomers(refresh: true);
                    }
                  },
                  child: FilterField(
                      text: Row(
                    children: [
                      Text(
                        widget.customerCubit.createdByEmployees != null &&
                                widget.customerCubit.createdByEmployees!
                                    .isNotEmpty
                            ? (widget.customerCubit.createdByEmployees!.length >
                                    1
                                ? "مدخل بواسطة " +
                                    widget.customerCubit.createdByEmployees!
                                        .map((e) => e.fullName)
                                        .toList()
                                        .sublist(0, 1)
                                        .toString() +
                                    ", ${widget.customerCubit.createdByEmployees!.length - 1} other"
                                : widget.customerCubit.createdByEmployees!
                                    .map((e) => e.fullName)
                                    .toString())
                            : "علي حسب مدخل بواسطة",
                      ),
                      Icon(Icons.arrow_drop_down,
                          color:
                              widget.customerCubit.createdByEmployees != null &&
                                      widget.customerCubit.createdByEmployees!
                                          .isNotEmpty
                                  ? AppColors.primary
                                  : Colors.grey),
                      if (widget.customerCubit.createdByEmployees != null &&
                          widget.customerCubit.createdByEmployees!.isNotEmpty)
                        InkWell(
                            onTap: () {
                              widget.customerCubit.updateFilter(widget
                                  .customerCubit.customerFiltersModel
                                  .copyWith(
                                      createdByIds: const Wrapped.value(null)));

                              widget.customerCubit
                                  .updateSelectedCreatedByEmployeeIds([]);
                              widget.customerCubit.setSelectedCustomers([]);

                              widget.onFilterChangeCallback();
                              widget.customerCubit
                                  .fetchCustomers(refresh: true);
                            },
                            child: const Text("مسح"))
                    ],
                  ))),
            ],
          ),
        ),
      ),
    );
  }

  String _getCustomerType(String? customerTypes) {
    if (customerTypes == CustomerTypes.ME.name) {
      return "المعينين لي";
    } else if (customerTypes == CustomerTypes.ME_AND_TEAM.name) {
      return "انا وفريقي";
    } else if (customerTypes == CustomerTypes.TEAM.name) {
      return "فريقي";
    } else if (customerTypes == CustomerTypes.NOT_ASSIGNED.name) {
      return "غير معينين";
    } else if (customerTypes == CustomerTypes.OWN.name) {
      return "عملائي";
    } else {
      return "كل العملاء";
    }
  }

  String _getReminderType(String? reminderTypes) {
    if (reminderTypes == ReminderTypes.NOW.name) {
      return "NOW";
    } else if (reminderTypes == ReminderTypes.SKIP.name) {
      return "DELAYED";
    } else if (reminderTypes == ReminderTypes.DELAYED.name) {
      return "UPCOMING";
    } else {
      return "حسب التذكير";
    }
  }
}
