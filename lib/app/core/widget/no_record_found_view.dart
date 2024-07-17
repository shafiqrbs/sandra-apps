import 'package:flutter/material.dart';
import 'package:sandra/app/core/utils/responsive.dart';

class NoRecordFoundView extends StatelessWidget {
  const NoRecordFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40.ph,
      width: 100.pw,
      child: Image.asset(
        'assets/images/no-record-found.png',
      ),
    );
  }
}
