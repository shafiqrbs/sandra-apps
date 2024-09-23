import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandra/app/core/singleton_classes/color_schema.dart';
import 'package:sandra/app/core/utils/responsive.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';

class PlaceOrderView extends StatelessWidget {
  final VoidCallback? onTap;
  final String? count;
  final String? total;

  const PlaceOrderView({
    super.key,
    this.onTap,
    this.count,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 7.ph,
        width: Get.width,
        color: colors.primaryColor400,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          bottom: 7,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              margin: const EdgeInsets.only(
                left: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appLocalization.placeOrder,
                    style: TextStyle(
                      color: colors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            //60.width,
            Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 32,
                right: 32,
              ),
              margin: const EdgeInsets.only(
                bottom: 4,
                top: 4,
                right: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: colors.primaryColor200,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    count ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    ' | ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 40.pw,
                    ),
                    child: Text(
                      total ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
