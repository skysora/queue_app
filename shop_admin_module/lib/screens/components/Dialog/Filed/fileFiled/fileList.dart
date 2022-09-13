import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

import '../../customAlterDialog.dart';

class FileList extends StatefulWidget {
  const FileList({
    Key? key,
    required this.files,
    required this.fileNames,
    required this.uploadFlag,
    required this.textController,
  }) : super(key: key);
  final List<PlatformFile> files;
  final List fileNames;
  final List<bool> uploadFlag;
  final List<PlatformFile> textController;
  @override
  State<FileList> createState() =>
      FileListState(files, fileNames, uploadFlag, textController);
}

class FileListState extends State<FileList> {
  List<PlatformFile> files = [];
  List fileNames = [];
  List<bool> uploadFlag = [];
  List<PlatformFile> textController = [];
  FileListState(List<PlatformFile> files, List fileNames, List<bool> uploadFlag,
      textController) {
    this.files = files;
    this.fileNames = fileNames;
    this.uploadFlag = uploadFlag;
    this.textController = textController;
  }

  @override
  Widget build(BuildContext context) {
    double height = 80.0 * 3;
    if (this.files.length < 3) {
      height = 80.0 * this.files.length;
    }
    return Container(
      width: FromTextFieldWidth * 1.5,
      height: height,
      child: Scrollbar(
          child: ListView.separated(
        itemCount: files.length + fileNames.length,
        itemBuilder: (BuildContext context, int index) {
          String name;
          if (index < fileNames.length) {
            name = 'File $index: ' + '${fileNames[index]}';
          } else {
            name = 'File $index: ' + '${files[index - fileNames.length].name}';
          }
          if (!uploadFlag[index]) {
            return SizedBox(
                child: ListTile(
              title: Text(
                name,
              ),
              trailing: Wrap(
                spacing: 12, // space between two icons
                children: <Widget>[
                  // 刪除
                  IconButton(
                      onPressed: () {
                        setState(() {
                          files.removeAt(index - fileNames.length);
                          if (files.length == 0 && uploadFlag.length == 0) {
                            uploadFlag = [];
                            files = [];
                          }
                        });
                      },
                      icon: Icon(Icons.delete)), // icon-1
                  // 上傳
                  IconButton(
                      onPressed: () async {
                        //將回傳路徑放在name
                        textController.add(PlatformFile(
                          name: 'response_defaultPath',
                          size: 128,
                        ));
                        setState(() {
                          uploadFlag[index] = true;
                        });
                        // files[index - fileNames.length].name = "defaultPath";
                        // var res = await Server().uploadSelectedFile(
                        //     files[index - fileNames.length]);
                        // var body = json.decode(res);
                        // if (body['success']) {
                        //   setState(() {
                        //     uploadFlag[index] = true;
                        //   });
                        //   CostomAlterDiaglogState().showDialogBox(
                        //       context, body['message'], "Susses Message");
                        // } else {
                        //   CostomAlterDiaglogState().showDialogBox(
                        //       context, body['message'], "Error Message");
                        // }
                      },
                      icon: Icon(Icons.upload)), // icon-2
                ],
              ),
            ));
          } else {
            return SizedBox(
                child: ListTile(
              title: Text(
                name,
              ),
              trailing: Text("Uploaded"),
            ));
          }
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      )),
    );
  }
}
