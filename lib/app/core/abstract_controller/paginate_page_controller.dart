import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sandra/app/core/base/base_controller.dart';

abstract class BaseGenericController<T> extends BaseController {
  final searchTextController = TextEditingController().obs;
  final pagingController = Rx<PagingController<int, T>>(
    PagingController<int, T>(
      firstPageKey: 1,
    ),
  );
  final isSearchSelected = false.obs;

  dynamic selectedItem;
  String? startDate;
  String? endDate;
  String? searchQuery;

  Future<void> onClearSearchText();
  Future<void> showFilterModal({required BuildContext context});
  void goToCreateItem();
  Future<void> showItemInformationModal(BuildContext context, T element);
  Future<void> showPaymentModal();
  Future<void> deleteItem(int itemId);
  Future<void> approveItem({required int itemId, required int index});
  Future<void> onSearch(String value);
  Future<void> refreshData();
  Future<void> fetchItemList({required int pageKey});
}
