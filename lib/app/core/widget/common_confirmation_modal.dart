import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/responsive.dart';

class CommonConfirmationModal extends BaseWidget {
  final String title;

  CommonConfirmationModal({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorSchema = ColorSchema();
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100.pw,
              height: 30.ph,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  dimensions.containerBorderRadius,
                ),
              ),
              padding: EdgeInsets.only(top: 05.ph),
              margin: EdgeInsets.only(
                top: 8.ph,
                left: 4,
                right: 4,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back(result: false);
                        },
                        child: Container(
                          height: dimensions.buttonHeight,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            left: 32,
                            right: 32,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              dimensions.containerBorderRadius,
                            ),
                            color: colorSchema.backgroundColor,
                            border: Border.all(
                              color: colorSchema.primaryBaseColor,
                            ),
                          ),
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: colorSchema.primaryBaseColor,
                            ),
                          ),
                        ),
                      ),
                      15.width,
                      InkWell(
                        onTap: () {
                          Get.back(result: true);
                        },
                        child: Container(
                          height: dimensions.buttonHeight,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                            left: 32,
                            right: 32,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              dimensions.containerBorderRadius,
                            ),
                            color: colorSchema.primaryBaseColor,
                          ),
                          child: const Text(
                            'Yes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: colorSchema.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: colorSchema.moduleBodyColor,
                    child: ClipOval(
                      child: Image.asset('assets/images/app_logo.png'),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 9.ph,
              child: InkWell(
                onTap: Get.back,
                child: Icon(
                  TablerIcons.x,
                  color: colorSchema.formClearIconColor,
                  size: dimensions.closeIconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
