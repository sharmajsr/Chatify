import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String gid, loggedInUid, name;

  ChatScreen(this.gid, this.loggedInUid, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Map data;
  TextEditingController messageController = TextEditingController();
  String p = 'message';
  final database = FirebaseDatabase.instance.reference();
  final datab = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: firebaseList()),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                    ),
                    controller: messageController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    child: Icon(
                      Icons.send,
                      size: 40,
                    ),
                    onTap: () {
                      sendData(messageController.text);
                      messageController.clear();
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget message(String id, String s) {
    if (id != widget.loggedInUid) {
      return Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: Text(s),
          ),
          Spacer()
        ],
      );
    } else
      return Row(
        children: <Widget>[
          Spacer(),
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.lightGreenAccent,
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
            ),
            child: Text(s),
          )
        ],
      );
  }

  Widget firebaseList() {
    return FirebaseAnimatedList(
        defaultChild: Center(child: CircularProgressIndicator()),
        //Center(child: CircularProgressIndicator()),
        query: datab.reference().child('messages/' + widget.gid),
        itemBuilder:
            (_, DataSnapshot snapshot, Animation<double> animation, int index) {
          data = snapshot.value;

          return message(data['sender'], data['message']);
        });
  }

  void sendData(String text) {
    Map data;
    data = {"sender": widget.loggedInUid, "message": text};
    datab.reference().child('messages/' + widget.gid).push().set(data);
  }
}
