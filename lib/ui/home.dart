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
  Map unreadMessages;

  @override
  initState() {
    super.initState();
    // Add listeners to this class
   // unreadMessagesf();

  }

  unreadMessagesf() async {
    unreadMessages = (await FirebaseDatabase.instance
        .reference()
        .child('users/umessages/')
        .once()
        .catchError((e) {
      print('Error message' + e);

    })).value;
    print(unreadMessages);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: firebaseList(),
    );
  }
   calculateGid(Map data){
     String uid = data['uid'];
     String loggedInUid = widget.myuid;

     String gid;
     int i;

     i = uid.compareTo(loggedInUid);
     gid = i == 1 ? uid + loggedInUid : loggedInUid + uid;
     return gid;
  }

  Widget contactCard(Map data,String p) {
    return InkWell(
      onTap: () async {
        String loggedInUid = widget.myuid;
        String uid = data['uid'];
        String gid;
        gid= await calculateGid(data);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(gid, loggedInUid,uid, data['name']),
            ));
      },
      child: ListTile(
        trailing: CircleAvatar(
        child: Text(p),
      ),
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
          if(data['email'] == 'pq' ){
            unreadMessages = data;
            return Container();
          }


          if (  data['uid'] == widget.myuid  ) return Container();
          String gid;
          Map myData;
          String p='';
          gid =  calculateGid(data);
          unreadMessagesf();
          if (unreadMessages.containsKey(gid)) {
            myData = unreadMessages[gid];
            p = myData[data['uid']];
            print('ispresnt');
          }

          return contactCard(data,p);
        });
  }
}
