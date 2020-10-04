
import 'package:doc_case_beta/Screens/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'RegistrationScreen.dart';
import 'package:doc_case_beta/Constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'Login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool Spinnerauth=false;
  final _auth = FirebaseAuth.instance;
  String Password;
  String Email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text("Sign in",style:TextStyle(
                    color: Color(0xff080E2D),
                    fontWeight: FontWeight.w900,
                    fontSize: 60
                  ) ),
                ),
              ),

              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  Email = value;
                },
                decoration: kimputTextdecoration.copyWith(
                  hintText: 'Enter E-mail id',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  Password = value;
                },
                decoration: kimputTextdecoration.copyWith(hintText: 'Enter Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Login",style:TextStyle(
                    color:Colors.white,
                    fontSize: 30,
                  )),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                color: Color(0xff080D2E),
                onPressed: () async{

                  try {
                    final user = await  _auth.signInWithEmailAndPassword(
                        email: Email, password: Password);

                    if (user.user != null) {
                      Navigator.pushNamed(context, LandingScren.ID);
                    }
                  } catch (e) {
                    print(e);
                  }

                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:10.0),
                child: FlatButton(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Register",style: TextStyle(color: Colors.white,fontSize: 30),),
                  ),
                  color: Color(0xff080D2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  onPressed: (){
                    Navigator.pushNamed(context, RegistrationScreen.ID);
                  },

                ),
              )
            ],
          ),

      ),
    );
  }
}
