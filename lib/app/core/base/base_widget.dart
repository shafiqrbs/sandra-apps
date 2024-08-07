import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/values/app_dimension.dart';
import 'mixins/shorter_data_types_mixin.dart';
import 'mixins/shorter_enum_mixin.dart';
import 'mixins/validator_mixin.dart';

final regexDouble = FilteringTextInputFormatter.allow(
  RegExp(r'^[0-9]*\.?[0-9]*'),
);
final regexInteger = FilteringTextInputFormatter.allow(
  RegExp('^[0-9]*'),
);

abstract class BaseWidget extends StatelessWidget
    with ShorterEnumMixin, ShorterDataTypesMixin, ValidatorMixin, AppDimension {
  BaseWidget({super.key});

  final colors = ColorSchema();
  AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

  @override
  Widget build(BuildContext context);
}
