
// @dart=2.9
import 'package:flutter/material.dart';
import 'app.dart';
import 'bloc_observer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  BlocOverrides.runZoned(() {
    runApp(const CrmApp());
  },
    blocObserver: AppBlocObserver(),
  );
}
