import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;
String CurrentUser;

class DownloadScreen extends StatefulWidget {
  static String Id="DownloadScreen";
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
final _auth =FirebaseAuth.instance;


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
        CurrentUser = user.email;

        print(CurrentUser);
      }
    } catch (e) {
      print(e);
    }
  }

  void getUrl() async {
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
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            color: Colors.teal,

            onPressed: (){
              UrlStreams();

            },
          )
        ],
      ),
    );
  }
}

class UrlStreams extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Urls').snapshots(),
      builder: (context, snapshot) {
        // ignore: deprecated_member_use
        final messages = snapshot.data.documents.reversed;
        List<ImageBubbles> ImageWidgets = [];
        for (var message in messages) {
          if(message==null){
            return CircularProgressIndicator();
          }
          // ignore: missing_return
          final messageText = message.data()['Url'];
          final messageSender = message.data()['User'];
          final curr=CurrentUser;
          bool userq;
          userq=messageSender==curr;
          final messageBubble = ImageBubbles(
              text: messageText,
              sender: messageSender,
              userq:userq
          );
          ImageWidgets.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: ImageWidgets,
          ),
        );
      },
    );
  }
}


class ImageBubbles extends StatelessWidget {
  ImageBubbles({this.text, this.sender,this.userq});
  final String text;
  final String sender;
  final bool userq;
  @override
  Widget build(BuildContext context) {
   if(userq) {
     return Padding(

       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
       child: Column(
         crossAxisAlignment: userq ? CrossAxisAlignment.end : CrossAxisAlignment
             .start,
         children: [
           Text(
             sender,
             style: TextStyle(
               color: Colors.black54,
             ),
           ),
           Material(
             elevation: 10,
             borderRadius: userq ? BorderRadius.only(
                 topLeft: Radius.circular(30.0),
                 bottomRight: Radius.circular(30.0),
                 bottomLeft: Radius.circular(30.0)) : BorderRadius.only(
                 topRight: Radius.circular(30.0),
                 bottomRight: Radius.circular(30.0),
                 bottomLeft: Radius.circular(30.0)),
             color: userq ? Colors.lightBlueAccent : Colors.white,
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
               child: Text(
                 text,
                 style: TextStyle(
                     fontSize: 15, color: userq ? Colors.white : Colors.black),
               ),
             ),
           ),
         ],
       ),
     );
   }
  }
}
