import 'package:get/get.dart';

import '/app/pages/home/controllers/home_controller.dart';
import '/app/pages/root/controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<RootController>(
        RootController.new,
        fenix: true,
      )
      ..lazyPut<HomeController>(
        HomeController.new,
        fenix: true,
      );
  }
}
