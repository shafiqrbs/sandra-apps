import 'package:sandra/app/core/importer.dart';

class TabSwitcherExample extends StatefulWidget {
  @override
  _TabSwitcherExampleState createState() => _TabSwitcherExampleState();
}

class _TabSwitcherExampleState extends State<TabSwitcherExample> {
  int _selectedIndex = 0;

  // List of tabs and corresponding content
  final List<String> _tabs = ["Tab 1", "Tab 2", "Tab 3"];
  final List<Widget> _tabContents = [
    Center(child: Text("Content for Tab 1")),
    Center(child: Text("Content for Tab 2")),
    Center(child: Text("Content for Tab 3")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab Animation Example')),
      body: Column(
        children: [
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_tabs.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedIndex == index ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _tabs[index],
                    style: TextStyle(
                      color:
                          _selectedIndex == index ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 20),

          // Tab Content
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Animation effect when switching content
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: _tabContents[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
