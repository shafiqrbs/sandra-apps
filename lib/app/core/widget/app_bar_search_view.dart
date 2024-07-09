import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:getx_template/app/core/core_model/voice_recognition.dart';
import '/app/core/base/base_widget.dart';

import 'common_text.dart';

class AppBarSearchView extends BaseWidget {
  final String pageTitle;
  final TextEditingController controller;
  final Function(String value)? onSearch;
  final Function()? onMicTap;
  final Function()? onFilterTap;
  final Function()? onClearTap;
  final bool showSearchView;
  final List<Widget> suffixIcon;
  AppBarSearchView({
    required this.pageTitle,
    required this.controller,
    required this.onSearch,
    required this.onMicTap,
    required this.onFilterTap,
    required this.onClearTap,
    super.key,
    this.showSearchView = false,
    this.suffixIcon = const [],
  });

  @override
  Widget build(BuildContext context) {
    return showSearchView
        ? Container(
            margin: const EdgeInsets.only(left: 2),
            height: textFieldHeight,
            // width: Get.width,
            decoration: BoxDecoration(
              color: colors.backgroundColor,
              borderRadius: BorderRadius.circular(
                containerBorderRadius,
              ),
            ),
            child: TextFormField(
              controller: controller,
              autofocus: true,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: colors.primaryTextColor,
              ),
              cursorColor: colors.formCursorColor,
              onChanged: onSearch,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  TablerIcons.search,
                  color: colors.primaryBaseColor,
                  size: 18,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final voiceRecognition = VoiceRecognition();

                        if (!voiceRecognition.isListening) {
                          await voiceRecognition.startListening(
                            (result) {
                              controller.text = result;
                              if (onSearch != null) {
                                onSearch!(result)!;
                              }
                            },
                          );
                        } else {
                          await voiceRecognition.stopListening();
                        }
                      },
                      icon: Icon(
                        TablerIcons.microphone,
                        color: colors.primaryBaseColor,
                      ),
                    ),
                    IconButton(
                      onPressed: onFilterTap,
                      icon: Icon(
                        TablerIcons.filter,
                        color: colors.primaryBaseColor,
                      ),
                    ),
                    IconButton(
                      onPressed: onClearTap,
                      icon: Icon(
                        TablerIcons.x,
                        color: Colors.grey.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                hintText: 'hint'.tr,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.withOpacity(.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    4,
                  ),
                  // Adjust the border radius as needed
                  borderSide: const BorderSide(
                    color: Color(0xFFece2d9),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(
                    color: Color(0xFFf5edeb),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: const BorderSide(
                    color: Color(0xFFf5edeb),
                  ),
                ),
              ),
            ),
          )
        : Row(
            children: [
              InkWell(
                onTap: Get.back,
                child: const Icon(
                  TablerIcons.arrow_left,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 10),
              CommonText(
                text: pageTitle,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ],
          );
  }
}
