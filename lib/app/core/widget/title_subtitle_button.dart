import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class TitleSubtitleButton extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? bgColor;

  const TitleSubtitleButton({
    this.title = 'Title',
    this.subTitle = 'Subtitle',
    super.key,
    this.icon,
    this.onTap,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.red,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                offset: Offset(0, 1),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: icon != null
                    ? Icon(
                        icon,
                        color: const Color(0xff202020),
                        size: 20,
                      )
                    : Container(),
              ),
              6.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title!,
                          style: GoogleFonts.roboto(
                            color: const Color(0xff000000).withOpacity(0.4),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Icon(
                          TablerIcons.chevron_right,
                          color: Color(0xff000000),
                          size: 14,
                        ),
                      ],
                    ),
                    4.height,
                    Text(
                      subTitle!,
                      style: GoogleFonts.roboto(
                        color: const Color(0xff000000).withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
