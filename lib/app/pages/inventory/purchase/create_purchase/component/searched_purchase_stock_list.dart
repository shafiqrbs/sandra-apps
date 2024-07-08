import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/app/core/base/base_widget.dart';
import '/app/model/stock.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchedPurchaseStockList extends StatelessWidget {
  final List<Stock> stocks;
  final Function(Stock value) onItemTap;
  final Function(num value, int index) onQtyChange;
  final Function(num value, int index) onQtyEditComplete;

  const SearchedPurchaseStockList({
    required this.stocks,
    required this.onItemTap,
    required this.onQtyChange,
    required this.onQtyEditComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        return PurchaseItemView(
          stock: stocks[index],
          onItemTap: onItemTap,
          onQtyChange: onQtyChange,
          onQtyEditComplete: onQtyEditComplete,
          index: index,
        );
      },
    );
  }
}

class PurchaseItemView extends BaseWidget {
  final Stock stock;
  final Function(Stock value) onItemTap;
  final Function(num value, int index) onQtyChange;
  final Function(num value, int index) onQtyEditComplete;
  final int index;

  PurchaseItemView({
    required this.stock,
    required this.onItemTap,
    required this.onQtyChange,
    required this.onQtyEditComplete,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final qtyController = TextEditingController();
    final isEditing = false.obs;
    final total = '0.00'.obs;

    return InkWell(
      onTap: () {
        if (qtyController.text.isNotEmpty) {
          onQtyEditComplete(
            double.tryParse(qtyController.text) ?? 0,
            index,
          );
        } else {
          onItemTap(stock);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF4FB),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color:
                    isEditing.value ? colors.primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stock.name ?? '',
                            maxLines: 2,
                            style: const TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),
                          Text(
                            stock.brandName ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    16.width,
                    SizedBox(
                      height: 28,
                      width: 56,
                      child: TextFormField(
                        controller: qtyController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [regexDouble],
                        onChanged: (value) {
                          final salesPrice = stock.salesPrice ?? 0;
                          final quantity =
                              double.tryParse(qtyController.text) ?? 0;
                          final subtotal =
                              (salesPrice * quantity).toPrecision(2);

                          total.value = subtotal.toStringAsFixed(2);
                        },
                        onEditingComplete: () {
                          onQtyEditComplete(
                            double.tryParse(qtyController.text) ?? 0,
                            index,
                          );
                        },
                        onTap: () {
                          isEditing.value = true;
                        },
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Qty',
                          constraints: BoxConstraints(maxHeight: 28),
                          hintStyle: TextStyle(
                            color: Color(0xFF989898),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFDFB9A5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                4.height,
                Divider(color: Color(0xFFBABABA)),
                4.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Stock ',
                              style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: stock.quantity.toString(),
                              style: const TextStyle(
                                color: Color(0xFF202020),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                            const TextSpan(
                              text: ' pcs',
                              style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.width,
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: '৳ ',
                              style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: stock.salesPrice?.toStringAsFixed(2) ??
                                  '0.00',
                              style: const TextStyle(
                                color: Color(0xFF202020),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.width,
                    Expanded(
                      child: Center(
                        child: Obx(
                          () => RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Total ',
                                  style: TextStyle(
                                    color: Color(0xFF989898),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 1,
                                  ),
                                ),
                                TextSpan(
                                  text: total.value,
                                  style: const TextStyle(
                                    color: Color(0xFF202020),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
