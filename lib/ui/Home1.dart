import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:metaeducator/ui/chatscreen.dart';
import 'package:metaeducator/ui/home.dart';

class Dashboard extends StatefulWidget {
  String myuid;
  String y;

  Dashboard(this.myuid);
  //Dashboard(String myuid) : y = myuid;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  String uid='';
  @override
  void initState() {
    super.initState();
    print('Hello asdasd    '+widget.myuid);
    // uid = widget.myuid;
    _tabController = TabController(vsync: this, length: _tabList.length);
  }

  int _currentIndex = 0;

  List<Widget> _tabList = [
    Home('9k7VctjkU4YKyahBAnbQQO6B9q12'),
    ChatScreen('1','1','shubham'),
  ];

  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (currentIndex) {
          setState(() {
            _currentIndex = currentIndex;
          });

          _tabController.animateTo(_currentIndex);
        },
        items: [
          BottomNavigationBarItem(title: Text("Home"), icon: Icon(Icons.home)),
          BottomNavigationBarItem(title: Text("Chat"), icon: Icon(Icons.chat)),
        ],
      ),
    );
  }
}
