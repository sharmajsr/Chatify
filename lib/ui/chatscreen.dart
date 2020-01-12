import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  String gid, loggedInUid, name, uid;

  ChatScreen(this.gid, this.loggedInUid, this.uid, this.name);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Map data;
  int messageCount;
  int unreadMessage;
  Map setData;




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

  Future<Map> getMessageCount() async {
    DataSnapshot Snapshot = await FirebaseDatabase.instance
        .reference()
        .child('users/umessages/')
        .once()
        .catchError((e) {
      print('Error message' + e);
      return 0;
    });
    int mCount;
    //print('value');
    print(Snapshot.value);
    print('\n\n');
    Map myData={};
  //  try {
    print('widget.gid' + widget.gid);
      if (Snapshot.value.containsKey(widget.gid)) {
        myData = Snapshot.value[widget.gid];
        print('ispresnt');
      }
//    }catch(e){
//      myData={};
//    }

//    print(snapshot[widget.loggedInUid]);
//    if(snapshot[widget.loggedInUid]==null)  mCount=0;
//    mCount=snapshot[widget.loggedInUid];
    print('Value of my data');
    print(myData);
    print('\n\n');
    return myData;
  }

  Future<void> sendData(String text) async {

    setData = await getMessageCount();
    print(setData);
    print('\n\n');
    String m='',n='';
    int val=1;
    if(setData.isNotEmpty) {
      print('Im here ');
      m = setData[widget.loggedInUid];
      n = setData[widget.uid];
      val = int.parse(m);
      val=val+1;
    }


    Map nyData;
    nyData={
      widget.uid: "0",
      widget.loggedInUid: "$val"
    };

    datab.reference()
        .child('users/umessages/' + widget.gid)
        .set(nyData).catchError((e){print(e);}).then((x){
           //   print(myData);
    });

    Map data;
    data = {"sender": widget.loggedInUid, "message": text};
    datab.reference().child('messages/' + widget.gid).push().set(data);

//    getMessageCount();
    //   messageCount=0;
  //  print('Widget.uid ' + widget.loggedInUid);
//    m=m+1;
//    myData={
//      widget.uid: "$setData[widget.uid]",
//      widget.loggedInUid: "$m"
//    };
   // datab.reference().child('users/umessages/' + widget.gid).set(myData);
    print('umessage  written');
  }
}
