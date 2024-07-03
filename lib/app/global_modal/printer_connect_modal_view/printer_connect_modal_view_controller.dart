import '/app/core/abstract_controller/printer_controller.dart';

class PrinterConnectModalViewController extends PrinterController {
  @override
  Future<void> onInit() async {
    await getBluetoothList();
    return super.onInit();
  }
}
