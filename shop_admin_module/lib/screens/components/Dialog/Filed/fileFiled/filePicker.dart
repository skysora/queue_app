import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/fileFiled/fileList.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({
    Key? key,
    required this.required,
    required this.title,
    required this.type,
    required this.textController,
    required this.mutiFile,
    required this.readOnly,
    required this.add,
  }) : super(key: key);
  final bool add;
  final bool required;
  final String title;
  final String type;
  final List<PlatformFile> textController;
  final bool mutiFile;
  final bool readOnly;
  @override
  _FilePickerDemoState createState() => _FilePickerDemoState(
      required, title, type, textController, mutiFile, readOnly, add);
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  List<PlatformFile> _paths = [];
  String? _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  List<bool> uploadFlag = [];
  List<PlatformFile> textController = [];
  List fileNames = [];
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  String tableName = "";
  bool add = false;
  _FilePickerDemoState(
      bool required,
      String title,
      String type,
      List<PlatformFile> textController,
      bool _multiPick,
      bool readOnly,
      bool add) {
    this.required = required;
    this.title = title;
    this.type = type;
    this._paths = textController;
    this.readOnly = readOnly;
    this._multiPick = _multiPick;
    this.add = add;
  }

  @override
  initState() {
    super.initState();

    // if (!add) {
    //   Server().getEditFile(tableName, title).then((result) {
    //     if (result['success']) {
    //       setState(() {
    //         for (var item in result['files']) {
    //           fileNames.add(item);
    //           uploadFlag.add(true);
    //         }
    //       });
    //     }
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  FileType setType(String type) {
    switch (type) {
      case "audio":
        return FileType.audio;
      case "image":
        return FileType.image;
      case "video":
        return FileType.video;
      case "media":
        return FileType.media;
      default:
        return FileType.any;
    }
  }

  _openFileExplorer(bool init) async {
    if (init) {
      _paths = [];
    }
    FilePickerResult? result;
    setState(() => _loadingPath = true);

    try {
      result = await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      );
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }

    setState(() {
      _loadingPath = false;
      if (result != null) {
        result.files.forEach((PlatformFile element) {
          this._paths.add(element);
          uploadFlag.add(false);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: defaultPadding,
        ),

        Builder(builder: (BuildContext context) {
          if (readOnly) {
            return SizedBox(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(title.toString())),
                ],
              ),
            );
          } else {
            return SizedBox(
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(title.toString())),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: FromTextFieldWidth * 0.9,
                      child: ElevatedButton(
                        onPressed: () async {
                          _openFileExplorer(false);
                        },
                        child: const Text("Open file picker"),
                      ))
                ],
              ),
            );
          }
        }),
        //fileList
        Builder(
            builder: (BuildContext context) => _loadingPath
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: const CircularProgressIndicator(),
                  )
                : uploadFlag.isNotEmpty
                    ? FileList(
                        fileNames: fileNames,
                        files: _paths,
                        uploadFlag: uploadFlag,
                        textController: textController,
                      )
                    : const SizedBox()),
        // 如果是多個檔案上傳
        if (_multiPick && uploadFlag.isNotEmpty && !readOnly)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _openFileExplorer(false),
                child: const Text("ADD"),
              ),
              SizedBox(
                width: defaultPadding,
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     var count = 0;
              //     for (int index = 0; index < _paths.length; index++) {
              //       var res = await Server().uploadSelectedFile(_paths[index]);
              //       var body = json.decode(res);
              //       if (body['success']) {
              //         setState(() {
              //           uploadFlag[index] = true;
              //           count = count + 1;
              //         });
              //         // CostomAlterDiaglogState().showDialogBox(
              //         //     context, body['message'], "Susses Message");
              //       } else {
              //         CostomAlterDiaglogState().showDialogBox(
              //             context, body['message'], "Error Message");
              //       }
              //       if (count == _paths.length - 1) {
              //         CostomAlterDiaglogState().showDialogBox(
              //             context, body['message'], "Susses Message");
              //       }
              //     }
              //   },
              //   child: const Text("Upload All"),
              // ),
            ],
          )
      ],
    );
  }
}
