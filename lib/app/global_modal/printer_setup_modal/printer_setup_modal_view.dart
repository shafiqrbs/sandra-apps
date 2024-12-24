import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:settings_ui/settings_ui.dart';

import 'printer_setup_modal_controller.dart';

class PrinterSetupModalView extends BaseView<PrinterSetupModalController> {
  PrinterSetupModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<PrinterSetupModalController>(
      init: PrinterSetupModalController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPrinter(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrinter() {
    return Column(
      children: [
        dividerWidget(),
        Row(
          children: [
            Icon(
              TablerIcons.printer,
              color: colors.primaryColor700,
              size: 24,
            ),
            8.width,
            Text(
              appLocalization.printer.toUpperCase(),
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primaryColor700,
              ),
            ),
          ],
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
          ),
          child: Column(
            children: [
              10.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.printer,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isHasPrinter,
                    onChanged: (value) async {
                      await controller.setHasPrinter(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isHasPrinter.value,
                  ),
                ],
              ),
              16.height,
              Column(
                children: [
                  _buildSettingButton(
                    text: appLocalization.printPaperType,
                    //icon: TablerIcons.printer,
                    trailingIcon: TablerIcons.chevron_right,
                    isOpen: controller.buttons.value == Buttons.printPaperType,
                    onTap: () {
                      controller.changeButton(Buttons.printPaperType);
                    },
                  ),
                  if (controller.buttons.value != Buttons.printPaperType)
                    16.height,
                  if (controller.buttons.value == Buttons.printPaperType)
                    Container(
                      margin: const EdgeInsets.only(
                        top: 8,
                      ),
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      color: Colors.white,
                      width: Get.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.printerTypeList.length,
                        itemBuilder: (context, index) {
                          final item = controller.printerTypeList[index];

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 16,
                            ),
                            child: Obx(
                              () {
                                return _buildCustomRadioButton(
                                  title: item.value ?? '',
                                  isSelected: controller.printerType.value ==
                                      item.value,
                                  onTap: () {
                                    controller.setPrinterType(item.value);
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.printEndNewLine,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    height: textFieldHeight,
                    child: TextFormField(
                      controller: controller.printNewLineController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        controller.setPrinterNewLine(int.tryParse(value) ?? 0);
                      },
                      onFieldSubmitted: (value) {
                        controller.setPrinterNewLine(int.tryParse(value) ?? 0);
                      },
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '1',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colors.primaryBlackColor,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        filled: true,
                        fillColor: colors.primaryColor50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: colors.secondaryColor100,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: colors.secondaryColor100,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: colors.secondaryColor100,
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*if (controller.printerType.value.isEmpty)
                        const CircularProgressIndicator()
                      else
                        DropdownButton<int>(
                          value: controller.printerNewLine.value,
                          items: controller.newLineList,
                          onChanged: (value) async {
                            if (value == null) return;
                            controller.setPrinterNewLine(value);
                          },
                        ),*/
                ],
              ),
            ],
          ),
        ),
        16.height,
        SettingsList(
          shrinkWrap: true,
          sections: [
            SettingsSection(
              tiles: [
                SettingsTile.navigation(
                  onPressed: (BuildContext context) async {
                    await controller.showPrinterConnectModal();
                  },
                  leading: Obx(
                    () => Icon(
                      TablerIcons.printer,
                      color: controller.connected.value
                          ? colors.greenColor
                          : colors.redColor,
                    ),
                  ),
                  title: Text(
                    appLocalization.printer,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: const Icon(TablerIcons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomRadioButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? colors.primaryColor700
                    : colors.secondaryColor200,
              ),
            ),
            child: isSelected
                ? Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primaryColor700,
                    ),
                  )
                : Container(),
          ),
          16.width,
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: [
        8.height,
        Container(
          height: 1,
          color: colors.secondaryColor100,
        ),
        8.height,
      ],
    );
  }

  Widget _buildSettingButton({
    required String text,
    required IconData trailingIcon,
    required bool isOpen,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: colors.solidBlackColor,
              size: 24,
            ),
          if (icon != null) 8.width,
          Container(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          Icon(
            isOpen ? TablerIcons.chevron_down : trailingIcon,
            color: colors.solidBlackColor,
          ),
        ],
      ),
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
