import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:getx_template/app/core/base/base_widget.dart';

import 'app_bar_button.dart';

class SearchButton extends BaseWidget {
  final VoidCallback? onTap;
  SearchButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      buttonName: null,
      onTap: onTap ?? () {},
      leftIcon: TablerIcons.search,
      iconColor: colors.primaryBaseColor,
      buttonBGColor: Colors.white,
      buttonTextColor: colors.primaryBaseColor,
    );
  }
}
