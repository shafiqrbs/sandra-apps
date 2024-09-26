import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:sandra/app/core/widget/quick_navigation_button.dart';

class AnimatedSearchBar extends StatefulWidget {
  TextEditingController controller;
  bool isSearchOpen;
  Function(String value)? onSearch;
  AnimatedSearchBar({
    required this.controller,
    required this.isSearchOpen,
    required this.onSearch,
  });
  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  bool _isSearchOpen = false;
  TextEditingController _controller = TextEditingController();
  final double _textFieldHeight = 48.0;
  final double _containerBorderRadius = 12.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSearchOpen = widget.isSearchOpen;
    _controller = widget.controller;
  }

  void _toggleSearch() {
    setState(() {
      _isSearchOpen = !_isSearchOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!_isSearchOpen)
          IconButton(
            icon: Icon(TablerIcons.search, color: Colors.black),
            onPressed: _toggleSearch,
          ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _isSearchOpen ? MediaQuery.of(context).size.width - 20 : 0,
          child: Container(
            margin: const EdgeInsets.only(left: 2),
            height: _textFieldHeight,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(
                _containerBorderRadius,
              ),
            ),
            child: _isSearchOpen
                ? TextFormField(
                    controller: _controller,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        TablerIcons.search,
                        color: Colors.black,
                        size: 18,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Voice recognition code here
                            },
                            icon: Icon(
                              TablerIcons.microphone,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Filter code here
                            },
                            icon: Icon(
                              TablerIcons.filter,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {});
                              _isSearchOpen = false;
                              _controller.clear();
                            },
                            icon: Icon(
                              TablerIcons.x,
                              color: Colors.grey.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      hintText: appLocalization.hint,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: Color(0xFFece2d9),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Color(0xFFf5edeb),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                        borderSide: const BorderSide(
                          color: Color(0xFFf5edeb),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
