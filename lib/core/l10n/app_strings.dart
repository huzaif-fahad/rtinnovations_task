import 'package:flutter/foundation.dart';

import 'models/app_localization.dart';
import 'package:flutter/material.dart' show BuildContext, Localizations;

class AppStrings {
  static final AppStrings _appStrings = AppStrings._i();

  AppStrings._i();

  factory AppStrings() => _appStrings;

  // Static method to be used with LocalizationsDelegate
  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  static AppStrings ofUntranslated(BuildContext context) {
    return _appStrings;
  }

  static const String appName = 'Realtime Innovations Task';
  static const String appVersion = '1.0.0';
  // default language data
  String defaultLanugageName = 'English';

  String defaultLanguageCode = 'en';

  // Errors
  String get stateNotHandled => kDebugMode
      ? 'State not handled in the widget. Please check the state and handle it properly.'
      : 'Something went wrong. Please try again later.';

  String get errorOccured => kDebugMode
      ? 'An error occurred. Please check the logs for more details.'
      : 'An error occurred. Please try again later.';

  String currentEmployees = 'Current Employees';
  String previousEmployees = 'Previous Employees';
  String addEmployeeTitle = 'Add Employee Details';
  String editEmployeeTitle = 'Edit Employee Details';
  String employeeListTitle = 'Employee List';
  String swipeToDelete = 'Swipe left to delete';
  String emptyRecords = 'No employee records found';

  // define app strings from here
}
