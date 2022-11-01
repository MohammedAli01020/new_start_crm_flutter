
// @dart=2.9
import 'package:crm_flutter_project/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'bloc_observer.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  if (Responsive.isDesktopDevice) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {

      await windowManager.setTitleBarStyle(
        TitleBarStyle.normal,
        windowButtonVisibility: true,
      );

      await windowManager.setSize(const Size(755, 545));
      await windowManager.setMinimumSize(const Size(350, 600));
      await windowManager.center();
      await windowManager.show();
      await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }

  BlocOverrides.runZoned(() {
    runApp(const CrmApp());
  },
    blocObserver: AppBlocObserver(),
  );
}
