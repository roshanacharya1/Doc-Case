import 'package:flutter/material.dart';
import 'package:doc_case_beta/Screens/RegistrationScreen.dart';
import 'package:doc_case_beta/Screens/UploadScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:doc_case_beta/Screens/DownloadFile.dart';
import 'package:doc_case_beta/Screens/LandingPage.dart';
import 'package:doc_case_beta/Screens/SignIn.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:LoginScreen.id ,
      routes: ({
        RegistrationScreen.ID:(context)=>RegistrationScreen(),
        UploadFile.ID:(context)=>UploadFile(),
        DownLoadScren.id:(context)=>DownLoadScren(),
        LandingScren.ID:(context)=>LandingScren(),
        LoginScreen.id:(context)=>LoginScreen()

      }),
    );
  }
}
