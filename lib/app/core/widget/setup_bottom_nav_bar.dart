import 'package:flutter/material.dart';

class SetupBottomNavBar extends StatelessWidget {
  final List<Widget> buttonList;
  const SetupBottomNavBar({
    required this.buttonList,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buttonList,
            ),
          ],
        ),
      ),
    );
  }
}
