import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/customer_logs/data/models/customer_log_filters_model.dart';
import 'package:crm_flutter_project/features/customer_logs/presentation/screens/customer_logs_screen.dart';
import 'package:crm_flutter_project/features/customer_table_config/presentation/screens/customer_table_config_screen.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/customer_datails_screen.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/customers_screen.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/modify_customer_screen.dart';
import 'package:crm_flutter_project/features/developers_and_projects/domain/use_cases/projects_use_case.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/screens/developers_screen.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/screens/projects_screen.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_filters_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_details_screen.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/modify_employee_screen.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/modify_role_screen.dart';
import 'package:crm_flutter_project/features/events/presentation/screens/events_screen.dart';
import 'package:crm_flutter_project/features/global_reports/presentation/screens/global_reports_screen.dart';
import 'package:crm_flutter_project/features/own_reports/presentation/screens/own_reports_screen.dart';
import 'package:crm_flutter_project/features/sources/presentation/screens/sources_screen.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_members_filters_model.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/employee_picker_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/modify_team_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/team_description_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/team_details_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/teams_screen.dart';
import 'package:crm_flutter_project/features/unit_types/presentation/screens/unit_types_screen.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_strings.dart';
import '../../features/customer_logs/presentation/cubit/customer_logs_cubit.dart';
import '../../features/customers/presentation/cubit/customer_cubit.dart';
import '../../features/developers_and_projects/presentation/cubit/developer/developer_cubit.dart';
import '../../features/developers_and_projects/presentation/cubit/project/project_cubit.dart';
import '../../features/employees/presentation/cubit/employee_cubit.dart';
import '../../features/employees/presentation/screens/employees_screen.dart';
import '../../features/events/presentation/cubit/event_cubit.dart';
import '../../features/global_reports/presentation/cubit/global_reports_cubit.dart';
import '../../features/login/presentation/screens/login_screen.dart';
import '../../features/own_reports/presentation/cubit/own_reports_cubit.dart';
import '../../features/permissions/presentation/cubit/permission_cubit.dart';
import '../../features/sources/presentation/cubit/source_cubit.dart';
import '../../features/teams/presentation/cubit/team_cubit.dart';
import '../../features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import '../../features/unit_types/presentation/cubit/unit_type_cubit.dart';

class Routes {
  static const String initialRoute = '/';

  // employees
  static const String modifyEmployeeRoute = '/modifyEmployeeRoute';
  static const String employeesRoute = '/employeesRoute';
  static const String employeesDetailsRoute = '/employeesDetailsRoute';
  static const String employeePickerRoute = '/employeePickerRoute';

  // customers
  static const String modifyCustomerRoute = '/modifyCustomerRoute';
  static const String customersRoute = '/customersRoute';
  static const String customersDetailsRoute = '/customersDetailsRoute';

  // teams
  static const String modifyTeamRoute = '/modifyTeamRoute';
  static const String teamsRoute = '/teamsRoute';
  static const String teamsDetailsRoute = '/teamsDetailsRoute';
  static const String teamDescriptionRoute = '/teamDescriptionRoute';

  // events
  static const String eventsRoute = '/eventsRoute';

  // sources
  static const String sourcesRoute = '/sourcesRoute';

  // unit_types
  static const String unitTypesRoute = '/unitTypesRoute';


  // roles
  static const String modifyRole = '/modifyRole';

  // customer_logs
  static const String customerLogsRoute = '/customerLogsRoute';

  // GlobalReports
  static const String globalReportsRoute = '/globalReportsRoute';


  // CustomerTableConfig
  static const String customerTableConfigRoute = '/customerTableConfigRoute';

  // developers_and_projects
  static const String developersRoute = '/developersRoute';
  static const String projectsRoute = '/projectsRoute';

  // own_reports
  static const String ownReportsRoute = '/ownReportsRoute';

}


class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              return const LoginScreen();
            }));

      case Routes.customersRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) {
                      return di.sl<CustomerCubit>();
                    },
                  ),

                  BlocProvider(
                    create: (context) {
                      return di.sl<EmployeeCubit>();
                    },
                  ),
                  BlocProvider(
                    create: (context) {
                      return di.sl<TeamMembersCubit>();
                    },
                  ),
                ],
                child: CustomersScreen(),
              );
            }));

      case Routes.modifyCustomerRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final modifyCustomerArgs =
                  routeSettings.arguments as ModifyCustomerArgs;

              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: modifyCustomerArgs.customerCubit,
                  ),
                  BlocProvider.value(
                    value: modifyCustomerArgs.teamMembersCubit,
                  ),
                ],
                child: ModifyCustomerScreen(
                    modifyCustomerArgs: modifyCustomerArgs),
              );
            }));

      case Routes.customersDetailsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final customerDetailsArgs =
                  routeSettings.arguments as CustomerDetailsArgs;

              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: customerDetailsArgs.customerCubit,
                  ),
                  BlocProvider.value(
                    value: customerDetailsArgs.teamMembersCubit,
                  ),

                  BlocProvider(
                    create: (context) {
                      return di.sl<CustomerLogsCubit>()
                        ..updateFilter(CustomerLogFiltersModel.initial().copyWith(
                          customerId: Wrapped.value(customerDetailsArgs.customerModel.customerId)))

                        ..fetchCustomerLogs(isWebPagination: false, refresh: true);
                    }
                  ),

                ],
                child: CustomerDetailsScreen(
                    customerDetailsArgs: customerDetailsArgs),
              );
            }));

      case Routes.employeesRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              return BlocProvider(
                create: (context) {
                  return di.sl<EmployeeCubit>()..updateFilter(EmployeeFiltersModel.initial().copyWith(

                    createdById: Wrapped.value(Constants.currentEmployee!.employeeId),
                    employeeTypes: Constants.currentEmployee!.permissions.contains(AppStrings.viewEmployees) ?
                    Wrapped.value(EmployeeTypes.ALL.name) : Wrapped.value(EmployeeTypes.I_CREATED.name),
                  ))..fetchEmployees(refresh: true);
                },
                child:  EmployeesScreen(),
              );
            }));


      case Routes.employeesDetailsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              final employeeDetailsArgs = routeSettings.arguments as EmployeeDetailsArgs;

              return BlocProvider.value(
                value: employeeDetailsArgs.employeeCubit,
                child: EmployeeDetailsScreen(employeeDetailsArgs: employeeDetailsArgs),
              );
            }));

      case Routes.modifyEmployeeRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final modifyEmployeeArgs =
                  routeSettings.arguments as ModifyEmployeeArgs;

              return BlocProvider.value(
                value: modifyEmployeeArgs.employeeCubit,
                child: ModifyEmployeeScreen(
                    modifyEmployeeArgs: modifyEmployeeArgs),
              );
            }));

      case Routes.modifyTeamRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final modifyTeamArgs = routeSettings.arguments as ModifyTeamArgs;

              return BlocProvider.value(
                value: modifyTeamArgs.teamCubit,
                child: ModifyTeamScreen(modifyTeamArgs: modifyTeamArgs),
              );
            }));

      case Routes.teamDescriptionRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final description = routeSettings.arguments as String;

              return TeamDescriptionScreen(description: description);
            }));

      case Routes.employeePickerRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final employeePickerArgs =
                  routeSettings.arguments as EmployeePickerArgs;

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) {
                      return di.sl<EmployeeCubit>();
                    },
                  ),
                  BlocProvider.value(
                    value: employeePickerArgs.teamMembersCubit,
                  ),
                ],
                child: EmployeePickerScreen(
                    employeePickerArgs: employeePickerArgs),
              );
            }));

      case Routes.teamsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) {
                      return di.sl<TeamCubit>()
                        ..fetchTeams(refresh: true, isWebPagination: true);
                    },
                  ),
                  BlocProvider(
                    create: (context) {
                      return di.sl<TeamMembersCubit>();
                    },
                  ),
                ],
                child: const TeamsScreen(),
              );
            }));

      case Routes.teamsDetailsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final teamDetailsArgs =
                  routeSettings.arguments as TeamDetailsArgs;

              final teamMembersFiltersModel = TeamMembersFiltersModel.initial()
                  .copyWith(
                      teamId: Wrapped.value(teamDetailsArgs.teamModel.teamId));

              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: teamDetailsArgs.teamCubit,
                  ),
                  BlocProvider(
                      create: (context) => di.sl<TeamMembersCubit>()
                        ..updateFilter(teamMembersFiltersModel)
                        ..fetchTeamMembers(refresh: true)),
                ],
                child: TeamDetailsScreen(teamDetailsArgs: teamDetailsArgs),
              );
            }));

      case Routes.eventsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final eventsArgs = routeSettings.arguments as EventsArgs;

              return BlocProvider(
                create: (context) {
                  return di.sl<EventCubit>()
                    ..updateCurrentSelectedEvent(eventsArgs.eventModel)
                    ..getAllEventsByNameLike();
                },
                child: EventsScreen(eventsArgs: eventsArgs),
              );
            }));

      case Routes.sourcesRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final sourcesArgs = routeSettings.arguments as SourcesArgs;

              return BlocProvider(
                create: (context) {
                  return di.sl<SourceCubit>()
                    ..setSelectedSources(
                        sourcesArgs.selectedSourcesNames != null &&
                                sourcesArgs.selectedSourcesNames!.isNotEmpty
                            ? sourcesArgs.selectedSourcesNames!
                            : [])
                    ..getAllSourcesByNameLike();
                },
                child: SourcesScreen(sourcesArgs: sourcesArgs),
              );
            }));

      case Routes.unitTypesRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final unitTypesArgs = routeSettings.arguments as UnitTypesArgs;

              return BlocProvider(
                create: (context) {
                  return di.sl<UnitTypeCubit>()
                    ..setSelectedUnitTypes(
                        unitTypesArgs.selectedUnitTypesNames != null &&
                                unitTypesArgs.selectedUnitTypesNames!.isNotEmpty
                            ? unitTypesArgs.selectedUnitTypesNames!
                            : [])
                    ..getAllUnitTypesByNameLike();
                },
                child: UnitTypesScreen(unitTypesArgs: unitTypesArgs),
              );
            }));

      case Routes.modifyRole:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final roleModel = routeSettings.arguments as RoleModel?;

              return BlocProvider(
                create: (context) {
                  return di.sl<PermissionCubit>()
                    ..getAllPermissionsByNameLike();
                },
                child: ModifyRoleScreen(roleModel: roleModel),
              );
            }));

      case Routes.customerLogsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) {
                      return di.sl<CustomerLogsCubit>()
                        ..fetchCustomerLogs(isWebPagination: true, refresh: true);
                    },
                  ),

                  BlocProvider(
                    create: (context) {
                      return di.sl<TeamMembersCubit>();
                    },
                  ),

                  BlocProvider(
                    create: (context) {
                      return di.sl<CustomerCubit>();
                    },
                  ),

                  BlocProvider(
                    create: (context) {
                      return di.sl<EmployeeCubit>();
                    },
                  ),

                ],
                child: const CustomerLogsScreen(),
              );

            }));

      case Routes.globalReportsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              return BlocProvider(
                create: (context) {
                  return di.sl<GlobalReportsCubit>()
                    ..fetchGlobalReports();
                },
                child: const GlobalReportsScreen(),
              );
            }));


      case Routes.customerTableConfigRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              final customerCubit = routeSettings.arguments as CustomerCubit;

              return BlocProvider.value(
                value: customerCubit,
                child:  CustomerTableConfigScreen(customerCubit: customerCubit,),
              );
            }));


      case Routes.developersRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              final developersArgs = routeSettings.arguments as DevelopersArgs;

              return BlocProvider(
                create: (context) {
                  return di.sl<DeveloperCubit>()..setSelectedDevelopers(developersArgs.selectedDevelopersNames ?? [])
                    ..setSelectedProjects(developersArgs.selectedProjectsNames ?? [])
                    ..getAllDevelopersByNameLike();
                },
                child: DevelopersScreen(developersArgs: developersArgs,),
              );
            }));


      case Routes.projectsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              final projectsArgs = routeSettings.arguments as ProjectsArgs;

              return BlocProvider(
                create: (context) {
                  return di.sl<ProjectCubit>()..setSelectedProjects(projectsArgs.selectedProjectsNames ?? [])
                    ..getAllProjectsWithFilters(ProjectFilters(
                        developerId: projectsArgs.developerModel.developerId
                    ));
                },
                child: ProjectsScreen(projectsArgs: projectsArgs,),
              );

            }));


      case Routes.ownReportsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {

              return BlocProvider(
                create: (context) {
                  return di.sl<OwnReportsCubit>()..fetchEmployeeReports();
                },
                child: const OwnReportsScreen(),
              );

            }));


      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: ((context) => const Scaffold(
              body: Center(
                child: Text(AppStrings.noRouteFound),
              ),
            )));
  }
}
