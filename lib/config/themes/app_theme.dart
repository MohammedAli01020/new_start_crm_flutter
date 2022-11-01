
import 'package:crm_flutter_project/core/utils/responsive.dart';
import 'package:flutter/services.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/app_strings.dart';
import '../../core/utils/constants.dart';
import 'package:flutter/material.dart';

ThemeData appTheme() {

  return ThemeData (
      primaryColor: AppColors.primary,
      primarySwatch: Constants.buildMaterialColor(AppColors.primary),
      hintColor: AppColors.hint,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: AppStrings.fontFamily,

      iconTheme: IconThemeData(
        color: AppColors.primary,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android:  ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS:  CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
          TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
          TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),

        },
      ),


    scrollbarTheme: ScrollbarThemeData(
        thickness: Responsive.isDesktopDevice ? MaterialStateProperty.all(10) : null,
        // thumbColor: MaterialStateProperty.all(Colors.blue),
        // radius: const Radius.circular(10),
        // minThumbLength: 100

    ),


      appBarTheme:  const AppBarTheme(
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          centerTitle: true,
          color: Colors.transparent,
          elevation: 0,
          titleTextStyle:  TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 20.0)),

      textTheme:  TextTheme(
        bodyMedium: const TextStyle(
            height: 1.3,
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.w500
        ),
        bodySmall: TextStyle(
            height: 1.3,
            fontSize: 14.0,
            color: AppColors.hint,
            fontWeight: FontWeight.w500
        ),

        labelSmall: TextStyle(
            height: 1.3,
            fontSize: 14.0,
            color: AppColors.hint,
            fontWeight: FontWeight.bold
        ),

        displaySmall: TextStyle(
            height: 1.3,
            fontSize: 16.0,
            color: AppColors.hint,
            fontWeight: FontWeight.w500
        ),

        titleLarge:  const TextStyle(
            height: 1.3,
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),


      )

  );
}


class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }
}