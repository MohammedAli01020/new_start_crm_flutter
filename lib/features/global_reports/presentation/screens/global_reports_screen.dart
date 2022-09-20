import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/global_reports/presentation/cubit/global_reports_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../../customers/presentation/widgets/DateFilterPicker.dart';
import '../../../customers/presentation/widgets/filter_field.dart';

class GlobalReportsScreen extends StatelessWidget {
  const GlobalReportsScreen({Key? key}) : super(key: key);

  void _fetchGlobalReports(
      {bool refresh = false, required BuildContext context}) {
    BlocProvider.of<GlobalReportsCubit>(context)
        .fetchGlobalReports(refresh: refresh);
  }

  Widget _buildList(GlobalReportsCubit cubit, GlobalReportsState state,
      BuildContext context) {
    if (state is StartFetchEmployeesAssignsReport) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is FetchEmployeesAssignsReportError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          _fetchGlobalReports(
            refresh: true,
            context: context,
          );
        },
      );
    }

    return Scrollbar(
      child: ListView.separated(
        itemBuilder: (context, index) {
          final currentReport = cubit.assignsReports[index];
          return ListTile(
            title: Text(currentReport.fullName),
            subtitle: Text(currentReport.count.toString()),
          );
        },
        itemCount: cubit.assignsReports.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalReportsCubit, GlobalReportsState>(
      builder: (context, state) {
        final globalReportsCubit = GlobalReportsCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("احصائيات التعينات"),
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
                                startDateTime:
                                    globalReportsCubit.filters.startDate,
                                endDateTime: globalReportsCubit.filters.endDate,
                                onSelectTypeCallback: (int? start, int? end) {
                                  globalReportsCubit.updateFilter(
                                      globalReportsCubit.filters.copyWith(
                                    startDate: Wrapped.value(start),
                                    endDate: Wrapped.value(end),
                                  ));
                                  globalReportsCubit.fetchGlobalReports(
                                      refresh: true);
                                },
                              ));
                        },
                        child: FilterField(
                          text: Row(
                            children: [
                              Text(Constants.getDateType(
                                globalReportsCubit.filters.startDate,
                                globalReportsCubit.filters.endDate,
                              )),
                              Icon(
                                Icons.arrow_drop_down,
                                color: globalReportsCubit.filters.startDate !=
                                            null &&
                                        globalReportsCubit.filters.endDate !=
                                            null
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
          ),
          body: _buildList(globalReportsCubit, state, context),
        );
      },
    );
  }
}
