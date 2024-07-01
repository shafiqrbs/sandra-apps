import 'dart:io';

Future<void> main() async {
  print('Enter The Page Name: ');
  final String pageName = stdin.readLineSync()!.trim().toLowerCase();

  // Convert to camelCase
  final pageFileName = fileName(pageName);
  final pageClassName = className(pageFileName);

  // Check if the page already exists
  final String pageDirectoryPath = 'lib/app/pages/$pageFileName';
  final isExist = Directory(pageDirectoryPath).existsSync();
  if (isExist) {
    print('Page already exists at: $pageDirectoryPath');
    return;
  }
  // Creates the directory structure for the new page
  final directory = await Directory(pageDirectoryPath).create(recursive: true);

  // Helper function to create and write a file
  Future<void> createFile(String filePath, String content) async {
    final File file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  // Create and write the bindings file
  final String bindingContent = '''import 'package:get/get.dart';
import '/app/pages/$pageFileName/controllers/${pageFileName}_controller.dart';

class ${pageClassName}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${pageClassName}Controller>(
      () => ${pageClassName}Controller(),
      fenix: true,
    );
  }
}
  ''';
  await createFile(
    '$pageDirectoryPath/bindings/${pageFileName}_binding.dart',
    bindingContent,
  );

  // Create and write the controller file
  final String controllerContent = '''import 'package:get/get.dart';
  import '/app/core/base/base_controller.dart';
  
class ${pageClassName}Controller extends BaseController {
 @override
  Future<void> onInit() async {
    super.onInit();
  }

}
  ''';
  await createFile(
    '$pageDirectoryPath/controllers/${pageFileName}_controller.dart',
    controllerContent,
  );

  // Create and write the views file
  final String viewsContent = '''import 'package:flutter/material.dart';
import '/app/core/base/base_view.dart';
import '/app/pages/$pageFileName/controllers/${pageFileName}_controller.dart';

//ignore: must_be_immutable
class ${pageClassName}View extends BaseView<${pageClassName}Controller> {
  ${pageClassName}View({super.key});
    
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }
  
  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
  ''';
  await createFile(
    '$pageDirectoryPath/views/${pageFileName}_view.dart',
    viewsContent,
  );
  final lowerCamelCasePageFileName = lowerCamelCase(pageFileName);


  // Print the necessary route and path constants

  print(
    '''import '/app/pages/$pageFileName/bindings/${pageFileName}_binding.dart';
      import '/app/pages/$pageFileName/views/${pageFileName}_view.dart';''',
  );

  print('''
  GetPage(
    name: Routes.$lowerCamelCasePageFileName,
    page: () => ${pageClassName}View(),
    binding: ${pageClassName}Binding(),
  ),
  ''');


  print(
    "static const  $lowerCamelCasePageFileName = '/$pageFileName';",
  );
  print(
    'static const  $lowerCamelCasePageFileName = _Paths.$lowerCamelCasePageFileName;',
  );

  print(
    'Page created at: $pageDirectoryPath',
  );

  return;
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

String fileName(String input) {
  return input.toLowerCase().replaceAll(' ', '_');
}

String className(String input) {
  final List<String> words = input.split('_');
  final List<String> capitalizedWords = words.map((word) {
    return word.capitalize();
  }).toList();
  return capitalizedWords.join();
}

String lowerCamelCase(String input) {
  final List<String> words = input.split('_');
  final List<String> capitalizedWords = words.map((word) {
    return word.capitalize();
  }).toList();
  final String firstWord = capitalizedWords.removeAt(0).toLowerCase();
  capitalizedWords.insert(0, firstWord);
  return capitalizedWords.join();
}
