import 'package:sandra/app/core/importer.dart';

import '/app/my_app.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';
import '/flavors/environment.dart';
import 'app/bindings/initial_binding.dart';
import 'app/core/db_helper/db_helper.dart';
import 'app/core/db_helper/db_tables.dart';
import 'app/core/session_manager/session_manager.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      /// uncomment below 2 lines to set the orientation of the app
      //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

      final EnvConfig devConfig = EnvConfig(
        appName: 'TerminalBD',
        baseUrl: 'https://poskeeper.com/flutter-api/',
        shouldCollectCrashLog: true,
      );

      BuildConfig.instantiate(
        envType: Environment.development,
        envConfig: devConfig,
      );

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
        'endpoint': 'from_main_dev_runZonedGuarded',
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
