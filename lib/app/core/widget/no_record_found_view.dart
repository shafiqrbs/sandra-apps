import 'package:sandra/app/core/importer.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/widget/asset_image_view.dart';
import '/app/core/utils/style_function.dart';
import '/app/core/widget/common_text.dart';
import '/app/core/widget/quick_navigation_button.dart';
import '/app/core/utils/responsive.dart';

class NoRecordFoundView extends StatelessWidget {
  Function()? onTap;
  String? buttonText;
  NoRecordFoundView({
    super.key,
    this.onTap,
    this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 80.ph,
      width: 100.pw,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60,),
            child: AssetImageView(
              fileName: 'no_data_found.svg',
              fit: BoxFit.cover,
              color: colors.primaryColor500,
              height: Get.height * .25,
            ),
          ),
          /*Container(
            child: Lottie.asset(
              'assets/lottieFiles/no_record_found.json',
              fit: BoxFit.cover,
            ),
          ),*/
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                width: 80.pw,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: colors.secondaryColor500,
                ),
                child: Text(
                  buttonText ?? 'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.fSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
