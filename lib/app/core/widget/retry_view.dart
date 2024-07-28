import 'package:flutter/material.dart';
import '/app/core/utils/responsive.dart';

class RetryView extends StatelessWidget {
  final VoidCallback? onRetry;
  const RetryView({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 40.ph,
          width: 100.pw,
          child: Image.asset(
            'assets/images/no-record-found.png',
          ),
        ),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
