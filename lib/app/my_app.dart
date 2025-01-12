import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sandra/app/core/importer.dart';

import '/app/bindings/initial_binding.dart';
import '/flavors/build_config.dart';
import '/flavors/env_config.dart';

class MyApp extends StatefulWidget {
  final String lang;

  const MyApp({
    required this.lang,
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final EnvConfig _envConfig = BuildConfig.instance.config;

  @override
  void initState() {
    super.initState();
    Get.put(HelperController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: _envConfig.appName,
      initialRoute: AppPages.initial,
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: _getSupportedLocal(),
      locale: Locale(widget.lang),
      theme: ThemeData.light(),
      themeMode: ThemeMode.light,
      //darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }

  List<Locale> _getSupportedLocal() {
    return [
      const Locale('en', ''),
      const Locale('bn', ''),
    ];
  }
}
