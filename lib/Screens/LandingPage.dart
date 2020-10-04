import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UploadScreen.dart';
import 'DownloadFile.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingScren extends StatefulWidget {
  static String ID = "LandingScreen";

  @override
  _LandingScrenState createState() => _LandingScrenState();
}

class _LandingScrenState extends State<LandingScren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff080D2E),
        title: Text(
          "Doc_Case",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(

              child: Padding(

                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(

                    onTap: () {
                      Navigator.pushNamed(context, UploadFile.ID);
                    },
                    child: Container(

                      decoration: BoxDecoration(

                          color: Color(0xff1D1F33),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Upload Files",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900),
                            ),
                            Icon(
                              Icons.cloud_upload,
                              color: Colors.white,
                              size: 60,
                            )
                          ],
                        ),
                      ),
                    )),
              ),
            ),
            Expanded(
                child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    const url = 'https://www.medlife.com/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff1D1F33),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                            child: Text(
                          "MedLife",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ))),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    const url = 'https://www.netmeds.com/';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff1D1F33),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                            child: Text("NetMeds",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30)))),
                  ),
                )),
              ],
            )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, DownLoadScren.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff1D1F33),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("DownLoad Files",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 50,
                              )),
                          Icon(Icons.cloud_download,
                              color: Colors.white, size: 60)
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
