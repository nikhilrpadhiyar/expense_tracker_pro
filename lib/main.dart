import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker_pro/core/constants/app_constants.dart';
import 'package:expense_tracker_pro/core/services/notification_service.dart';
import 'package:expense_tracker_pro/core/theme/app_theme.dart';
import 'package:expense_tracker_pro/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:expense_tracker_pro/features/budget/data/models/budget_model.dart';
import 'package:expense_tracker_pro/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:expense_tracker_pro/features/expense/data/models/expense_model.dart';
import 'package:expense_tracker_pro/firebase_options.dart';
import 'package:expense_tracker_pro/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load env
  await dotenv.load();

  // Hive init
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(BudgetModelAdapter());
  await ExpenseLocalDataSourceImpl.openBox();
  await BudgetLocalDataSourceImpl.openBox();

  // GetStorage for settings
  await GetStorage.init();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Notifications
  await NotificationService.instance.init();
  await NotificationService.instance.scheduleMonthlySummary();

  // Restore saved theme
  final box = GetStorage();
  final savedTheme = box.read<String>(AppConstants.keyThemeMode);
  final themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

  runApp(ExpenseTrackerApp(themeMode: themeMode));
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key, required this.themeMode});
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
