import 'package:sandra/app/core/importer.dart';

import '/app/core/base/base_view.dart';
import '/app/pages/content/privacy_config/controllers/privacy_config_controller.dart';

//ignore: must_be_immutable
class PrivacyConfigView extends BaseView<PrivacyConfigController> {
  PrivacyConfigView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
