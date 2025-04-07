import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rtinnovations_task/core/l10n/app_strings.dart';
import 'router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, Consumer;
import 'core/configuration/app_configuration.dart';
import 'core/themes/theme_handler.dart';
import 'utils/responsive/responsive_util.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppConfiguration.i.initializeApp();

    runApp(const MyApp());
  }, (error, stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      print("\n");
      print('StackTrace: $stackTrace');
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppConfiguration(),
      child: Consumer<AppConfiguration>(
        builder: (context, config, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            builder: (context, child) {
              ResponsiveUtil().init(context);
              return child ?? const SizedBox();
            },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: ThemeHandler.currentTheme.primaryColor,
              ),
              useMaterial3: true,
              fontFamily: ThemeHandler.currentTheme.fontFamily,
            ),
            routerConfig: AppRouter().goRouter,
          );
        },
      ),
    );
  }
}
