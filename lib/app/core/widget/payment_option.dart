import 'package:flutter/material.dart';
import '/app/core/singleton_classes/color_schema.dart';

class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Function(String value) onTap;

  PaymentOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });
  final colorSchema = ColorSchema();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap(label.toLowerCase());
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          // height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? colorSchema.borderColor
                  : colorSchema.primaryColor50,
            ),
            borderRadius: BorderRadius.circular(4),
            color: isSelected
                ? colorSchema.primaryColor400
                : colorSchema.primaryColor50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected
                    ? colorSchema.primaryTextColor
                    : colorSchema.secondaryTextColor,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? colorSchema.primaryTextColor
                      : colorSchema.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
