import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class TbdRoundButton extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final String Function()? localeMethod;
  final IconData? icon;

  const TbdRoundButton({
    this.text,
    super.key,
    this.onTap,
    this.localeMethod,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 56,
            width: 56,
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
            child: Icon(
              icon,
              color: const Color(0xff4d4d4d),
              size: 24,
            ),
          ),
          4.height,
          SizedBox(
            width: 70,
            height: 40,
            child: Center(
              child: Text(
                localeMethod?.call() ?? text?.tr ?? '',
                style: GoogleFonts.inter(
                  color: const Color(0xff4d4d4d),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
