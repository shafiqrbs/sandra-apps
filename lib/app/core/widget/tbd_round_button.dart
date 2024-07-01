import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class TbdRoundButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final IconData? icon;
  const TbdRoundButton({
    required this.text,
    super.key,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 72,
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
            child: Icon(
              icon,
              color: const Color(0xff4d4d4d),
              size: 32,
            ),
          ),
          4.height,
          SizedBox(
            width: 70,
            height: 40,
            child: Center(
              child: Text(
                text.tr,
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
