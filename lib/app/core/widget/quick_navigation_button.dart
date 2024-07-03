import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:getx_template/app/core/base/base_widget.dart';

import 'app_bar_button.dart';

class QuickNavigationButton extends BaseWidget {
  QuickNavigationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      buttonName: null,
      onTap: () => showQuickNavigateBottomSheet(
        context: context,
      ),
      leftIcon: TablerIcons.library_plus,
      buttonBGColor: colors.tertiaryLiteColor,
      iconColor: colors.primaryBaseColor,
    );
  }

  void showQuickNavigateBottomSheet({
    required BuildContext context,
  }) {
    final animationStyle = AnimationStyle(
      duration: const Duration(seconds: 3),
      reverseDuration: const Duration(seconds: 1),
    );
    showModalBottomSheet<void>(
      context: context,
      sheetAnimationStyle: animationStyle,
      builder: (BuildContext context) {
        return SizedBox.expand(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal bottom sheet'),
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
