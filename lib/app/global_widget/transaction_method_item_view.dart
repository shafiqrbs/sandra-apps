import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '/app/core/base/base_widget.dart';
import '/app/core/widget/common_cache_image_widget.dart';
import '/app/entity/transaction_methods.dart';

class TransactionMethodItemView extends BaseWidget {
  final TransactionMethods method;
  final bool isSelected;
  final VoidCallback onTap;

  TransactionMethodItemView({
    required this.method,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  100,
                ),
                color: isSelected
                    ? colors.primaryColor
                    : colors.primaryColor.withOpacity(.2),
              ),
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                  color: Colors.transparent,
                ),
                child: commonCacheImageWidget(
                  method.imagePath,
                  30,
                  width: 30,
                  fit: BoxFit.fill,
                  isOval: true,
                ),
              ),
            ),
            4.height,
            SizedBox(
              width: 70,
              height: 20,
              child: Center(
                child: Text(
                  method.methodName?.toString() ?? '',
                  style: GoogleFonts.inter(
                    color: const Color(0xff4D4D4D),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
