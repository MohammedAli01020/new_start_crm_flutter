import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/error_item_widget.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({Key? key}) : super(key: key);

  void _getPageEmployees(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<EmployeeCubit>(context).fetchEmployees(refresh: refresh);
  }

  Widget _buildBodyTable(
      {required EmployeeCubit cubit,
      required EmployeeState state,
      required BuildContext context}) {


    if (state is StartRefreshEmployees || state is StartLoadingEmployees) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RefreshEmployeesError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _getPageEmployees(refresh: true, context: context);
        },
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        width: context.width,
        child: PaginatedDataTable(
            columns: const [
              DataColumn(label: Text('الصورة')),
              DataColumn(label: Text('الاسم')),
              DataColumn(label: Text('تاريخ التعين')),
              DataColumn(label: Text('رقم التليفون')),
              DataColumn(label: Text('الحالة')),
              DataColumn(label: Text('الايميل')),
            ],
            rowsPerPage: 10,
            showCheckboxColumn: false,
            onPageChanged: (pageIndex) {
              cubit.updateFilter(cubit.employeeFiltersModel
                  .copyWith(pageNumber: Wrapped.value(pageIndex)));

              _getPageEmployees(context: context);
            },
            source: EmployeesDataTable(
                employeeCubit: cubit,
                onSelect: (val, currentEmployee) {
                  // Navigator.pushNamed(
                  //     context, Routes.loanDetailsRoute,
                  //     arguments: LoanDetailsArgs(
                  //         loanModel: currentEmployee,
                  //         loansCubit: loansCubit,
                  //         fromRoute: Routes.loansRoute));
                })),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        final employeeCubit = EmployeeCubit.get(context);

        return Scaffold(
          appBar: EmployeesAppBar(
            employeeCubit: employeeCubit,
            onSearchChangeCallback: (search) {
              employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                  .copyWith(fullNameOrPhoneNumber: Wrapped.value(search)));
              _getPageEmployees(refresh: true, context: context);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                employeeCubit.updateFilter(employeeCubit.employeeFiltersModel
                    .copyWith(
                        fullNameOrPhoneNumber: const Wrapped.value(null)));

                _getPageEmployees(refresh: true, context: context);
              }
            },
          ),
          body: _buildBodyTable(
              cubit: employeeCubit, state: state, context: context),
        );
      },
    );
  }
}

class EmployeesDataTable extends DataTableSource {
  final EmployeeCubit employeeCubit;
  final Function onSelect;

  EmployeesDataTable({
    required this.employeeCubit,
    required this.onSelect,
  });

  @override
  DataRow? getRow(int index) {
    final currentEmployee = employeeCubit.employees[index];

    return DataRow.byIndex(
        index: index,
        onSelectChanged: (val) {
          onSelect(val, currentEmployee);
        },
        cells: [
          DataCell(Container(
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            child: ClipOval(
                child: currentEmployee.imageUrl != null
                    ? CachedNetworkImage(
                  height: 40.0,
                  width: 40.0,
                  fit: BoxFit.cover,
                  imageUrl: currentEmployee.imageUrl!,
                  placeholder: (context, url) =>
                      Container(
                        decoration: BoxDecoration(
                          color:
                          AppColors.hint.withOpacity(0.2),
                        ),
                      ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                )
                    : CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 20.0,
                    child: Text(
                      currentEmployee.fullName.characters.first,
                      style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ))),
            height: 40.0,
            width: 40.0,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(blurRadius: 1.0, color: AppColors.hint)],
            ),
          )),
          DataCell(Text(currentEmployee.fullName)),
          DataCell(Text(Constants.dateTimeFromMilliSeconds(
              currentEmployee.createDateTime))),
          DataCell(TextButton(
              onPressed: () {
                Constants.launchCaller(
                    currentEmployee.phoneNumber.phone,
                    currentEmployee.phoneNumber.isoCode);
              },
              child: Text(currentEmployee.phoneNumber.phone))),

          DataCell(Text(currentEmployee.enabled.toString())),
          DataCell(Text(currentEmployee.username)),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employeeCubit.employeeTotalElements;

  @override
  int get selectedRowCount => 0;
}

class EmployeesAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function onSearchChangeCallback;
  final Function onCancelTapCallback;
  final EmployeeCubit employeeCubit;

  const EmployeesAppBar(
      {Key? key,
      required this.onSearchChangeCallback,
      required this.onCancelTapCallback,
      required this.employeeCubit})
      : super(key: key);

  @override
  State<EmployeesAppBar> createState() => _EmployeesAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _EmployeesAppBarState extends State<EmployeesAppBar> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isSearch
          ? TextField(
              textInputAction: TextInputAction.go,
              decoration: const InputDecoration(
                hintText: "اسم الموظف او رقمة",
              ),
              onChanged: (search) {
                widget.onSearchChangeCallback(search);
              },
            )
          : const Text("الموظفون"),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
              });

              widget.onCancelTapCallback(isSearch);
            },
            icon: Icon(isSearch ? Icons.cancel : Icons.search)),
        IconButton(
          onPressed: () {
            // Navigator.pushNamed(context, Routes.modifyEmployeeRoute,
            //     arguments:
            //     ModifyEmployeeArgs(employeeCubit: widget.employeeCubit));
          },
          icon: const Icon(Icons.person_add),
        ),
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
              FilterItem(
                currentValue:
                    widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(widget
                      .employeeCubit.employeeFiltersModel
                      .copyWith(employeeTypes: const Wrapped.value(null)));
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'الكل',
                value: null,
              ),
              FilterItem(
                currentValue:
                    widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes:
                              Wrapped.value(EmployeeTypes.NOT_ASSIGNED.name)));
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'ليس له عميل',
                value: EmployeeTypes.NOT_ASSIGNED.name,
              ),
              FilterItem(
                currentValue:
                    widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes:
                              Wrapped.value(EmployeeTypes.TEAM_LEADERS.name)));
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'تيم ليدرز',
                value: EmployeeTypes.TEAM_LEADERS.name,
              ),
              FilterItem(
                currentValue:
                    widget.employeeCubit.employeeFiltersModel.employeeTypes,
                onTapCallback: () {
                  widget.employeeCubit.updateFilter(
                      widget.employeeCubit.employeeFiltersModel.copyWith(
                          employeeTypes:
                              Wrapped.value(EmployeeTypes.NOT_IN_MEMBER.name)));
                  widget.employeeCubit.fetchEmployees(refresh: true);
                },
                text: 'ليس له تيم',
                value: EmployeeTypes.NOT_IN_MEMBER.name,
              ),
              const VerticalDivider(
                thickness: 2.0,
              ),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: const Wrapped.value(null),
                            endDateTime: const Wrapped.value(null)));
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: "كل الاوقات",
                  startDateMillis: null,
                  endDateMillis: null,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime

              ),
              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimeOfCurrentMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfCurrentMonthMillis)));
                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: "هل الشهر",
                  startDateMillis: DateTime.now().firstTimeOfCurrentMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfCurrentMonthMillis,
                  currentStartDateMillis:
                      widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                      widget.employeeCubit.employeeFiltersModel.endDateTime),

              FilterItemForDate(
                  onTapCallback: () {
                    widget.employeeCubit.updateFilter(
                        widget.employeeCubit.employeeFiltersModel.copyWith(
                            startDateTime: Wrapped.value(
                                DateTime.now().firstTimePreviousMonthMillis),
                            endDateTime: Wrapped.value(
                                DateTime.now().lastTimOfPreviousMonthMillis)));

                    widget.employeeCubit.fetchEmployees(refresh: true);
                  },
                  text: "الشهر السابق",
                  startDateMillis: DateTime.now().firstTimePreviousMonthMillis,
                  endDateMillis: DateTime.now().lastTimOfPreviousMonthMillis,
                  currentStartDateMillis:
                  widget.employeeCubit.employeeFiltersModel.startDateTime,
                  currentEndDateMillis:
                  widget.employeeCubit.employeeFiltersModel.endDateTime

              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final VoidCallback onTapCallback;
  final String text;
  final String? value;
  final String? currentValue;

  const FilterItem({
    Key? key,
    required this.onTapCallback,
    required this.text,
    required this.value,
    required this.currentValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: value == currentValue
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color:
                  value == currentValue ? AppColors.primary : AppColors.hint),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.0,
              color:
                  value == currentValue ? AppColors.primary : AppColors.hint),
        ),
      ),
    );
  }
}

class FilterItemForDate extends StatelessWidget {
  final VoidCallback onTapCallback;
  final String text;
  final int? startDateMillis;
  final int? endDateMillis;
  final int? currentStartDateMillis;
  final int? currentEndDateMillis;

  const FilterItemForDate({
    Key? key,
    required this.onTapCallback,
    required this.text,
    required this.startDateMillis,
    required this.endDateMillis,
    required this.currentStartDateMillis,
    required this.currentEndDateMillis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCallback,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: startDateMillis == currentStartDateMillis &&
                  endDateMillis == currentEndDateMillis
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: startDateMillis == currentStartDateMillis &&
                      endDateMillis == currentEndDateMillis
                  ? AppColors.primary
                  : AppColors.hint),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 14.0,
              color: startDateMillis == currentStartDateMillis &&
                      endDateMillis == currentEndDateMillis
                  ? AppColors.primary
                  : AppColors.hint),
        ),
      ),
    );
  }
}
