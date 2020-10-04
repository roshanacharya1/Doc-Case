import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
String currentuuser;
class DownLoadScren extends StatefulWidget {
  static const String id = 'DownLoadScreen';
  @override
  _DownLoadScrenState createState() => _DownLoadScrenState();
}

class _DownLoadScrenState extends State<DownLoadScren> {
  String message;
  final textcontroller = TextEditingController();

// ignore: deprecated_member_use
  final _auth = FirebaseAuth.instance;
// ignore: deprecated_member_use

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentuser();
  }

  void currentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        currentuuser = user.email;

        print(currentuuser);
      }
    } catch (e) {
      print(e);
    }
  }

  void getmessage() async {
    await for (var snapshot in _firestore.collection('Urls').snapshots()) {
      // ignore: deprecated_member_use
      for (var mess in snapshot.documents) {
        print(mess.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Urls').snapshots(),
      builder: (context, snapshot) {
        // ignore: deprecated_member_use
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messagewidgets = [];
        for (var message in messages) {
          if(message==null){
            return CircularProgressIndicator();
          }
          // ignore: missing_return
          final messageText = message.data()['text'];
          final messageSender = message.data()['user'];
          final curr=currentuuser;
          bool userq;
          userq=messageSender==curr;
          if(userq){
          final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              userq:userq
          );
          messagewidgets.add(messageBubble);
        }}
        return Expanded(
          child: ListView(
            reverse: true,
            children: messagewidgets,
          ),
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender,this.userq});
  final String text;
  final String sender;
  final bool userq;
  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0)),
            color:Color(0xff080E2D),

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                text,
                style: TextStyle(fontSize: 15,color:Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
