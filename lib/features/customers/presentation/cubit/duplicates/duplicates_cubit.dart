import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../employees/data/models/phoneNumber_model.dart';
import '../../../data/models/customer_model.dart';
import '../../../domain/use_cases/customer_use_cases.dart';
part 'duplicates_state.dart';

class DuplicatesCubit extends Cubit<DuplicatesState> {
  final CustomerUseCases customerUseCases;
  DuplicatesCubit({required this.customerUseCases}) : super(DuplicatesInitial());


  static DuplicatesCubit get(context) => BlocProvider.of(context);



  List<CustomerModel> duplicates = [];

  Future<void> findDistinctCustomersByPhoneNumber(PhoneNumbersWrapper phoneNumbersWrapper) async {
    duplicates = [];
    emit(StartFindDuplicateCustomers());

    Either<Failure, List<CustomerModel>> response =
    await customerUseCases.findDistinctCustomersByPhoneNumbers(phoneNumbersWrapper);

   response.fold((failure) => emit(FindDuplicateCustomersError(msg: Constants.mapFailureToMsg(failure))),
            (results) {

              duplicates = results;
              return emit(EndFindDuplicateCustomers(duplicatedByPhone: results));
            });

  }

}
