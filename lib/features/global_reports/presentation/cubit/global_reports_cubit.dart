import 'package:crm_flutter_project/core/error/failures.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/features/global_reports/data/models/employee_assigns_report_model.dart';
import 'package:crm_flutter_project/features/global_reports/domain/use_cases/global_reports_use_cases.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'global_reports_state.dart';

class GlobalReportsCubit extends Cubit<GlobalReportsState> {
  final GlobalReportsUseCases globalReportsUseCases;

  GlobalReportsCubit({required this.globalReportsUseCases})
      : super(GlobalReportsInitial());

  static GlobalReportsCubit get(context) => BlocProvider.of(context);

  List<EmployeeAssignsReportModel> assignsReports = [];
  int assignsReportCurrentPage = 0;
  int assignsReportTotalElements = 0;
  late int assignsReportPagesCount;

  bool isNoMoreData = false;
  FetchEmployeesAssignReportParam filters = FetchEmployeesAssignReportParam.initial();

  void updateFilter(FetchEmployeesAssignReportParam newFilter) {
    emit(StartUpdateFilter());
    filters = newFilter;
    emit(EndUpdateFilter());
  }

  void resetFilter() {
    emit(StartResetFilter());
    filters = FetchEmployeesAssignReportParam.initial();
    emit(EndResetFilter());
  }

  Future<void> fetchGlobalReports({bool refresh = false}) async {
    emit(StartFetchEmployeesAssignsReport());

    Either<Failure, List<EmployeeAssignsReportModel>> response =
        await globalReportsUseCases.fetchEmployeesAssignReport(filters);
    response.fold(
        (failure) => emit(FetchEmployeesAssignsReportError(
            msg: Constants.mapFailureToMsg(failure))), (newData) {
      assignsReports = newData;
      return emit(EndFetchEmployeesAssignsReport(newAssignsReports: newData));
    });
  }
}
