import 'package:crm_flutter_project/features/employees/data/data_sources/employee_remote_data_source.dart';
import 'package:crm_flutter_project/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:crm_flutter_project/features/employees/domain/repositories/employee_repository.dart';
import 'package:crm_flutter_project/features/employees/domain/use_cases/employee_use_cases.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_member_remote_data_source.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_remote_data_source.dart';
import 'package:crm_flutter_project/features/teams/data/repositories/team_member_repository_impl.dart';
import 'package:crm_flutter_project/features/teams/data/repositories/team_repository_impl.dart';
import 'package:crm_flutter_project/features/teams/domain/repositories/team_member_repository.dart';
import 'package:crm_flutter_project/features/teams/domain/repositories/team_repository.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_member_use_cases.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_use_cases.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/network_info.dart';
import 'features/login/data/data_sources/login_local_data_source.dart';
import 'features/login/data/data_sources/login_remote_data_source.dart';
import 'features/login/data/repositories/login_repository_impl.dart';
import 'features/login/domain/repositories/login_repository.dart';
import 'features/login/domain/use_cases/login_use_cases.dart';
import 'features/login/presentation/cubit/login_cubit.dart';
import 'features/teams/presentation/cubit/team_mmbers/team_members_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory(() => LoginCubit(loginUseCases: sl()));
  sl.registerFactory(() => EmployeeCubit(employeeUseCases: sl()));

  sl.registerFactory(() => TeamCubit(teamUseCases: sl()));
  sl.registerFactory(() => TeamMembersCubit(teamMemberUseCases: sl()));

  // Use cases
  sl.registerLazySingleton<LoginUseCases>(
          () => LoginUseCasesImpl(loginRepository: sl()));

  sl.registerLazySingleton<EmployeeUseCases>(
          () => EmployeeUseCasesImpl(employeeRepository: sl()));

  sl.registerLazySingleton<TeamUseCases>(
          () => TeamUseCasesImpl(teamRepository: sl()));



  sl.registerLazySingleton<TeamMemberUseCases>(
          () => TeamMemberUseCasesImpl(teamMemberRepository: sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
      loginLocalDataSource: sl(), loginRemoteDataSource: sl()));

  sl.registerLazySingleton<EmployeeRepository>(() => EmployeeRepositoryImpl(
      employeeRemoteDataSource: sl()));

  sl.registerLazySingleton<TeamRepository>(() => TeamRepositoryImpl(
      teamRemoteDataSource: sl()));

  sl.registerLazySingleton<TeamMemberRepository>(() => TeamMemberRepositoryImpl(
      teamMemberRemoteDataSource:  sl()));
  // Data Sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
          () => LoginRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<LoginLocalDataSource>(
          () => LoginLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<EmployeeRemoteDataSource>(
          () => EmployeeRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<TeamRemoteDataSource>(
          () => TeamRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<TeamMemberRemoteDataSource>(
          () => TeamMemberRemoteDataSourceImpl(apiConsumer: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));



  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppIntercepters());
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
