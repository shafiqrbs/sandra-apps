import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnmatchedDataTypeScreen extends StatelessWidget {
  final String expectedDataType;
  final String actualDataType;
  const UnmatchedDataTypeScreen({
    required this.expectedDataType,
    required this.actualDataType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(
        0.85,
      ), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Unmatched Data Type',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Expected: $expectedDataType\nActual: $actualDataType',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: Get.back, child: const Text('Ok')),
            ],
          ),
        ),
      ),
    );
  }
}
