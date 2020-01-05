import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:metaeducator/ui/chatscreen.dart';
import 'package:metaeducator/ui/dashboard.dart';

class Home extends StatefulWidget {
  String myuid;

  Home(this.myuid);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final datab = FirebaseDatabase.instance;
  Map data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: firebaseList(),
    );
  }

  Widget contactCard(Map data) {
    return InkWell(
      onTap: () {
        String uid = data['uid'];
        String loggedInUid = widget.myuid;

        String gid;
        int i;

        i = uid.compareTo(loggedInUid);
        gid = i == 1 ? uid + loggedInUid : loggedInUid + uid;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(gid, loggedInUid, data['name']),
            ));
      },
      child: ListTile(
        leading: CircleAvatar(
          child: Text(data['name'][0]),
        ),
        title: Text(data['name']),
      ),
    );
  }

  Widget firebaseList() {
    return FirebaseAnimatedList(
        defaultChild: Center(child: CircularProgressIndicator()),
        //Center(child: CircularProgressIndicator()),
        query: datab.reference().child('users/'),
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          data = snapshot.value;
          print(data);
          //  print('${data['sender']} ${data['message']}');
          //print(widget.myuid);
          if (data['uid'] == widget.myuid) return Container();
          return contactCard(data);
        });
  }
}
