import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';
import 'package:sandra/app/core/importer.dart';

import '/app/core/values/app_colors.dart';
import '/app/core/widget/loading.dart';
import '/flavors/build_config.dart';

final regexDouble = FilteringTextInputFormatter.allow(
  RegExp(r'^[0-9]*\.?[0-9]*'),
);
final regexInteger = FilteringTextInputFormatter.allow(
  RegExp('^[0-9]*'),
);

abstract class BaseView<Controller extends BaseController>
    extends GetView<Controller> {
  BaseView({super.key});

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

  final Logger logger = BuildConfig.instance.config.logger;
  ColorSchema colors = ColorSchema();

  final loaderColor = const Color(0xFF00AEEF);

  Widget body(BuildContext context);

  PreferredSizeWidget? appBar(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: [
          annotatedRegion(context),
          Obx(
            () => controller.pageState == PageState.loading
                ? Container()
                : Container(),
          ),
          Obx(
            () => controller.errorMessage.isNotEmpty
                ? showErrorSnackBar(controller.errorMessage)
                : Container(),
          ),
          Container(),
        ],
      ),
    );
  }

  Widget annotatedRegion(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        //Status bar color for android
        statusBarColor: statusBarColor(),
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Material(
        color: Colors.transparent,
        child: pageScaffold(context),
      ),
    );
  }

  Widget pageScaffold(BuildContext context) {
    return Scaffold(
      //sets ios status bar color
      backgroundColor: pageBackgroundColor(),
      key: globalKey,
      appBar: appBar(context),
      floatingActionButton: floatingActionButton(),
      body: pageContent(context),
      bottomNavigationBar: bottomNavigationBar(),
      floatingActionButtonLocation: floatingActionButtonLocation(),
      drawer: drawer(),
    );
  }

  Widget pageContent(BuildContext context) {
    return SafeArea(
      child: body(context),
    );
  }

  Widget showErrorSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
      },
    );

    return Container();
  }

  void showToast(String message) {
    toast(message);
  }

  FloatingActionButtonLocation? floatingActionButtonLocation() {
    return FloatingActionButtonLocation.centerDocked;
  }

  Color? pageBackgroundColor() {
    return Get.isDarkMode ? colors.blackColor : colors.whiteColor;
  }

  Color statusBarColor() {
    return AppColors.pageBackground;
  }

  Widget? floatingActionButton() {
    return null;
  }

  Widget? bottomNavigationBar() {
    return null;
  }

  Widget? drawer() {
    return null;
  }

  Widget _showLoading() {
    return const Loading();
  }

  Widget listViewRetryView({
    onRetry,
  }) {
    return InkWell(
      onTap: onRetry,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        width: Get.width,
        decoration: BoxDecoration(
          color: colors.primaryColor500,
          borderRadius: BorderRadius.circular(containerBorderRadius),
          border: Border.all(
            color: colors.primaryColor700,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          appLocalization.retry,
          style: TextStyle(
            color: colors.solidBlackColor,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
