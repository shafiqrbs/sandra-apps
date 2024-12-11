import 'package:flutter/foundation.dart';
import 'package:sandra/app/core/importer.dart';

/// ASController provides state management for a custom dropdown widget.
class ASController<T> extends ChangeNotifier {
  final ValueNotifier<List<T>?> _itemsNotifier = ValueNotifier<List<T>?>(null);
  final ValueNotifier<List<T>?> _filteredItems = ValueNotifier<List<T>?>(null);
  final ValueNotifier<T?> _selectedValueNotifier = ValueNotifier<T?>(null);

  ASController(
    List<T>? initialItems, {
    T? initialValue,
  }) {
    _itemsNotifier.value = initialItems;
    _filteredItems.value = initialItems;
    _selectedValueNotifier.value = initialValue;
  }

  List<T>? get items => _itemsNotifier.value;
  set items(List<T>? value) {
    _itemsNotifier.value = value;
    notifyListeners();
  }

  List<T>? get filteredItems => _filteredItems.value;
  set filteredItems(List<T>? value) {
    _filteredItems.value = value;
  }

  T? get selectedValue => _selectedValueNotifier.value;
  set selectedValue(T? value) {
    _selectedValueNotifier
      ..value = value
      ..notifyListeners();
    notifyListeners();

    if (kDebugMode) {
      print('selectedValue: $value');
    }
  }

  void clear() {
    _selectedValueNotifier.value = null;
  }

  void dispose() {
    _itemsNotifier.dispose();
    _filteredItems.dispose();
    _selectedValueNotifier.dispose();
    super.dispose();
  }

  Future<void> search(
    String value,
    final String Function(T) itemToString,
  ) async {
    try {
      if (value.isEmpty) {
        _filteredItems.value = items;
      } else {
        _filteredItems.value = items
            ?.where(
              (T element) => itemToString(element)
                  .toLowerCase()
                  .contains(value.toLowerCase()),
            )
            .toList();
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error during search: $e');
      }
    }
  }
}
