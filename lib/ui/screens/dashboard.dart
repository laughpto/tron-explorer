import 'package:flutter/material.dart';
import 'blocks.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();

  Widget build(BuildContext context) {
    return Dashboard();
  }
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<Widget> _sections = <Widget>[
    BlocksList(),
    Text(
      'Smart Contract',
    ),
    Text(
      'Address Detail',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _sections.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: 'Blocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner),
            label: 'Smart Contract',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Address',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
