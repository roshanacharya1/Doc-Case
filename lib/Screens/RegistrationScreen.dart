import 'package:doc_case_beta/Screens/UploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'UploadScreen_Beta.dart';
import 'DownloadFile.dart';

class RegistrationScreen extends StatefulWidget {

  static String ID='RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _Email;
  String _Password;
  final _auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value){
                setState(() {
                  _Email=value;
                });
              },

              decoration:InputDecoration(
                hintText: "User Id"
              ) ,
            ),
            TextField(  onChanged: (value){
              _Password=value;
            },    decoration:InputDecoration(
            hintText: "Password"),),
            FlatButton(
              color: Colors.teal,
              child: Text("Register"),
              onPressed: (){
                try {
                  final user = _auth.createUserWithEmailAndPassword(
                      email: _Email, password: _Password);
                  if(user!=null){
                    Navigator.pushNamed(context, DownloadScreen.Id);
                  }
                }
                catch(e){
                  print(e);
                }
                },
            )
          ],
        ),
      ),
    );
  }
}
