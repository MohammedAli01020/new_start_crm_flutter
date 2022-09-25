import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/features/own_reports/domain/entities/employee_statistics_result.dart';
import 'package:crm_flutter_project/features/own_reports/domain/use_cases/own_reports_use_case.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/count_customer_type_filters_model.dart';

part 'own_reports_state.dart';

class OwnReportsCubit extends Cubit<OwnReportsState> {
  final OwnReportsUseCase ownReportsUseCase;
  OwnReportsCubit({required this.ownReportsUseCase}) : super(OwnReportsInitial());


  static OwnReportsCubit get(context) => BlocProvider.of(context);

  CountCustomerTypeFiltersModel countCustomerTypeFiltersModel = CountCustomerTypeFiltersModel.initial();

  Future<void> fetchEmployeeReports() async {

    emit(StartFetchEmployeeReports());
    Either<Failure, EmployeeStatisticsResult> response =
        await ownReportsUseCase.fetchEmployeeReports(countCustomerTypeFiltersModel);

    emit(response.fold((failure) => FetchEmployeeReportsError(msg: Constants.mapFailureToMsg(failure)),
            (r) => EndFetchEmployeeReports(employeeStatisticsResult: r)));

  }
}
