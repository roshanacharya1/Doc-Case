import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = Firestore.instance;
class UploadFile extends StatefulWidget {
  static String ID = "UploadFile";
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {

  final _auth = FirebaseAuth.instance;
// ignore: deprecated_member_use
String currentuuser;
  @override


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



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  List _tasks=[];
  FileType _pickType = FileType.any;
  TextEditingController _controller = TextEditingController();
  dropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: DropdownButton(
          hint: Text('LOAD PATH FROM'),
          value: _pickType,
          items: <DropdownMenuItem>[
            DropdownMenuItem(
              child: Text('FROM AUDIO'),
              value: FileType.audio,
            ),
            DropdownMenuItem(
              child: Text('FROM IMAGE'),
              value: FileType.image,
            ),
            DropdownMenuItem(
              child: Text('FROM VIDEO'),
              value: FileType.video,
            ),
            DropdownMenuItem(
              child: Text('FROM MEDIA'),
              value: FileType.media,
            ),
            DropdownMenuItem(
              child: Text('FROM ANY'),
              value: FileType.any,
            ),
            DropdownMenuItem(
              child: Text('CUSTOM FORMAT'),
              value: FileType.custom,
            ),
          ],
          onChanged: (value) => setState(() {
                _pickType = value;
                if (_pickType != FileType.custom) {
                  _controller.text = _extension = '';
                }
              })),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
    currentuser();
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickType,
        allowMultiple: _multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  uploadToFirebase() {
    _paths.forEach((filename) {
      uploadfile(filename.name, filename.path);

    });
  }

  uploadfile(filename, filepath) {
    _extension = filename.toString().split('.').last;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(filepath);
    final StorageUploadTask uploadTask = storageReference.putFile(
        File(filepath), StorageMetadata(contentType: '$_pickType/$_extension'));
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  downloadFile(StorageReference ref)async {
    final String url = await ref.getDownloadURL();
    _firestore
        .collection('Urls')
        .add({'text': url, 'user': currentuuser});
    final http.Response downloadData= await http.get(url);
    final Directory systemTempDir=Directory.systemTemp;
    final File tempFile=File('${systemTempDir.path}/tmp.jpg');
    if(tempFile.existsSync()){
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task =ref.writeToFile(tempFile);
    final int bytecount=(await task.future).totalByteCount;
    var bodyBytes= downloadData.bodyBytes;
    final String name =await ref.getName();
    final String path =await ref.getPath();
    print("Success\nDownloaded $name\nUrl:$url\npath:$path\nBytes Count:$bytecount");
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      content: Image.memory(bodyBytes,fit: BoxFit.fill,),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

      _tasks.forEach((task) {
        final Widget tile = UploadTaskListTile(
          task: task,
          onDismissed: () {
            setState(() {
              _tasks.remove(task);
            });
          },
          onDownload: () {
            downloadFile(task.lastSnapshot.ref);
          },
        );
        children.add(tile);
      });
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                dropdown(),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 100.0),
                  child: _pickType == FileType.custom
                      ? TextFormField(
                          maxLength: 15,
                          autovalidate: true,
                          controller: _controller,
                          decoration:
                              InputDecoration(labelText: 'File extension'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                        )
                      : const SizedBox(),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 200.0),
                  child: SwitchListTile.adaptive(
                    title:
                        Text('Pick multiple files', textAlign: TextAlign.right),
                    onChanged: (bool value) =>
                        setState(() => _multiPick = value),
                    value: _multiPick,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => _openFileExplorer(),
                        child: Text("Open file picker"),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: children,
                  ),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile({this.task, this.onDismissed, this.onDownload});
  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;
  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = "complete";
      } else if (task.isCanceled) {
        result = "cancelled";
      } else {
        result = "Failed error ${task.lastSnapshot.error}";
      }
    } else if (task.isInProgress) {
      result = "Uploading";
    } else if (task.isPaused) {
      result = "paused";
    }
    return result;
  }

  String bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status ${bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text("Starting....");
        }
        return Dismissible(
          key:Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: Icon(Icons.file_download),
                    onPressed: () => onDownload(),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
