import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/Dialog/customAlterDialog.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Upload Image'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PlatformFile> _paths = [];
  var resJson;

  onUploadImage() async {
    print(_paths.length);
    // for (int index = 0; index < _paths.length; index++) {
    //   var res = await Server().uploadSelectedFile(_paths[index]);
    //   var body = json.decode(res);
    //   if (body['success']) {

    //     // CostomAlterDiaglogState().showDialogBox(
    //     //     context, body['message'], "Susses Message");
    //   } else {
    //     CostomAlterDiaglogState()
    //         .showDialogBox(context, body['message'], "Error Message");
    //   }
    // }
  }

  void getImage() async {
    List<PlatformFile>? tempPaths;
    tempPaths = (await FilePicker.platform.pickFiles(
      onFileLoading: (FilePickerStatus status) => print(status),
      withReadStream:
          true, // this will return PlatformFile object with read stream
    ))
        ?.files;
    if (!mounted) return;
    setState(() {
      if (tempPaths != null) {
        tempPaths.forEach((element) {
          _paths.add(element);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // file == null
            //     ? Text(
            //         'Please Pick a image to Upload',
            //       )
            //     : Image.file(file),
            RaisedButton(
              color: Colors.green[300],
              onPressed: onUploadImage,
              child: Text(
                "Upload",
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Text(resJson['message'] ?? "")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Increment',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
