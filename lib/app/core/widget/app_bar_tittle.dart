import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import '/app/core/base/base_widget.dart';

import 'common_text.dart';

class AppBarTittle extends BaseWidget {
  final String pageTitle;
  AppBarTittle({
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
          text: pageTitle,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
