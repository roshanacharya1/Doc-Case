import 'package:doc_case_beta/Screens/LandingPage.dart';
import 'package:doc_case_beta/Screens/UploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DownloadFile.dart';
import 'package:doc_case_beta/Constants.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text("Register",style: TextStyle(
                color: Color(0xff080E2D),
                fontSize: 60,
                fontWeight: FontWeight.w900
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value){
                  setState(() {
                    _Email=value;
                  });
                },

                decoration:kimputTextdecoration.copyWith(hintText: "Email Id")
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.center,
                  onChanged: (value){
                _Password=value;
              },    decoration:kimputTextdecoration.copyWith(hintText: "Password")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Color(0xff080D2E),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("Register",style: TextStyle(color: Colors.white,fontSize: 30),),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: (){
                  try {
                    final user = _auth.createUserWithEmailAndPassword(
                        email: _Email, password: _Password);
                    if(user!=null){
                      Navigator.pushNamed(context, LandingScren.ID);
                    }
                  }
                  catch(e){
                    print(e);
                  }
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}
