import 'package:sandra/app/core/importer.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/intro/splash/controllers/splash_controller.dart';

//ignore: must_be_immutable
class SplashView extends BaseView<SplashController> {
  SplashView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
