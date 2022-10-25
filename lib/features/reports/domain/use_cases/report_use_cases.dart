import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/wrapper.dart';
import '../../data/models/report_data_model.dart';
import 'package:equatable/equatable.dart';

import '../repositories/report_repository.dart';

abstract class ReportUseCases {
  Future<Either<Failure, ReportDataModel>> fetchEmployeeCustomerReports(
      FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam);
}

class ReportUseCasesImpl implements ReportUseCases {
  final ReportRepository reportRepository;

  ReportUseCasesImpl({required this.reportRepository});


  @override
  Future<Either<Failure, ReportDataModel>> fetchEmployeeCustomerReports(FetchEmployeesCustomerReportParam fetchEmployeesCustomerReportParam) {

    return reportRepository.fetchEmployeeCustomerReports(fetchEmployeesCustomerReportParam);
  }
}


class FetchEmployeesCustomerReportParam extends Equatable {
  final bool assign;
  final int? startDate;
  final int? endDate;

  const FetchEmployeesCustomerReportParam(
      {required this.assign, required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() {
    return {
      "assign": assign,
      "startDate": startDate,
      "endDate": endDate
    };
  }

  FetchEmployeesCustomerReportParam copyWith({
    Wrapped<bool>? assign,
    Wrapped<int?>? startDate,
    Wrapped<int?>? endDate,
  }) {
    return FetchEmployeesCustomerReportParam(
      assign: assign != null ? assign.value : this.assign,
      startDate: startDate != null ? startDate.value : this.startDate,
      endDate: endDate != null ? endDate.value : this.endDate,
    );
  }


  factory FetchEmployeesCustomerReportParam.initial() {
    return  const FetchEmployeesCustomerReportParam(
      assign: true,
      startDate: null,
      endDate: null,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate];
}
