import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';
import '/app/core/core_model/setup.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/responsive.dart';
import '/app/core/values/app_dimension.dart';

class LanguageController extends BaseController {}

class LanguageChangeDropDown extends StatelessWidget with AppDimension {
  final colorSchema = ColorSchema();
  final BaseController gc = Get.put(LanguageController());
  LanguageChangeDropDown({super.key});

  final setUp = SetUp();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Get.height * .04,
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: colorSchema.primaryColor50,
          borderRadius: BorderRadius.circular(
            containerBorderRadius,
          ),
        ),
        child: DropdownButton(
          value: gc.dropDownValue.value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: gc.langItems.map(
            (String langItems) {
              return DropdownMenuItem(
                value: langItems,
                child: Text(
                  langItems.tr,
                  style: TextStyle(
                    fontSize: mediumTFSize,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (String? newValue) {
            gc.dropDownValue.value = newValue!;
            if (kDebugMode) {
              print('Language');
              print(gc.dropDownValue.value);
            }

            if (gc.dropDownValue.value == 'english') {
              setUp.lang = 'en';
              Get.updateLocale(
                const Locale('en', 'EN'),
              );
            } else if (gc.dropDownValue.value == 'bangla') {
              setUp.lang = 'bn';
              Get.updateLocale(
                const Locale('bn', 'BN'),
              );
            }
          },
          borderRadius: BorderRadius.circular(
            containerBorderRadius,
          ),
          underline: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
