import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:flutter/material.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/filter_item.dart';

import '../../../customers/presentation/widgets/DateFilterPicker.dart';
import '../../../customers/presentation/widgets/filter_field.dart';
import '../../../employees/data/models/employee_model.dart';
import '../../../employees/presentation/screens/employee_picker_screen.dart';
import '../../../teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../cubit/own_reports_cubit.dart';


class OwnReportsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final OwnReportsCubit ownReportsCubit;
  final TeamMembersCubit teamMembersCubit;


  const OwnReportsAppBar(
      {Key? key,
        required this.ownReportsCubit,
        required this.teamMembersCubit})
      : super(key: key);

  @override
  State<OwnReportsAppBar> createState() => _OwnReportsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);
}

class _OwnReportsAppBarState extends State<OwnReportsAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: const Text("نظرة عامة"),
      actions: [
        IconButton(onPressed: () {
          widget.ownReportsCubit.fetchEmployeeReports();
        }, icon: const Icon(Icons.refresh))
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
          if (Constants.currentEmployee!.permissions.contains(AppStrings.viewAllStatistics))
              FilterItem(
                currentValue:
                widget.ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType,
                onTapCallback: () {
                  widget.ownReportsCubit.updateFilter(widget
                      .ownReportsCubit.countCustomerTypeFiltersModel
                      .copyWith(employeeReportType: Wrapped.value(EmployeeReportType.ALL.name)));


                  widget.ownReportsCubit.fetchEmployeeReports();
                },
                text: 'الكل',
                value: EmployeeReportType.ALL.name,
              ),


              if (Constants.currentEmployee?.teamId != null)
                FilterItem(
                  currentValue:
                  widget.ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType,
                  onTapCallback: () {
                    widget.ownReportsCubit.updateFilter(widget
                        .ownReportsCubit.countCustomerTypeFiltersModel
                        .copyWith(employeeReportType: Wrapped.value(EmployeeReportType.TEAM.name)));


                    widget.ownReportsCubit.fetchEmployeeReports();
                  },
                  text: 'فريقي',
                  value: EmployeeReportType.TEAM.name,
                ),


              if (Constants.currentEmployee?.teamId != null)
                FilterItem(
                  currentValue:
                  widget.ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType,
                  onTapCallback: () {
                    widget.ownReportsCubit.updateFilter(widget
                        .ownReportsCubit.countCustomerTypeFiltersModel
                        .copyWith(employeeReportType: Wrapped.value(EmployeeReportType.ME_AND_TEAM.name)));


                    widget.ownReportsCubit.fetchEmployeeReports();
                  },
                  text: 'انا وفريقي',
                  value: EmployeeReportType.ME_AND_TEAM.name,
                ),


                FilterItem(
                  currentValue:

                  widget.ownReportsCubit.countCustomerTypeFiltersModel.employeeReportType,
                  onTapCallback: () {
                    widget.ownReportsCubit.updateFilter(widget
                        .ownReportsCubit.countCustomerTypeFiltersModel
                        .copyWith(employeeReportType: Wrapped.value(EmployeeReportType.ME.name)));


                    widget.ownReportsCubit.fetchEmployeeReports();
                  },
                  text: 'انا',
                  value: EmployeeReportType.ME.name,
                ),


              if (Constants.currentEmployee?.teamId != null ||
                  Constants.currentEmployee!.permissions.contains(AppStrings.viewAllStatistics))
              GestureDetector(
                  onTap: () async {

                    final result = await Navigator.pushNamed(context, Routes.employeePickerRoute,
                        arguments: EmployeePickerArgs(
                            employeePickerTypes: Constants.currentEmployee!.permissions.contains(AppStrings.viewAllStatistics) ?
                            EmployeePickerTypes.ASSIGN_MEMBER.name : EmployeePickerTypes.ASSIGN_FROM_TEAM_MEMBERS.name,
                            teamMembersCubit: widget.teamMembersCubit
                        ));


                    if (result != null && result is Map<String, dynamic>) {

                      EmployeeModel em = EmployeeModel.fromJson(result);
                      widget.ownReportsCubit.setSelectedEmployee(em);

                      widget.ownReportsCubit.updateFilter(widget
                          .ownReportsCubit.countCustomerTypeFiltersModel
                          .copyWith(
                          employeeId: Wrapped.value(em.employeeId),
                          employeeReportType: Wrapped.value(EmployeeReportType.SPECIFIC.name)));

                      widget.ownReportsCubit.fetchEmployeeReports();
                    }

                  },
                  child:  FilterField(
                      text: Row(
                        children: [
                          Text(
                            widget.ownReportsCubit.selectedEmployee != null
                                ? "معين الي " + widget.ownReportsCubit.selectedEmployee!.fullName
                                : "علي حسب ميعن إلي",
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: widget.ownReportsCubit.selectedEmployee != null
                                  ? AppColors.primary
                                  : Colors.grey),

                          if (widget.ownReportsCubit.selectedEmployee != null )
                            InkWell(
                                onTap: () {


                                  widget.ownReportsCubit.setSelectedEmployee(null);
                                  widget.ownReportsCubit.updateFilter(widget
                                      .ownReportsCubit.countCustomerTypeFiltersModel
                                      .copyWith(
                                      employeeId: Wrapped.value(Constants.currentEmployee?.employeeId),
                                      employeeReportType: Wrapped.value(EmployeeReportType.ME.name)));


                                  widget.ownReportsCubit.fetchEmployeeReports();
                                },
                                child: const Text("مسح"))
                        ],
                      ))),

              const VerticalDivider(
                thickness: 2.0,
              ),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب التاريخ",
                        content: DateFilterPicker(
                          startDateTime: widget.ownReportsCubit
                              .countCustomerTypeFiltersModel.startDate,
                          endDateTime: widget.ownReportsCubit.countCustomerTypeFiltersModel
                              .endDate,
                          onSelectTypeCallback: (int? start, int? end) {
                            widget.ownReportsCubit.updateFilter(widget
                                .ownReportsCubit.countCustomerTypeFiltersModel.copyWith(
                              startDate: Wrapped.value(start),
                              endDate: Wrapped.value(end),
                            ));

                            widget.ownReportsCubit.fetchEmployeeReports();
                          },

                        )
                    );
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(Constants.getDateType(widget
                            .ownReportsCubit.countCustomerTypeFiltersModel.startDate,
                          widget
                              .ownReportsCubit.countCustomerTypeFiltersModel
                              .endDate,)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: widget.ownReportsCubit.countCustomerTypeFiltersModel
                              .startDate != null &&
                              widget.ownReportsCubit.countCustomerTypeFiltersModel
                                  .endDate != null
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ],
                    ),
                  )),

            ],
          ),
        ),
      ),
    );
  }

}