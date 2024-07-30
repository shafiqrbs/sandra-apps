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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
           containerBorderRadius,
          ),
          color: isSelected ? colors.selectedColor : colors.evenListColor,
          border: Border.all(
            color: isSelected ? colors.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 42,
              width: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: commonCacheImageWidget(
                method.imagePath,
                36,
                width: 36,
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
                    color: const Color(0xff4d4d4d),
                    fontSize: 10,
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
