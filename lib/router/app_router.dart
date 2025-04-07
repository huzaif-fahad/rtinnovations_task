import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtinnovations_task/features/employee_home/logic/employee_bloc.dart';
import 'package:rtinnovations_task/features/employee_home/view/add_employee.dart';
import 'package:rtinnovations_task/features/employee_home/view/employee_home.dart';
import 'package:rtinnovations_task/features/splash_screen.dart';

import '../features/employee_home/controllers/emp_controller.dart';
import 'app_middleware.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final AppRouter _appRouter = AppRouter._internal();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  late GoRouter goRouter;

  factory AppRouter() {
    return _appRouter;
  }
  AppRouter._internal();

  List<RouteBase> get _routes {
    return <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
        name: 'splash',
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (context) => EmployeesBloc(),
            lazy: false,
            child: const EmployeeHome(),
          );
        },
        name: 'home',
      ),
      GoRoute(
        path: '/add-empl',
        builder: (BuildContext context, GoRouterState state) {
          return PopScope(
            onPopInvokedWithResult: (didPop, d) {
              if (didPop) {
                // This function will be called when popping back from add-empl to home
                print('Navigated back from AddEmployee to EmployeeHome');

                print('Result: $d');
                // You can add additional logic here if needed
              }
              return;
            },
            child: BlocProvider(
              create: (context) => EmployeesBloc(),
              lazy: false,
              child: AddEmployee(
                controller: state.extra as EmployeeController,
              ),
            ),
          );
        },
        name: 'add-empl',
      ),
    ];
  }

  void init() {
    goRouter = GoRouter(
      initialLocation: '/',
      routes: _routes,
      navigatorKey: navigatorKey,
      redirect: AppMiddleware.bind,
    );
    // GoRouter.optionURLReflectsImperativeAPIs = true;
  }
}
