import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:sandra/app/core/importer.dart';

final dropDownDecoration = CustomDropdownDecoration(
  closedFillColor: const Color(0xFFF3F3F3),
  expandedFillColor: Colors.white,
  closedSuffixIcon: const Icon(
    Icons.keyboard_arrow_down,
    color: Colors.black,
  ),
  expandedSuffixIcon: const Icon(
    Icons.keyboard_arrow_up,
    color: Colors.grey,
  ),
  searchFieldDecoration: SearchFieldDecoration(
    fillColor: const Color(0xFFF3F3F3),
    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
    hintStyle: TextStyle(color: Colors.grey[400]),
    textStyle: const TextStyle(color: Colors.black),
    border: const OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      borderSide: BorderSide(
        color: Colors.green,
      ),
    ),
    suffixIcon: (onClear) {
      return GestureDetector(
        onTap: onClear,
        child: Icon(Icons.close, color: Colors.grey[400]),
      );
    },
  ),
  listItemDecoration: ListItemDecoration(
    selectedColor: Colors.grey[900],
    highlightColor: Colors.grey[800],
  ),
  closedBorder: Border.all(
    color: Colors.grey,
    width: 1,
  ),
  closedBorderRadius: const BorderRadius.all(
    Radius.circular(4),
  ),
);
