import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:getx_template/app/core/base/base_widget.dart';

import 'app_bar_button.dart';

class AddButton extends BaseWidget {
  AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      buttonName: null,
      onTap: () {},
      leftIcon: TablerIcons.library_plus,
      buttonBGColor: colors.tertiaryLiteColor,
      iconColor: colors.primaryBaseColor,
    );
  }
}
