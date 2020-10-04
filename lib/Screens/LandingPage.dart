import 'package:flutter/material.dart';
import 'UploadScreen.dart';
import 'DownloadFile.dart';


class LandingScren extends StatefulWidget {
  static String ID="LandingScreen";

  @override
  _LandingScrenState createState() => _LandingScrenState();
}

class _LandingScrenState extends State<LandingScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doc_Case"
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                child:Container(
                  child: Text(
                    "Upload Files"
                  ),

                )
              ),
            ),
            Expanded(
             child: Row(
                children: [

                ],
              )
            ),
            Expanded()
          ],
        ),
      ),
    );
  }
}
