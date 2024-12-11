import 'package:sandra/app/core/importer.dart';
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
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                color: isSelected
                    ? colors.secondaryColor300
                    : colors.secondaryColor50,
              ),
              child: Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    8,
                  ),
                  color: Colors.transparent,
                ),
                child: commonCacheImageWidget(
                  method.imagePath,
                  24,
                  width: 24,
                  fit: BoxFit.fill,
                  isOval: true,
                ),
              ),
            ),
            //4.height,
            SizedBox(
              width: 70,
              height: 20,
              child: Center(
                child: Text(
                  (method.methodName?.toString() ?? '').capitalizeFirstLetter(),
                  style: GoogleFonts.inter(
                    color: const Color(0xff4D4D4D),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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
