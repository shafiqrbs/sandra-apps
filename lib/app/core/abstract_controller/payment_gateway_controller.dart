import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_controller.dart';
import '/app/core/core_model/logged_user.dart';
import '/app/entity/customer.dart';
import '/app/entity/sales_item.dart';
import '/app/entity/transaction_methods.dart';
import '/app/entity/user.dart';
import 'package:nb_utils/nb_utils.dart';

abstract class PaymentGatewayController extends BaseController {
  final salesItemList = <SalesItem>[].obs;

  final formKey = GlobalKey<FormState>();

  final selectedPaymentMode = 'cash'.obs;
  final discountType = 'flat'.obs;
  final returnMsg = 'due'.obs;

  final paymentDiscountController = TextEditingController().obs;
  final amountController = TextEditingController().obs;
  final paymentTrxIdController = TextEditingController().obs;
  final paymentMobileController = TextEditingController().obs;
  final addRemarkController = TextEditingController().obs;

  final customerManager = CustomerManager();
  final transactionMethodsManager = TransactionMethodsManager();
  final userManager = UserManager().obs;

  final discountTypeController = ValueNotifier<bool>(false).obs;
  final showProfit = ValueNotifier<bool>(false).obs;
  final printWithoutDiscount = ValueNotifier<bool>(false).obs;

  final salesSubTotal = 0.00.obs;
  final salesDiscount = 0.00.obs;
  final salesVat = 0.00.obs;
  final netTotal = 0.00.obs;
  final salesReceive = 0.00.obs;
  final salesPurchasePrice = 0.00.obs;
  final salesDiscountPercent = 0.00.obs;
  final salesReturnValue = 0.00.obs;

  Future<void> baseInit() async {
    await transactionMethodsManager.getAll();
    await userManager.value.fillAsController();
    userManager.value.asController.selectedValue =
        userManager.value.asController.items?.firstWhereOrNull(
      (element) => element.userId == LoggedUser().userId,
    );
    userManager.refresh();
    calculateAllSubtotal();
    salesReturnValue.value = salesSubTotal.value;
    netTotal.value = salesSubTotal.value;
    discountTypeController.value.addListener(
      () {
        if (discountTypeController.value.value) {
          discountType.value = 'percent';
        } else {
          discountType.value = 'flat';
        }
        onDiscountChange(paymentDiscountController.value.text);
      },
    );
    showProfit.value.addListener(showProfit.refresh);
  }

  void changePaymentMode(String value) {
    selectedPaymentMode.value = value;
  }

  void onDiscountChange(String value) {
    final discountValue = double.tryParse(value) ?? 0;

    if (discountType.value == 'flat') {
      handleDiscountChange(discountValue, null);
    } else if (discountType.value == 'percent') {
      // Calculate percentage discount
      final percentDiscount =
          (salesSubTotal.value * discountValue / 100).toPrecision(2);
      handleDiscountChange(percentDiscount, discountValue);
    }

    netTotal.value = (salesSubTotal.value - salesDiscount.value).toPrecision(2);
    salesReturnValue.value = netTotal.value;

    onAmountChange(
      amountController.value.text.isEmptyOrNull
          ? '0'
          : amountController.value.text,
    );

    salesDiscount.refresh();
    netTotal.refresh();
    update();
    notifyChildrens();
    refresh();
  }

  void handleDiscountChange(double discountValue, double? percentValue) {
    if (discountValue > salesSubTotal.value) {
      toast('do_not_allow_discount_value_more_then_subtotal_value'.tr);
      paymentDiscountController.value.text = '0';
      salesDiscount.value = 0;
      netTotal.value = 0;
      salesReturnValue.value = salesSubTotal.value;
      return;
    }

    salesDiscount.value = discountValue;

    if (percentValue != null) {
      salesDiscountPercent.value = percentValue;
    }
  }

  void onAmountChange(String value) {
    if (value.isNotEmpty) {
      final returnValue = netTotal.value - value.toDouble();
      returnMsg.value = returnValue < 0 ? 'return'.tr : 'due'.tr;
      salesReturnValue.value = returnValue.toPrecision(2).abs();
    } else {
      returnMsg.value = 'due'.tr;
      salesReturnValue.value = 0.00;
    }
  }

  void calculateAllSubtotal() {
    salesSubTotal.value = 0;
    salesPurchasePrice.value = 0;

    for (final element in salesItemList) {
      salesSubTotal.value += element.subTotal ?? 0;
      salesPurchasePrice.value += element.purchasePrice! * element.quantity!;
    }
    salesSubTotal.value = salesSubTotal.value.toPrecision(2);
    salesPurchasePrice.value = salesPurchasePrice.value.toPrecision(2);

    salesSubTotal.refresh();
    salesPurchasePrice.refresh();
    update();
  }
}
