import 'package:sandra/app/core/importer.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';
import 'app/bindings/initial_binding.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await _initializeApp();
    },
    _handleError,
  );
}

Future<void> _initializeApp() async {
  // Set preferred orientation (Uncomment if required)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize environment
  _initializeEnvironment();

  // Initialize database themes
  await _setupThemes();

  // Initialize dependencies and preferences
  await InitialBinding().dependencies();

  final prefs = SessionManager();
  final lang = await prefs.getLanguage();

  // Setup selected theme
  await _setupTheme(prefs);

  // Start the application
  runApp(MyApp(lang: lang));
}

/// Initializes environment configuration
void _initializeEnvironment() {
  final devConfig = EnvConfig(
    appName: 'TerminalBD',
    baseUrl: 'https://capsulebd.com/flutter-api/',
    shouldCollectCrashLog: true,
  );

  BuildConfig.instantiate(
    envType: Environment.development,
    envConfig: devConfig,
  );
}

/// Sets up theme data in the database if not already present
Future<void> _setupThemes() async {
  try {
    final themeCount = await db.getItemCount(
      tableName: dbTables.tableColorPlate,
      limit: 1,
    );

    if (themeCount == 0) {
      final themeList = await services.getThemeList();
      await db.insertList(
        deleteBeforeInsert: true,
        tableName: dbTables.tableColorPlate,
        dataList: themeList,
      );
    }
  } catch (e, s) {
    _logDebug('Error in _setupThemes: $e');
    await _handleError(e, s);
  }
}

/// Sets up the application's theme
Future<void> _setupTheme(SessionManager prefs) async {
  try {
    final selectedTheme = await prefs.getSelectedThemeName();
    _logDebug('Selected Theme: $selectedTheme');

    if (selectedTheme != null) {
      final theme = await db.getAllWhr(
        tbl: dbTables.tableColorPlate,
        where: 'theme_name = ?',
        whereArgs: [selectedTheme],
        limit: 1,
      );

      if (theme.isNotEmpty) {
        ColorSchema.fromJson(theme[0]);
        return;
      }
    }

    // Fallback to the first available theme
    final firstTheme = await db.getAll(
      tbl: dbTables.tableColorPlate,
      limit: 1,
    ) as List<Map<String, dynamic>>?;

    final themeData = firstTheme?.firstWhere(
      (theme) => theme['theme_name'] != null,
      orElse: () => {},
    );

    if (themeData != null) {
      await prefs.setSelectedThemeName(
        themeName: themeData['theme_name'],
      );
      ColorSchema.fromJson(themeData);
    }
  } catch (e, s) {
    _logDebug('Error in _setupTheme: $e');
    await _handleError(e, s);
  }
}

/// Handles errors globally
Future<void> _handleError(Object exception, StackTrace stackTrace) async {
  _logDebug('[Error Handler] Exception: $exception');
  _logDebug('[Error Handler] StackTrace: $stackTrace');

  final error = {
    'endpoint': 'from_main_dev_runZonedGuarded',
    'created_at': DateTime.now().toString(),
    'error_text': exception.toString(),
    'stack_trace': stackTrace.toString(),
  };

  // Save error details to the database
  final dbHelper = DbHelper.instance;
  try {
    await dbHelper.insertList(
      deleteBeforeInsert: false,
      tableName: DbTables().tableLogger,
      dataList: [error],
    );
  } catch (dbError) {
    _logDebug('[Error Handler] Failed to log error to the database: $dbError');
  }
}

/// Logs debug messages only in debug mode
void _logDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}
