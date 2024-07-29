import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import 'common_text.dart';

class PageBackButton extends StatelessWidget {
  final String? pageTitle;
  const PageBackButton({
    required this.pageTitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
          text: pageTitle??'',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
