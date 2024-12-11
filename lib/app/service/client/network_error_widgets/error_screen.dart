import 'package:sandra/app/core/importer.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/widget/quick_navigation_button.dart';

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
      backgroundColor: Colors.white.withOpacity(
        0.85,
      ), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Center(
        child: Container(
          height: 300,
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.primaryColor500,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
            border: Border.all(
              color: colors.primaryColor500,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.errorMessage,
                style: GoogleFonts.lato(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
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
                  width: 100,
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
            ],
          ),
        ),
      ),
    );
  }
}
