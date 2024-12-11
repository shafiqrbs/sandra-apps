import 'package:sandra/app/core/importer.dart';
import 'package:sandra/app/entity/sales_return.dart';

import 'sales_return_list_controller.dart';

class SalesReturnListPage extends BaseView<SalesReturnListController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: colors.primaryColor500,
      title: PageBackButton(
        pageTitle: appLocalization.refundList,
      ),
      automaticallyImplyLeading: false,
      actions: [
        AppBarButtonGroup(
          children: [
            QuickNavigationButton(),
          ],
        ),
      ],
    );
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: appBar(context),
      body: Column(
        children: [
          Obx(
            () {
              final pageState = controller.pageState;
              if (pageState == PageState.loading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: loaderColor,
                    ),
                  ),
                );
              }

              if (pageState == PageState.failed) {
                return RetryView(
                  onRetry: controller.refreshData,
                );
              }

              if (pageState == PageState.success) {
                final items = controller.pagingController.value.itemList;

                final isEmpty = items?.isEmpty ?? true;
                if (isEmpty) {
                  return NoRecordFoundView(
                    onTap: controller.refreshData,
                  );
                }

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.refreshData,
                    child: _buildListView(),
                  ),
                );
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return PagedListView<int, SalesReturn>(
      pagingController: controller.pagingController.value,
      shrinkWrap: true,
      builderDelegate: PagedChildBuilderDelegate<SalesReturn>(
        itemBuilder: (context, item, index) {
          return _buildCardView(
            element: item,
            index: index,
            context: context,
          );
        },
        newPageErrorIndicatorBuilder: (context) {
          return listViewRetryView(
            onRetry: controller.pagingController.value.retryLastFailedRequest,
          );
        },
      ),
    );
  }

  Widget _buildCardView({
    required SalesReturn element,
    required int index,
    required BuildContext context,
  }) {
    final createdDate = element.createdAt != null
        ? DateFormat(dateFormat).format(
            DateFormat(apiDateFormat).parse(element.createdAt!),
          )
        : '';
    return InkWell(
      onTap: () => controller.showSalesInformationModal(
        context,
        element,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 8,
              top: index == 0 ? 8 : 0,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: index.isEven
                  ? colors.secondaryColor50
                  : colors.primaryColor50,
              borderRadius: BorderRadius.circular(containerBorderRadius),
              border: Border.all(
                color: index.isEven
                    ? colors.secondaryColor100
                    : colors.primaryColor100,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CommonIconText(
                        text: createdDate,
                        icon: TablerIcons.calendar_due,
                        fontSize: valueTFSize,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: '${element.salesInvoice}',
                        icon: TablerIcons.file_invoice,
                        fontSize: valueTFSize,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: CommonIconText(
                        text: element.customerName ?? '',
                        icon: TablerIcons.user,
                        textOverflow: TextOverflow.ellipsis,
                        fontSize: valueTFSize,
                      ),
                    ),
                    Expanded(
                      child: CommonIconText(
                        text: element.customerMobile ?? '',
                        icon: TablerIcons.device_mobile,
                        fontSize: valueTFSize,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text:
                              "${appLocalization.total} : ${controller.currency} ${element.subTotal ?? ''}",
                          fontSize: valueTFSize,
                          textColor: colors.solidBlackColor,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text:
                              "${appLocalization.payment} : ${controller.currency} ${element.payment ?? ''}",
                          fontSize: valueTFSize,
                          textColor: colors.solidBlackColor,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 4),
                        child: CommonText(
                          text:
                              "${appLocalization.adjustment} :${controller.currency} ${element.adjustment ?? ''}",
                          fontSize: valueTFSize,
                          textColor: colors.solidBlackColor,
                          textAlign: TextAlign.start,
                          maxLine: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
