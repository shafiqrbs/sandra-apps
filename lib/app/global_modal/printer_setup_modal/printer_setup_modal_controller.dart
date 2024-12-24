import 'package:sandra/app/core/abstract_controller/printer_controller.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/global_modal/printer_connect_modal_view/printer_connect_modal_view.dart';

enum Buttons {
  printPaperType,
  purchase,
}

class PrinterSetupModalController extends PrinterController {
  final buttons = Rx<Buttons?>(null);
  final isHasPrinter = ValueNotifier(false);
  final printerType = ''.obs;
  final printerNewLine = 0.obs;
  final printNewLineController = TextEditingController();
  final printerTypeList = [
    const DropdownMenuItem(value: '80 mm', child: Text('80 mm')),
    const DropdownMenuItem(value: '58 mm', child: Text('58 mm')),
  ];
  final newLineList = List<DropdownMenuItem<int>>.generate(
    11,
    (index) => DropdownMenuItem(
      value: index,
      child: Text(index.toString()),
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    isHasPrinter.value = await prefs.getHasPrinter();
    printerType.value = await prefs.getPrintPaperType();
    printerNewLine.value = await prefs.getNumberOfPrinterNewLine();
    printNewLineController.text = printerNewLine.value.toString();
  }

  Future<void> setPrinterType(String? value) async {
    if (value != null) {
      printerType.value = value;
      await prefs.setPrintPaperType(
        value,
      );
    }
  }

  Future<void> setPrinterNewLine(int value) async {
    printerNewLine.value = value;
    printNewLineController.text = value.toString();
    await prefs.setNumberOfPrinterNewLine(
      value,
    );
  }

  Future<void> setHasPrinter(bool value) async {
    isHasPrinter.value = value;
    await prefs.setHasPrinter(
      hasPrinter: value,
    );
  }

  void changeButton(Buttons button) {
    if (buttons.value == button) {
      buttons.value = null;
      return;
    }
    buttons.value = button;
  }

  Future<void> showPrinterConnectModal() async {
    await Get.dialog(
      DialogPattern(
        title: appLocalization.printerSetup,
        subTitle: appLocalization.connectYourPrinter,
        child: PrinterConnectModalView(),
      ),
    );
  }
}
