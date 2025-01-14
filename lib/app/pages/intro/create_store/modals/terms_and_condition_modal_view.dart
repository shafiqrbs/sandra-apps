import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/core/values/text_styles.dart';
import 'package:sandra/app/pages/intro/create_store/controllers/create_store_controller.dart';

class TermsAndConditionModalView extends BaseView<CreateStoreController> {
  String terms;

  TermsAndConditionModalView({
    super.key,
    required this.terms,
  });

  final falsePadding = 16.0.obs;

  final termsDummyString = '''
  1. Acceptance of Terms
      By using this Point of Sale (POS) application, you agree to abide by these Terms and Conditions. If you do not agree, please refrain from using the application.

  2. User Responsibilities
      Ensure that all transactions are legally compliant and accurately recorded.
      Maintain the confidentiality of login credentials and sensitive business data.
      Use the software only for its intended purpose—business transactions and sales management.
  3. Licensing & Access
      This POS software is licensed, not sold. You are granted a non-transferable, non-exclusive right to use it.
      Unauthorized copying, distribution, or modification of the software is strictly prohibited.
  4. Data Privacy & Security
      The application may collect and store transaction data for business analytics and operational purposes.
      Users are responsible for securing their device and preventing unauthorized access.
      The app provider is not liable for any data loss due to user negligence.
  5. Payment & Subscriptions
      If applicable, subscription plans must be paid on time to maintain uninterrupted service.
      Failure to renew may result in restricted access to certain features.
  6. Software Updates & Maintenance
      The provider reserves the right to update the software periodically to improve performance and security.
      Users must keep their software up to date to ensure compatibility and security.
  7. Prohibited Activities
      Users must not:

      Engage in fraudulent transactions or manipulate sales records.
      Reverse-engineer, modify, or attempt to hack the application.
      Use the POS app for illegal activities.
  8. Limitation of Liability
      The app provider is not responsible for financial losses, transaction errors, or business disruptions caused by misuse or external factors.
      The software is provided "as is," without warranties of any kind.
  9. Termination of Access
      The provider reserves the right to suspend or terminate access if users violate these terms.
      In case of termination, users must cease all use of the software immediately.
  10. Governing Law
      These terms are governed by applicable local and international laws. Any disputes shall be resolved in accordance with the jurisdiction specified by the provider.

  By using this POS software, you acknowledge and agree to these terms. If you have any questions, contact customer support.

  ''';

  @override
  Widget build(BuildContext context) {
    return GetX<CreateStoreController>(
      init: CreateStoreController(),
      builder: (controller) {
        return Container(
          padding: EdgeInsets.all(falsePadding.value),
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.7,
          ),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                HtmlWidget(
                  terms,
                  textStyle: AppTextStyle.h3TextStyle400,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget body(BuildContext context) {
    // TODO: implement body
    throw UnimplementedError();
  }
}
