import 'package:flutter/material.dart';

class AppBarButtonGroup extends StatelessWidget {
  final List<Widget> children;
  const AppBarButtonGroup({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      height: 60,
      margin: const EdgeInsets.only(
        right: 16,
        bottom: 8,
      ),
      padding: const EdgeInsets.only(
        left: 8,
      ),
      child: Row(
        children: children.map(
          (e) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: e,
            );
          },
        ).toList(),
      ),
    );
  }
}
