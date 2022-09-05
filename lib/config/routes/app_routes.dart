import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/customers/presentation/screens/customers_screen.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_members_filters_model.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/employee_picker_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/modify_team_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/team_details_screen.dart';
import 'package:crm_flutter_project/features/teams/presentation/screens/teams_screen.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/app_strings.dart';
import '../../features/employees/presentation/cubit/employee_cubit.dart';
import '../../features/employees/presentation/screens/employees_screen.dart';
import '../../features/login/presentation/screens/login_screen.dart';
import '../../features/teams/presentation/cubit/team_cubit.dart';
import '../../features/teams/presentation/cubit/team_mmbers/team_members_cubit.dart';

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

//

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
              return const CustomersScreen();
            }));

      case Routes.employeesRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              return BlocProvider(
                create: (context) {
                  return di.sl<EmployeeCubit>()..fetchEmployees(refresh: true);
                },
                child: const EmployeesScreen(),
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

      case Routes.employeePickerRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final employeePickerArgs =
                  routeSettings.arguments as EmployeePickerArgs;

              return BlocProvider(
                create: (context) {
                  return di.sl<EmployeeCubit>();
                },
                child: EmployeePickerScreen(
                    employeePickerArgs: employeePickerArgs),
              );
            }));

      case Routes.teamsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              return BlocProvider(
                create: (context) {
                  return di.sl<TeamCubit>()
                    ..fetchTeams(refresh: true, isWebPagination: true);
                },
                child: const TeamsScreen(),
              );
            }));

      case Routes.teamsDetailsRoute:
        return MaterialPageRoute(
            settings: routeSettings,
            builder: ((context) {
              final teamDetailsArgs =
                  routeSettings.arguments as TeamDetailsArgs;


              final teamMembersFiltersModel = TeamMembersFiltersModel.initial().copyWith(
                teamId: Wrapped.value(teamDetailsArgs.teamModel.teamId)
              );

              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: teamDetailsArgs.teamCubit,
                    child: TeamDetailsScreen(teamDetailsArgs: teamDetailsArgs),
                  ),
                  BlocProvider(
                      create: (context) => di.sl<TeamMembersCubit>()..updateFilter(teamMembersFiltersModel)
                        ..fetchTeamMembers(refresh: true)),

                ],


                child: TeamDetailsScreen(teamDetailsArgs: teamDetailsArgs),
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
