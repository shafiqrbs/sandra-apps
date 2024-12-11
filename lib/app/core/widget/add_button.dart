import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '/app/core/base/base_widget.dart';

import 'app_bar_button.dart';

class AddButton extends BaseWidget {
  final VoidCallback onTap;
  AddButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      buttonName: null,
      onTap: onTap,
      leftIcon: TablerIcons.library_plus,
      buttonBGColor: Colors.transparent,
      iconColor: Colors.white,
    );
  }
}
