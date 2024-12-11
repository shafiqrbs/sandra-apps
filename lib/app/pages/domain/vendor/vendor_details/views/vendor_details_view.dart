import 'package:sandra/app/core/importer.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/domain/vendor/vendor_details/controllers/vendor_details_controller.dart';

//ignore: must_be_immutable
class VendorDetailsView extends BaseView<VendorDetailsController> {
  VendorDetailsView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
