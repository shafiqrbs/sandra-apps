import 'package:sandra/app/core/importer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/utils/static_utility_function.dart';
import 'package:sandra/app/pages/settings/controllers/settings_controller.dart';

import '/app/bindings/initial_binding.dart';
import '/app/core/values/app_colors.dart';
import '/app/routes/app_pages.dart';
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
  bool isDarkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      isDarkMode = await prefs.getIsEnableDarkMode();
    });
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
      darkTheme: ThemeData.dark(),
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
