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
    return InkWell(
      onTap: Get.back,
      child: Row(
        children: [
          const Icon(
            TablerIcons.chevron_left,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CommonText(
              text: pageTitle??'',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
