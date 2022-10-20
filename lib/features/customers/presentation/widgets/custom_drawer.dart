import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/core/utils/wrapper.dart';
import 'package:crm_flutter_project/features/customers/presentation/cubit/customer_cubit.dart';
import 'package:crm_flutter_project/features/developers_and_projects/presentation/screens/developers_screen.dart';
import 'package:crm_flutter_project/features/events/presentation/screens/events_screen.dart';
import 'package:crm_flutter_project/features/login/presentation/cubit/theme/theme_cubit.dart';
import 'package:crm_flutter_project/features/unit_types/presentation/screens/unit_types_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_list_tile.dart';
import '../../../login/presentation/cubit/login_cubit.dart';
import '../../../sources/presentation/screens/sources_screen.dart';

class CustomDrawer extends StatelessWidget {
  final CustomerCubit customerCubit;

  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;
   CustomDrawer({Key? key, required this.customerCubit}) : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? _extraScrollSpeed
                  : -_extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }


  void _getPageCustomers({bool refresh = false, required BuildContext context}) {
    BlocProvider.of<CustomerCubit>(context).fetchCustomers(refresh: refresh);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state is EndGettingEmployee) {
                    if (Constants.currentEmployee!.permissions
                        .contains(AppStrings.viewAllLeads)) {
                      customerCubit.updateFilter(
                          customerCubit.customerFiltersModel.copyWith(
                              teamId: const Wrapped.value(null),
                              employeeId: const Wrapped.value(null),
                              lastEventIds: const Wrapped.value(null),
                              customerTypes:
                                  Wrapped.value(CustomerTypes.ALL.name)));

                      _getPageCustomers(refresh: true, context: context);
                    } else if (Constants.currentEmployee!.permissions
                            .contains(AppStrings.viewTeamLeads) &&
                        Constants.currentEmployee!.teamId != null) {
                      customerCubit.updateFilter(
                          customerCubit.customerFiltersModel.copyWith(
                              teamId: Wrapped.value(
                                  Constants.currentEmployee?.teamId),
                              employeeId: Wrapped.value(
                                  Constants.currentEmployee?.employeeId),
                              lastEventIds: const Wrapped.value(null),
                              customerTypes: Wrapped.value(
                                  CustomerTypes.ME_AND_TEAM.name)));
                      _getPageCustomers(refresh: true, context: context);
                    } else if (Constants.currentEmployee!.permissions
                        .contains(AppStrings.viewMyAssignedLeads)) {
                      customerCubit.updateFilter(
                          customerCubit.customerFiltersModel.copyWith(
                              teamId: const Wrapped.value(null),
                              employeeId: Wrapped.value(
                                  Constants.currentEmployee?.employeeId),
                              lastEventIds: const Wrapped.value(null),
                              customerTypes:
                                  Wrapped.value(CustomerTypes.ME.name)));

                      _getPageCustomers(refresh: true, context: context);
                    } else if (Constants.currentEmployee!.permissions
                        .contains(AppStrings.viewNotAssignedLeads)) {
                      customerCubit.updateFilter(
                          customerCubit.customerFiltersModel.copyWith(
                              teamId: const Wrapped.value(null),
                              employeeId: const Wrapped.value(null),
                              lastEventIds: const Wrapped.value(null),
                              customerTypes: Wrapped.value(
                                  CustomerTypes.NOT_ASSIGNED.name)));
                      _getPageCustomers(refresh: true, context: context);
                    } else {
                      customerCubit.updateCustomers([]);
                    }

                    Navigator.pop(context);
                    Constants.showToast(
                        msg: "تم تحدث بينات المستخدم والاذونات",
                        color: Colors.green,
                        context: context);
                  }

                  if (state is GettingEmployeeError) {
                    Constants.showToast(
                        msg: "حدث خطأ اثناء تحديث بيانات المستخدم " + state.msg,
                        context: context);
                  }
                },
                builder: (context, state) {
                  final cubit = LoginCubit.get(context);
                  return IconButton(
                    onPressed: () {
                      cubit.updateCurrentUser();
                    },
                    icon: state is StartGettingEmployee
                        ? const SizedBox(
                            width: 15.0,
                            height: 15.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ))
                        : const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 50.0,
                          ),
                  );
                },
              ),
              accountName: Text(Constants.currentEmployee!.fullName),
              accountEmail: Text(Constants.currentEmployee!.username)),
          BlocConsumer<ThemeCubit, ThemeState>(
            listener: (context, state) {
              if (state is ChangeThemeToLightError) {
                Constants.showToast(msg: "ChangeThemeToLightError: " + state.msg, context: context);
              }

              if (state is ChangeThemeToDarkError) {
                Constants.showToast(msg: "ChangeThemeToDarkError: " + state.msg, context: context);
              }
            },
            builder: (context, state) {
              final themeCubit = ThemeCubit.get(context);
              return CustomListTile(
                title: 'الوضع',
                subTitle: Constants.isDark ? "الليلي" : "الصباحي",
                trailing: Constants.isDark ? const Icon(Icons.brightness_4) : const Icon(Icons.brightness_2),
                onTapCallback: () {
                  if (Constants.isDark) {
                    themeCubit.changeThemeToLight();
                  } else {
                    themeCubit.changeThemeToDark();
                  }
                },
              );
            },
          ),
          if (Constants.currentEmployee!.permissions
                  .contains(AppStrings.viewEmployees) ||
              Constants.currentEmployee!.permissions
                  .contains(AppStrings.viewCreatedEmployees))
            CustomListTile(
              title: 'الموظفون',
              trailing: const Icon(Icons.people),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.employeesRoute);
              },
            ),
          if (Constants.currentEmployee!.permissions
                  .contains(AppStrings.viewAllGroups) ||
              Constants.currentEmployee!.permissions
                  .contains(AppStrings.viewOwnGroups))
            CustomListTile(
              title: 'المجموعات',
              trailing: const Icon(Icons.group_add),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.teamsRoute);
              },
            ),
          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewEvents))
            CustomListTile(
              title: 'الاحداث',
              trailing: const Icon(Icons.event),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.eventsRoute,
                    arguments:
                        EventsArgs(eventType: EventType.VIEW_EVENTS.name));
              },
            ),
          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewSources))
            CustomListTile(
              title: 'المصادر',
              trailing: const Icon(Icons.perm_media_outlined),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.sourcesRoute,
                    arguments:
                        SourcesArgs(sourceType: SourceType.VIEW_SOURCES.name));
              },
            ),
          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewUnitTypes))
            CustomListTile(
              title: 'الاهتمامات',
              trailing: const Icon(Icons.favorite),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.unitTypesRoute,
                    arguments: UnitTypesArgs(
                        unitTypesType: UnitTypesType.VIEW_UNIT_TYPES.name));
              },
            ),
          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewAllCustomerLogs))
            CustomListTile(
              title: 'سجلات العملاء',
              trailing: const Icon(Icons.archive),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.customerLogsRoute);
              },
            ),
          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewAllStatistics))
            CustomListTile(
              title: 'احصائيات التعينات',
              trailing: const Icon(Icons.description),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.globalReportsRoute);
              },
            ),
          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewDevelopers))
            CustomListTile(
              title: 'المطورين والمشاريع',
              trailing: const Icon(Icons.apartment_sharp),
              onTapCallback: () {
                Navigator.popAndPushNamed(context, Routes.developersRoute,
                    arguments: DevelopersArgs(
                        developerType: DevelopersType.VIEW_DEVELOPERS.name));
              },
            ),
          CustomListTile(
            title: 'اعدادات جدول العملاء',
            trailing: const Icon(Icons.settings),
            onTapCallback: () {
              Navigator.popAndPushNamed(
                  context, Routes.customerTableConfigRoute,
                  arguments: customerCubit);
            },
          ),
          CustomListTile(
            title: 'تقاريري',
            trailing: const Icon(Icons.stacked_line_chart),
            onTapCallback: () {
              Navigator.popAndPushNamed(context, Routes.ownReportsRoute);
            },
          ),

          if (Constants.currentEmployee!.permissions
              .contains(AppStrings.viewPreDefinedRoles))
          CustomListTile(
            title: 'الادورا والاذونات',
            trailing: const Icon(Icons.accessibility_sharp),
            onTapCallback: () {
              Navigator.popAndPushNamed(context, Routes.preDefinedRolesRoute,
              arguments: PreDefinedRoleType.VIEW_PRE_DEFINED_ROLES.name);
            },
          ),

          BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LogoutError) {
                Constants.showToast(
                    msg: "LogoutError: " + state.msg, context: context);
              }

              if (state is EndLogout) {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.initialRoute, (route) => false);
              }
            },
            builder: (context, state) {
              final cubit = LoginCubit.get(context);
              return ListTile(
                title: const Text("خروج"),
                trailing: const Icon(Icons.logout),
                onTap: () {
                  cubit.logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
