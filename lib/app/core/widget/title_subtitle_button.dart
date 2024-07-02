import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class TitleSubtitleButton extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final IconData? icon;
  final VoidCallback? onTap;
  const TitleSubtitleButton({
    this.title = 'Title',
    this.subTitle = 'Subtitle',
    super.key,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 130,
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: const Color(0xffe9e9e9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: icon != null
                  ? Icon(
                      icon,
                      color: const Color(0xff4d4d4d),
                      size: 20,
                    )
                  : Container(),
            ),
            6.height,
            Text(
              title!,
              style: GoogleFonts.roboto(
                color: const Color(0xff4d4d4d),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            4.height,
            Text(
              subTitle!,
              style: GoogleFonts.roboto(
                color: const Color(0xff4d4d4d),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
