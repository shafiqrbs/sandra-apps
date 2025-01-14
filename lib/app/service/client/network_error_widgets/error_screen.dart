import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/importer.dart';

class ErrorScreen extends StatefulWidget {
  final String errorMessage;
  final String errorCode;

  const ErrorScreen({
    required this.errorMessage,
    required this.errorCode,
    super.key,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  final colors = ColorSchema();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
        0.7,
      ),
      // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.whiteColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.primaryColor50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/im_sad_emoji.png',
                      height: 60,
                      width: 60,
                    ),
                    16.height,
                    Text(
                      widget.errorMessage,
                      style: GoogleFonts.lato(
                        color: colors.primaryColor700,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (false)
                Text(
                  'Error Code: ${widget.errorCode}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              20.height,
              InkWell(
                onTap: Get.back,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.primaryColor500,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    color: colors.primaryColor500,
                  ),
                  //height: 60,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        TablerIcons.x,
                        size: 16,
                        color: Colors.white,
                      ),
                      5.width,
                      Text(
                        appLocalization.close,
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
