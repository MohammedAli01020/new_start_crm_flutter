import 'package:crm_flutter_project/features/customer_logs/data/data_sources/customer_log_remote_data_source.dart';
import 'package:crm_flutter_project/features/customer_logs/data/repositories/customer_log_repository_impl.dart';
import 'package:crm_flutter_project/features/customer_logs/domain/repositories/customer_log_repository.dart';
import 'package:crm_flutter_project/features/customer_logs/domain/use_cases/customer_log_use_cases.dart';
import 'package:crm_flutter_project/features/customer_logs/presentation/cubit/customer_logs_cubit.dart';
import 'package:crm_flutter_project/features/customers/data/data_sources/customer_local_data_source.dart';
import 'package:crm_flutter_project/features/customers/data/data_sources/customer_remote_data_source.dart';
import 'package:crm_flutter_project/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:crm_flutter_project/features/customers/domain/repositories/customer_repository.dart';
import 'package:crm_flutter_project/features/customers/domain/use_cases/customer_use_cases.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/duplicates/duplicates_cubit.dart';
import 'package:crm_flutter_project/features/employees/data/data_sources/employee_remote_data_source.dart';
import 'package:crm_flutter_project/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:crm_flutter_project/features/employees/domain/repositories/employee_repository.dart';
import 'package:crm_flutter_project/features/employees/domain/use_cases/employee_use_cases.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:crm_flutter_project/features/events/data/data_sources/event_remote_data_source.dart';
import 'package:crm_flutter_project/features/events/data/repositories/event_repository_impl.dart';
import 'package:crm_flutter_project/features/events/domain/repositories/event_repository.dart';
import 'package:crm_flutter_project/features/events/domain/use_cases/events_use_cases.dart';
import 'package:crm_flutter_project/features/events/presentation/cubit/event_cubit.dart';
import 'package:crm_flutter_project/features/global_reports/data/data_sources/global_reports_remote_data_source.dart';
import 'package:crm_flutter_project/features/global_reports/data/repositories/global_reports_repository_impl.dart';
import 'package:crm_flutter_project/features/global_reports/domain/repositories/global_reports_repository.dart';
import 'package:crm_flutter_project/features/global_reports/domain/use_cases/global_reports_use_cases.dart';
import 'package:crm_flutter_project/features/global_reports/presentation/cubit/global_reports_cubit.dart';
import 'package:crm_flutter_project/features/permissions/data/data_sources/permission_remote_data_source.dart';
import 'package:crm_flutter_project/features/permissions/data/repositories/permission_repository_impl.dart';
import 'package:crm_flutter_project/features/permissions/domain/repositories/permission_repository.dart';
import 'package:crm_flutter_project/features/permissions/domain/use_cases/permissions_use_cases.dart';
import 'package:crm_flutter_project/features/permissions/presentation/cubit/permission_cubit.dart';
import 'package:crm_flutter_project/features/sources/data/data_sources/source_remote_data_source.dart';
import 'package:crm_flutter_project/features/sources/data/repositories/source_repository_impl.dart';
import 'package:crm_flutter_project/features/sources/domain/repositories/source_repository.dart';
import 'package:crm_flutter_project/features/sources/domain/use_cases/sources_use_cases.dart';
import 'package:crm_flutter_project/features/sources/presentation/cubit/source_cubit.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_member_remote_data_source.dart';
import 'package:crm_flutter_project/features/teams/data/data_sources/team_remote_data_source.dart';
import 'package:crm_flutter_project/features/teams/data/repositories/team_member_repository_impl.dart';
import 'package:crm_flutter_project/features/teams/data/repositories/team_repository_impl.dart';
import 'package:crm_flutter_project/features/teams/domain/repositories/team_member_repository.dart';
import 'package:crm_flutter_project/features/teams/domain/repositories/team_repository.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_member_use_cases.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_use_cases.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_cubit.dart';
import 'package:crm_flutter_project/features/unit_types/data/data_sources/unit_type_remote_data_source.dart';
import 'package:crm_flutter_project/features/unit_types/data/repositories/unit_type_repository_impl.dart';
import 'package:crm_flutter_project/features/unit_types/domain/repositories/unit_types_repository.dart';
import 'package:crm_flutter_project/features/unit_types/domain/use_cases/unit_types_use_cases.dart';
import 'package:crm_flutter_project/features/unit_types/presentation/cubit/unit_type_cubit.dart';
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
import 'features/teams/presentation/cubit/team_members/team_members_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory(() => LoginCubit(loginUseCases: sl()));
  sl.registerFactory(() => EmployeeCubit(employeeUseCases: sl()));

  sl.registerFactory(() => TeamCubit(teamUseCases: sl()));
  sl.registerFactory(() => TeamMembersCubit(teamMemberUseCases: sl()));
  sl.registerFactory(() => CustomerCubit(customerUseCases: sl()));

  sl.registerFactory(() => EventCubit(eventsUseCases:  sl()));


  sl.registerFactory(() => PermissionCubit(permissionsUseCases:   sl()));

  sl.registerFactory(() => SourceCubit(sourcesUseCases:  sl()));

  sl.registerFactory(() => UnitTypeCubit(unitTypesUseCases:   sl()));

  sl.registerFactory(() => CustomerLogsCubit(customerLogUseCases:   sl()));

  sl.registerFactory(() => GlobalReportsCubit(globalReportsUseCases:  sl()));

  sl.registerFactory(() => DuplicatesCubit(customerUseCases:  sl()));


  // Use cases
  sl.registerLazySingleton<LoginUseCases>(
          () => LoginUseCasesImpl(loginRepository: sl()));

  sl.registerLazySingleton<EmployeeUseCases>(
          () => EmployeeUseCasesImpl(employeeRepository: sl()));

  sl.registerLazySingleton<TeamUseCases>(
          () => TeamUseCasesImpl(teamRepository: sl()));

  sl.registerLazySingleton<TeamMemberUseCases>(
          () => TeamMemberUseCasesImpl(teamMemberRepository: sl()));


  sl.registerLazySingleton<CustomerUseCases>(
          () => CustomerUseCasesImpl(customerRepository: sl()));

  sl.registerLazySingleton<EventsUseCases>(
          () => EventsUseCasesImpl(eventRepository:  sl()));


  sl.registerLazySingleton<PermissionsUseCases>(
          () => PermissionsUseCasesImpl(permissionRepository:  sl()));


  sl.registerLazySingleton<SourcesUseCases>(
          () => SourcesUseCasesImpl(sourceRepository:  sl()));

  sl.registerLazySingleton<UnitTypesUseCases>(
          () => UnitTypesUseCasesImpl(unitTypesRepository:  sl()));

  sl.registerLazySingleton<CustomerLogUseCases>(
          () => CustomerLogUseCasesImpl(customerLogRepository:   sl()));

  sl.registerLazySingleton<GlobalReportsUseCases>(
          () => GlobalReportsUseCasesImpl(globalReportsRepository:   sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl(
      loginLocalDataSource: sl(), loginRemoteDataSource: sl()));

  sl.registerLazySingleton<EmployeeRepository>(() => EmployeeRepositoryImpl(
      employeeRemoteDataSource: sl()));

  sl.registerLazySingleton<TeamRepository>(() => TeamRepositoryImpl(
      teamRemoteDataSource: sl()));

  sl.registerLazySingleton<TeamMemberRepository>(() => TeamMemberRepositoryImpl(
      teamMemberRemoteDataSource:  sl()));


  sl.registerLazySingleton<CustomerRepository>(() => CustomerRepositoryImpl(
      customerRemoteDataSource:  sl(), loginLocalDataSource: sl(),
      customerLocalDataSource: sl()));


  sl.registerLazySingleton<EventRepository>(() => EventRepositoryImpl(
     eventRemoteDataSource:  sl()));

  sl.registerLazySingleton<PermissionRepository>(() => PermissionRepositoryImpl(
      permissionRemoteDataPermission:  sl()));

  sl.registerLazySingleton<SourceRepository>(() => SourceRepositoryImpl(
      sourceRemoteDataSource:   sl()));

  sl.registerLazySingleton<UnitTypesRepository>(() => UnitTypeRepositoryImpl(
      unitTypeRemoteDataUnitType: sl()));

  sl.registerLazySingleton<CustomerLogRepository>(() => CustomerLogRepositoryImpl(
      customerLogRemoteDataSource:  sl()));

  sl.registerLazySingleton<GlobalReportsRepository>(() => GlobalReportsRepositoryImpl(
      globalReportsRemoteDataSource:  sl()));

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


  sl.registerLazySingleton<CustomerRemoteDataSource>(
          () => CustomerRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<CustomerLocalDataSource>(
          () => CustomerLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<EventRemoteDataSource>(
          () => EventRemoteDataSourceImpl(apiConsumer: sl()));


  sl.registerLazySingleton<PermissionRemoteDataPermission>(
          () => PermissionRemoteDataPermissionImpl(apiConsumer: sl()));

  sl.registerLazySingleton<SourceRemoteDataSource>(
          () => SourceRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<UnitTypeRemoteDataSource>(
          () => UnitTypeRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<CustomerLogRemoteDataSource>(
          () => CustomerLogRemoteDataSourceImpl(apiConsumer: sl()));

  sl.registerLazySingleton<GlobalReportsRemoteDataSource>(
          () => GlobalReportsRemoteDataSourceImpl(apiConsumer: sl()));
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
