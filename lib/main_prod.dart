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

      /// uncomment below 2 lines to set the orientation of the app
      //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      final EnvConfig prodConfig = EnvConfig(
        appName: 'TerminalBD',
        baseUrl: 'https://poskeeper.com/flutter-api/',
        shouldCollectCrashLog: true,
      );

      BuildConfig.instantiate(
        envType: Environment.production,
        envConfig: prodConfig,
      );

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

      await InitialBinding().dependencies();
      final prefs = SessionManager();
      final lang = await prefs.getLanguage();

      runApp(
        MyApp(
          lang: lang,
        ),
      );
    },
    (exception, stackTrace) async {
      final createdAt = DateTime.now().toString();
      final error = {
        'endpoint': 'from_main_prod_runZonedGuarded',
        'created_at': createdAt,
        'error_text': exception.toString(),
        'stack_trace': stackTrace.toString(),
      };
      final dbHelper = DbHelper.instance;
      await dbHelper.insertList(
        deleteBeforeInsert: false,
        tableName: DbTables().tableLogger,
        dataList: [error],
      );
    },
  );
}
