import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/global_modal/view_demo_modal/view_demo_modal_controller.dart';

class ViewDemoModalView extends BaseView<ViewDemoModalController> {
  ViewDemoModalView({super.key});

  final falsePadding = 16.0.obs;

  @override
  Widget build(BuildContext context) {
    return GetX<ViewDemoModalController>(
      init: ViewDemoModalController(),
      builder: (controller) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(falsePadding.value),
              decoration: BoxDecoration(
                color: colors.whiteColor,
              ),
              child: Column(
                children: [],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}
