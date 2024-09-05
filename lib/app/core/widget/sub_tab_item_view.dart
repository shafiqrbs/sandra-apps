import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import '/app/core/singleton_classes/color_schema.dart';
import '/app/core/utils/responsive.dart';
import '/app/entity/tab_bar_items.dart';

import 'draw_icon.dart';

class SubTabItemView extends StatelessWidget {
  final TabBarItem item;
  final bool isSelected;
  final String Function()? localeMethod;
  final VoidCallback onTap;

  const SubTabItemView({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.localeMethod,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = ColorSchema();

    final color = isSelected
        ? Colors.white
        : ColorSchema().primaryBaseColor;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 15.v),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryBaseColor : Colors.transparent,
          border: Border(
            top: BorderSide(
              color: color,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DrawIcon(
              icon: TablerIcons.all[item.icon]!,
              color: color,
              size: 20,
            ),
            2.percentWidth,
            Text(
              item.localeMethod?.call()??'',
              style: TextStyle(
                color: color,
                fontSize: 14.fSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
