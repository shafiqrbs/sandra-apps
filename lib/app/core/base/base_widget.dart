import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sandra/app/core/importer.dart';

import '/app/core/singleton_classes/color_schema.dart';
import 'mixins/shorter_data_types_mixin.dart';
import 'mixins/validator_mixin.dart';

abstract class BaseWidget extends StatelessWidget
    with ShorterDataTypesMixin, ValidatorMixin {
  BaseWidget({super.key});

  final colors = ColorSchema();

  AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

  @override
  Widget build(BuildContext context);
}
