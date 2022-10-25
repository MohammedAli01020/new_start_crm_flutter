import 'package:crm_flutter_project/core/utils/date_values.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/wrapper.dart';
import '../../../../core/widgets/filter_item.dart';
import '../../../customers/presentation/widgets/DateFilterPicker.dart';
import '../../../customers/presentation/widgets/filter_field.dart';
import '../cubit/report_cubit.dart';


class ReportAppBar extends StatelessWidget implements PreferredSizeWidget {

  final ReportCubit reportCubit;

  const ReportAppBar({Key? key,
    required this.reportCubit}) : super(key: key);



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 45);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("التقارير"),
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
                onTapCallback: () {
                  reportCubit.updateFilters(
                      reportCubit.fetchEmployeesCustomerReportParam.copyWith(
                          assign: const Wrapped.value(true)));

                  reportCubit.fetchEmployeeCustomerReports();
                },
                text: 'علي حسب التعيين',
                value: "true",
                currentValue: reportCubit.fetchEmployeesCustomerReportParam.assign.toString(),
              ),


              FilterItem(

                onTapCallback: () {
                  reportCubit.updateFilters(
                      reportCubit.fetchEmployeesCustomerReportParam.copyWith(
                          assign: const Wrapped.value(false)));

                  reportCubit.fetchEmployeeCustomerReports();
                },
                text: 'علي حسب مدخل الداتا',
                value: "false",
                currentValue: reportCubit.fetchEmployeesCustomerReportParam.assign.toString(),
              ),

              const Divider(),

              GestureDetector(
                  onTap: () {
                    Constants.showDialogBox(
                        context: context,
                        title: "فلتر حسب التاريخ",
                        content: DateFilterPicker(
                          startDateTime: reportCubit.fetchEmployeesCustomerReportParam.startDate,
                          endDateTime: reportCubit.fetchEmployeesCustomerReportParam.endDate,
                          onSelectTypeCallback: (int? start, int? end) {
                            reportCubit.updateFilters(
                                reportCubit.fetchEmployeesCustomerReportParam.copyWith(
                              startDate: Wrapped.value(start),
                              endDate: Wrapped.value(end),
                            ));

                            reportCubit.fetchEmployeeCustomerReports();
                          },

                        )
                    );
                  },
                  child: FilterField(
                    text: Row(
                      children: [
                        Text(_getDateType(reportCubit.fetchEmployeesCustomerReportParam.startDate,
                          reportCubit.fetchEmployeesCustomerReportParam.endDate,)),
                        Icon(
                          Icons.arrow_drop_down,
                          color: reportCubit.fetchEmployeesCustomerReportParam.startDate != null &&
                              reportCubit.fetchEmployeesCustomerReportParam.endDate != null
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


  String _getDateType(int? startDateTime, int? endDateTime) {
    if (startDateTime == null && endDateTime == null) {
      return "كل الاوقات";
    } else if (startDateTime == DateTime.now().firstTimOfCurrentDayMillis &&
        endDateTime == DateTime.now().lastTimOfCurrentDayMillis) {
      return "هذا اليوم";
    } else if (startDateTime == DateTime.now().firstTimeOfCurrentMonthMillis &&
        endDateTime == DateTime.now().lastTimOfCurrentMonthMillis) {
      return "هذا الشهر";
    } else if (startDateTime == DateTime.now().firstTimePreviousMonthMillis &&
        endDateTime == DateTime.now().lastTimOfPreviousMonthMillis) {
      return "الشهر السابق";
    } else {

      String from = startDateTime != null ? (" من " + Constants.dateFromMilliSeconds(startDateTime)) : "";
      String to = endDateTime != null ? (" ألي " + Constants.dateFromMilliSeconds(endDateTime)) : "";

      return from + to;
    }
  }

}
