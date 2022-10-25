import 'package:bloc/bloc.dart';
import 'package:crm_flutter_project/features/reports/data/models/report_data_model.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../domain/use_cases/report_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportUseCases reportUseCases;

  ReportCubit({required this.reportUseCases}) : super(ReportInitial());

  static ReportCubit get(context) => BlocProvider.of(context);


  FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam = FetchEmployeesCustomerReportParam.initial();


  void updateFilters(FetchEmployeesCustomerReportParam newFilters) {
    emit(StartUpdateFilters());

    fetchEmployeesCustomerReportParam = newFilters;
    emit(EndUpdateFilters());

  }

  void resetFilters(FetchEmployeesCustomerReportParam newFilters) {
    emit(StartUpdateFilters());
    fetchEmployeesCustomerReportParam = FetchEmployeesCustomerReportParam.initial();
    emit(EndUpdateFilters());

  }


  Future<void> fetchEmployeeCustomerReports() async {
    emit(StartFetchEmployeeCustomerReports());

    Either<Failure, ReportDataModel> response = await reportUseCases
        .fetchEmployeeCustomerReports(fetchEmployeesCustomerReportParam);
    response.fold(
        (failure) => emit(FetchEmployeeCustomerReportsError(
            msg: Constants.mapFailureToMsg(failure))), (newData) {
      return emit(EndFetchEmployeeCustomerReports(reportDataModel: newData));
    });
  }
}
