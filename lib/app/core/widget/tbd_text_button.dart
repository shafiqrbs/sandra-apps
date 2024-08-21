import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/widget/custom_animation_widget.dart';

class TbdTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color selectedBgColor;
  final Color selectedTextColor;
  final Color unselectedBgColor;
  final Color unselectedTextColor;
  final bool isSelected;

  const TbdTextButton({
    required this.text,
    required this.onPressed,
    this.selectedBgColor = const Color(0xff8F624B),
    this.selectedTextColor = Colors.white,
    this.unselectedBgColor = Colors.transparent,
    this.unselectedTextColor = const Color(0xff202020),
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? selectedBgColor : unselectedBgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              text.tr,
              style: GoogleFonts.roboto(
                color: isSelected ? selectedTextColor : unselectedTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
