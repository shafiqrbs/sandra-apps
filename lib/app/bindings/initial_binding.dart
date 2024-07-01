import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/session_manager/session_manager.dart';

class InitialBinding implements Bindings {
  @override
  Future<void> dependencies() async {
    await SessionManager().init();
    await initialize();
  }
}
