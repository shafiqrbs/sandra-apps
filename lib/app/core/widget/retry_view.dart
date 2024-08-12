import 'package:flutter/material.dart';
import '/app/core/base/base_widget.dart';
import '/app/core/utils/responsive.dart';
import 'common_text.dart';

class RetryView extends BaseWidget {
  final VoidCallback? onRetry;
  RetryView({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onRetry,
        child: Container(
          height: 40,
          width: 100,
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
          ),
          margin: const EdgeInsets.only(
            top: 200,
          ),
          decoration: BoxDecoration(
            color: colors.primaryBaseColor,
            borderRadius: BorderRadius.circular(
              containerBorderRadius,
            ),
            border: Border.all(
              color: colors.primaryBaseColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                text: appLocalization.retry,
                fontWeight: FontWeight.w500,
                fontSize: mediumButtonTFSize,
                textColor: colors.backgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
