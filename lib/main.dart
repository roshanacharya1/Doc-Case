import 'package:flutter/material.dart';
import 'package:doc_case_beta/Screens/RegistrationScreen.dart';
import 'package:doc_case_beta/Screens/UploadScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:doc_case_beta/Screens/UploadScreen_Beta.dart';
import 'package:doc_case_beta/Screens/DownloadFile.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute:RegistrationScreen.ID ,
      routes: ({
        RegistrationScreen.ID:(context)=>RegistrationScreen(),
        UploadFile.ID:(context)=>UploadFile(),
        FilePickerDemo.Id:(context)=>FilePickerDemo(),
        DownloadScreen.Id:(context)=>DownloadScreen(),

      }),
    );
  }
}
