import 'dart:ui';

import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/locale/app_localizations_setup.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/app_strings.dart';
import 'features/login/presentation/cubit/login_cubit.dart';
import 'features/login/presentation/cubit/theme/theme_cubit.dart';
import 'injection_container.dart' as di;


class CrmApp extends StatelessWidget {
  const CrmApp({Key? key}) : super(key: key);

  // myapp
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<LoginCubit>()..init()),
        BlocProvider(
            create: (context) => di.sl<ThemeCubit>()..fetchCurrentTheme()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
            return MaterialApp(
              restorationScopeId: 'root',
              debugShowCheckedModeBanner: false,
              scrollBehavior: MyCustomScrollBehavior(),
              title: AppStrings.appName,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              theme: appTheme(),
              themeMode: Constants.isDark ? ThemeMode.dark : ThemeMode.light,
              darkTheme: ThemeData.dark(),
              locale: const Locale("ar"),
              supportedLocales: AppLocalizationsSetup.supportedLocales,
              localeResolutionCallback:
              AppLocalizationsSetup.localeResolutionCallback,
              localizationsDelegates:
              AppLocalizationsSetup.localizationsDelegates,
            );


        },
      ),
    );
  }


}

class MyCustomScrollBehavior extends MaterialScrollBehavior {

  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
