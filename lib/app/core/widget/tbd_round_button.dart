import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/importer.dart';

class TbdRoundButton extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final String Function()? localeMethod;
  final IconData? icon;
  final Color? bgColor;
  final bool permission;

  const TbdRoundButton({
    required this.permission,
    this.text,
    super.key,
    this.onTap,
    this.localeMethod,
    this.icon,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (bgColor ?? Colors.blue).withOpacity(.2),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: bgColor ?? Colors.blue,
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
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          4.height,
          SizedBox(
            height: 40,
            child: Text(
              localeMethod?.call() ?? text?.tr ?? '',
              style: GoogleFonts.inter(
                color: const Color(0xff4d4d4d),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
