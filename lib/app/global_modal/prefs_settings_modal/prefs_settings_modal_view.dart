import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sandra/app/core/core_model/setup.dart';
import 'package:sandra/app/core/importer.dart';

import 'prefs_settings_modal_controller.dart';

class PrefsSettingsModalView extends BaseView<PrefsSettingsModalController> {
  PrefsSettingsModalView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<PrefsSettingsModalController>(
      init: PrefsSettingsModalController(),
      builder: (controller) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Visibility(
                  visible: SetUp().mainAppName == 'restaurant',
                  child: _buildRestaurant(),
                ),
                _buildSales(),
                _buildPurchase(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRestaurant() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dividerWidget(),
        Row(
          children: [
            Icon(
              TablerIcons.building_store,
              color: colors.primaryColor700,
              size: 24,
            ),
            8.width,
            Text(
              appLocalization.restaurant.toUpperCase(),
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primaryColor700,
              ),
            ),
          ],
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.tableEnableDisable,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isTableEnabled,
                    onChanged: (value) async {
                      await controller.setTableEnable(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isTableEnabled.value,
                  ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.allPrintEnableDisable,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isAllPrintEnabled,
                    onChanged: (value) async {
                      await controller.setAllPrintEnable(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isAllPrintEnabled.value,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dividerWidget(),
        Row(
          children: [
            Icon(
              TablerIcons.shopping_cart,
              color: colors.primaryColor700,
              size: 24,
            ),
            8.width,
            Text(
              appLocalization.sales.toUpperCase(),
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primaryColor700,
              ),
            ),
          ],
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.salesOnlineOffline,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isSalesOnline,
                    onChanged: (value) async {
                      await controller.setSalesOnline(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isSalesOnline.value,
                  ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.salesAllowedWithoutPayment,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isZeroSalesAllowed,
                    onChanged: (value) async {
                      await controller.setZeroSalesAllowed(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isZeroSalesAllowed.value,
                  ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.autoSalesApproval,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isSalesAutoApproved,
                    onChanged: (value) async {
                      await controller.setSalesAutoApproved(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isSalesAutoApproved.value,
                  ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.isShowBrandOnSales,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isShowBrandOnSales,
                    onChanged: (value) async {
                      await controller.setShowBrandOnSales(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isShowBrandOnSales.value,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPurchase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dividerWidget(),
        Row(
          children: [
            Icon(
              TablerIcons.truck_delivery,
              color: colors.primaryColor700,
              size: 24,
            ),
            8.width,
            Text(
              appLocalization.purchase.toUpperCase(),
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: colors.primaryColor700,
              ),
            ),
          ],
        ),
        dividerWidget(),
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  _buildSettingButton(
                    text: appLocalization.purchaseConfig,
                    trailingIcon: TablerIcons.chevron_right,
                    isOpen: controller.buttons.value == Buttons.purchase,
                    onTap: () {
                      controller.changeButton(Buttons.purchase);
                    },
                  ),
                  if (controller.buttons.value == Buttons.purchase) 8.height,
                  if (controller.buttons.value == Buttons.purchase)
                    Container(
                      color: Colors.white,
                      width: Get.width,
                      padding: const EdgeInsets.only(
                        left: 16,
                        top: 16,
                        bottom: 16,
                      ),
                      child: Column(
                        children: [
                          16.height,
                          _buildCustomRadioButton(
                            title: appLocalization.purchaseWithMrp,
                            isSelected: controller.selectedPurchase.value ==
                                'purchase_with_mrp',
                            onTap: () {
                              controller.changePurchase('purchase_with_mrp');
                            },
                          ),
                          16.height,
                          _buildCustomRadioButton(
                            title: appLocalization.purchasePrice,
                            isSelected: controller.selectedPurchase.value ==
                                'purchase_price',
                            onTap: () {
                              controller.changePurchase('purchase_price');
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.purchaseOnlineOffline,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isPurchaseOnline,
                    onChanged: (value) async {
                      await controller.setPurchaseOnline(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isPurchaseOnline.value,
                  ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.autoPurchaseApproval,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isPurchaseAutoApproved,
                    onChanged: (value) async {
                      await controller.setPurchaseAutoApproved(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isPurchaseAutoApproved.value,
                  ),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: spaceBetweenMAA,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Text(
                      appLocalization.isShowBrandOnPurchase,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AdvancedSwitch(
                    controller: controller.isShowBrandOnPurchase,
                    onChanged: (value) async {
                      await controller.setShowBrandOnPurchase(value);
                    },
                    borderRadius: BorderRadius.circular(4),
                    height: 20,
                    width: 40,
                    activeColor: colors.primaryColor700,
                    inactiveColor: colors.secondaryColor100,
                    initialValue: controller.isShowBrandOnPurchase.value,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomRadioButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? colors.primaryColor700
                    : colors.secondaryColor200,
              ),
            ),
            child: isSelected
                ? Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primaryColor700,
                    ),
                  )
                : Container(),
          ),
          16.width,
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: [
        8.height,
        Container(
          height: 1,
          color: colors.secondaryColor100,
        ),
        8.height,
      ],
    );
  }

  Widget _buildSettingButton({
    required String text,
    required IconData trailingIcon,
    required bool isOpen,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null)
            Icon(
              icon,
              color: colors.solidBlackColor,
              size: 24,
            ),
          if (icon != null) 8.width,
          Container(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Text(
              text,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Spacer(),
          Icon(
            isOpen ? TablerIcons.chevron_down : trailingIcon,
            color: colors.solidBlackColor,
          ),
        ],
      ),
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
