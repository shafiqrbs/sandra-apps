import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/sales_return.dart';

class SalesReturnListController extends BaseController {
  final pagingController = Rx<PagingController<int, SalesReturn>>(
    PagingController<int, SalesReturn>(
      firstPageKey: 1,
    ),
  );

  @override
  Future<void> onInit() async {
    super.onInit();

    pagingController.value.addPageRequestListener(
      (pageKey) {
        fetchOnlineList(
          pageKey: pageKey,
        );
      },
    );
    try {
      updatePageState(PageState.loading);
      await fetchOnlineList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }

    await services.getSalesReturnList(
      page: 1,
    );
  }

  Future<void> fetchOnlineList({
    required int pageKey,
  }) async {
    final apiDataList = await services.getSalesReturnList(
      page: pageKey,
    );
    if (apiDataList == null) {
      pagingController.value.error = true;
      return;
    }

    if ((apiDataList.length) < pageLimit) {
      pagingController.value.appendLastPage(apiDataList);
    } else {
      pagingController.value.appendPage(
        apiDataList,
        pageKey + 1,
      );
    }
  }

  Future<void> refreshData() async {
    updatePageState(PageState.loading);
    try {
      pagingController.value.refresh();

      await fetchOnlineList(
        pageKey: 1,
      );
    } finally {
      if (pagingController.value.itemList == null) {
        updatePageState(PageState.failed);
      } else {
        updatePageState(PageState.success);
      }
    }
  }

  showSalesInformationModal(
    BuildContext context,
    SalesReturn element,
  ) {
    Get.dialog(
      DialogPattern(
        title: appLocalization.salesReturn,
        subTitle: '',
        child: SalesReturnInformationModalView(element: element),
      ),
    );
  }
}

class SalesReturnInformationModalView extends StatelessWidget {
  final SalesReturn element;

  const SalesReturnInformationModalView({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(containerBorderRadius),
        color: colors.secondaryColor50,
      ),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.secondaryColor50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(containerBorderRadius),
                topRight: Radius.circular(
                  containerBorderRadius,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 16,
                right: 16,
              ),
              child: Column(
                children: [
                  // title
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.user,
                          text: controller.sales.value!.customerName ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.file_invoice,
                          text: '${controller.sales.value!.invoice}',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.device_mobile,
                          text: controller.sales.value!.customerMobile ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.user,
                          text: controller.sales.value?.createdBy ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.calendar,
                          text: controller.sales.value!.createdAt ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                      Expanded(
                        child: CommonIconText(
                          icon: TablerIcons.info_square_rounded,
                          text: controller.sales.value!.methodName ?? '',
                          fontSize: mediumTFSize,
                        ),
                      ),
                    ],
                  ),
                  4.height,
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: colors.primaryColor50,
            ),
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 4,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: CommonText(
                    text: appLocalization.name,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: appLocalization.price,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: appLocalization.qty,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: CommonText(
                    text: appLocalization.total,
                    fontSize: mediumTFSize,
                    textColor: colors.solidBlackColor,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.ph,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: controller.sales.value?.salesItem?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final elementItem = controller.sales.value!.salesItem![index];

                  return Container(
                    //height: 50,
                    width: Get.width,
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                      left: 16,
                      right: 16,
                    ),
                    margin: const EdgeInsets.only(bottom: 2),
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? colors.whiteColor
                          : colors.secondaryColor50,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: CommonText(
                            text:
                                '${index + 1}. ${elementItem.stockName ?? ''}',
                            fontSize: 10,
                            textColor: colors.solidBlackColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            text: elementItem.mrpPrice?.toString() ?? '',
                            fontSize: mediumTFSize,
                            textColor: colors.solidBlackColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            text: elementItem.quantity?.toString() ?? '',
                            fontSize: mediumTFSize,
                            textColor: colors.solidBlackColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: CommonText(
                            text: elementItem.subTotal?.toString() ?? '',
                            fontSize: mediumTFSize,
                            textColor: colors.solidBlackColor,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 2,
            decoration: BoxDecoration(
              color: colors.primaryColor50,
            ),
          ),
          Container(
            width: Get.width,
            padding: const EdgeInsets.only(right: 16),
            alignment: Alignment.centerRight,
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  //flex: 2,
                  child: Column(
                    mainAxisAlignment: endMAA,
                    crossAxisAlignment: endCAA,
                    children: [
                      labelValue.copyWith(
                        label: appLocalization.subTotal,
                        value: '${controller.sales.value!.subTotal}',
                      ),
                      labelValue.copyWith(
                        label:
                            '${appLocalization.discount} (${controller.sales.value!.discountCalculation})',
                        value: '${controller.sales.value!.discount}',
                      ),
                      Container(
                        width: Get.width,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.primaryColor50,
                        ),
                      ),
                      labelValue.copyWith(
                        label: appLocalization.total,
                        value: '${controller.sales.value!.netTotal}',
                      ),
                      labelValue.copyWith(
                        label: appLocalization.receive,
                        value: '${controller.sales.value!.received}',
                      ),
                      Container(
                        width: Get.width,
                        height: 2,
                        decoration: BoxDecoration(
                          color: colors.primaryColor50,
                        ),
                      ),
                      labelValue.copyWith(
                        label: appLocalization.due,
                        value: (
                          (controller.sales.value!.netTotal ?? 0) -
                              (controller.sales.value!.received ?? 0),
                        ).toString(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          16.height,
          if (isShowFooter ?? true)
            Row(
              children: [
                Visibility(
                  visible: controller.sales.value?.approvedBy == null &&
                      controller.isManager,
                  child: Expanded(
                    child: InkWell(
                      onTap: () => controller.deleteSales(
                        onDeleted: onDeleted,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryRedColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.trash,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.delete,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () => controller.salesPrint(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryBlueColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.printer,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.print,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (controller.salesMode == 'online' ||
                          controller.salesMode == 'local') &&
                      controller.sales.value?.approvedBy == null &&
                      controller.isManager,
                  child: Expanded(
                    child: InkWell(
                      onTap: controller.goToEditSales,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryGreenColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.pencil,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.edit,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: controller.copySales,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          containerBorderRadius,
                        ),
                        color: colors.solidOliveColor.withOpacity(.2),
                      ),
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              TablerIcons.copy,
                              size: 18,
                              color: colors.solidBlackColor,
                            ),
                            2.height,
                            Text(
                              appLocalization.copy,
                              style: AppTextStyle.h4TextStyle400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' &&
                      controller.sales.value?.approvedBy != null &&
                      controller.isManager,
                  child: Expanded(
                    child: InkWell(
                      onTap: controller.returnSales,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.solidPurpleColor.withOpacity(.2),
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.receipt_refund,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.returnn,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.createSalesDetailsPdf(
                          sales: controller.sales.value!,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryGreyColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.share,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.share,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                4.width,
              ],
            ),
          if (isFromAccount ?? false)
            Row(
              children: [
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () => controller.salesPrint(context),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryBlueColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.printer,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.print,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.salesMode == 'online' ||
                      controller.salesMode == 'local',
                  child: Expanded(
                    child: InkWell(
                      onTap: () {
                        controller.createSalesDetailsPdf(
                          sales: controller.sales.value!,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            containerBorderRadius,
                          ),
                          color: colors.secondaryGreyColor,
                        ),
                        margin: const EdgeInsets.only(
                          left: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                TablerIcons.share,
                                color: colors.solidBlackColor,
                                size: 18,
                              ),
                              2.height,
                              Text(
                                appLocalization.share,
                                style: AppTextStyle.h4TextStyle400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          1.percentHeight,
        ],
      ),
    );
  }
}
