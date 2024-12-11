import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/importer.dart';

import '/app/core/core_model/voice_recognition.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/style_function.dart';
import '/app/entity/stock.dart';

class ProductSearchForm extends StatelessWidget {
  final Function(String value) onSearch;
  final VoidCallback onClear;
  final bool isShowSuffixIcon;
  final bool autoFocus;
  final Stock? selectedStock;
  final TextEditingController searchController;

  ProductSearchForm({
    required this.onSearch,
    required this.onClear,
    required this.isShowSuffixIcon,
    required this.autoFocus,
    required this.selectedStock,
    required this.searchController,
    super.key,
  });

  final colors = ColorSchema();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          containerBorderRadius,
        ),
        border: Border.all(color: colors.secondaryColor100),
        color: colors.primaryColor50,
      ),
      padding: const EdgeInsets.only(
        bottom: 2,
        right: 4,
        top: 2,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Center(
              child: Form(
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 2,
                  ),
                  //padding: EdgeInsets.zero,
                  height: textFieldHeight,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius: BorderRadius.circular(
                      containerBorderRadius,
                    ),
                  ),

                  child: TextFormField(
                    controller: searchController,
                    autofocus: autoFocus,
                    style: TextStyle(
                      fontSize: selectedStock != null ? 14 : 16,
                      fontWeight: FontWeight.normal,
                      color: colors.solidBlackColor,
                    ),
                    cursorColor: colors.solidBlackColor,
                    onChanged: onSearch,
                    decoration: inputDecorationSearch(
                      hint: appLocalization.searchProduct,
                      isSHowPrefixIcon: false,
                      textEditingController: searchController,
                      isSHowSuffixIcon: isShowSuffixIcon,
                      borderRadius: containerBorderRadius,
                      suffix: Icons.clear,
                      onTap: onClear,
                    ),
                  ),
                ),
              ),
            ),
          ),
          4.width,
          Expanded(
            flex: selectedStock == null ? 2 : 3,
            child: Container(
              // alignment: Alignment.center,
              //height: 0.045.ph,
              child: selectedStock == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.primaryColor50,
                              borderRadius: BorderRadius.circular(
                                containerBorderRadius,
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                              left: 4,
                              right: 4,
                            ),
                            child: InkWell(
                              onTap: () async {
                                final voiceRecognition = VoiceRecognition();

                                if (!voiceRecognition.isListening) {
                                  await voiceRecognition.startListening(
                                    (result) {
                                      searchController.text = result;
                                      onSearch(result);
                                    },
                                  );
                                } else {
                                  await voiceRecognition.stopListening();
                                }
                              },
                              child: Icon(
                                TablerIcons.microphone,
                                color: colors.solidBlackColor,
                              ),
                            ),
                          ),
                        ),
                        4.width,
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.primaryColor50,
                              borderRadius: BorderRadius.circular(
                                containerBorderRadius,
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                              left: 4,
                              right: 4,
                            ),
                            child: InkWell(
                              onTap: () async {},
                              child: Icon(
                                TablerIcons.barcode,
                                color: colors.solidBlackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: colors.whiteColor,
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.only(left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MRP ${selectedStock?.salesPrice ?? ''} TK",
                            style: TextStyle(
                              fontSize: smallTFSize,
                              color: colors.solidBlackColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "Stock in ${selectedStock?.quantity ?? ''} pc",
                            style: TextStyle(
                              fontSize: smallTFSize,
                              color: colors.solidBlackColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "P.P. ${selectedStock?.purchasePrice ?? ''} pc",
                            style: TextStyle(
                              fontSize: smallTFSize,
                              color: colors.solidBlackColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
