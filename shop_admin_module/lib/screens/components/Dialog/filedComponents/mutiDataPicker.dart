import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class MutiDataPicker extends StatefulWidget {
  const MutiDataPicker({
    Key? key,
    required this.dataTableManage,
    required this.objects,
    required this.textController,
    required this.type,
  }) : super(key: key);
  final objects;
  final textController;
  final type;
  final DataTableSource dataTableManage;
  @override
  _MutiDataPickerState createState() =>
      _MutiDataPickerState(objects, textController, type, dataTableManage);
}

class _MutiDataPickerState extends State<MutiDataPicker> with ChangeNotifier {
  List textEditingControllers = [];
  var objects;
  late String type;
  late List tags = [];
  int rowLimit = 4;
  late Map<String, dynamic> dataColumnType;
  late MyDataTableData dataTableManage;
  _MutiDataPickerState(objects, textController, type, dataTableManage) {
    this.objects = objects;
    this.dataColumnType = json.decode(jsonEncode(this.objects["item"]));
    this.textEditingControllers = textController;
    reloadData();
    this.type = type;
    this.dataTableManage = dataTableManage;
  }
  @override
  Widget build(BuildContext context) {
    String title = objects["title"].toString();
    bool required = objects["required"];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(title)),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: FromTextFieldWidth * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int i = 0; i < this.tags.length; i++)
                Row(
                  children: [
                    for (int j = 0; j < this.tags[i].length; j++)
                      Builder(builder: (BuildContext context) {
                        return InkWell(
                          onTap: () {
                            editData(i, j);
                          },
                          child: Container(
                              width: 100,
                              margin: EdgeInsets.only(left: defaultPadding / 4),
                              padding: const EdgeInsets.all(defaultPadding / 4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFE0E0E0))),
                              child: Center(
                                child: Text(
                                    this.tags[i][j]["word"].text.toString(),
                                    style: listViewLabelStyle),
                              )),
                        );
                      }),
                  ],
                ),
            ],
          ),
        ),
        SizedBox(
          width: FromTextFieldWidth * 0.1,
        ),
        ElevatedButton(
          onPressed: () async {
            final _formKey = GlobalKey<FormState>();
            Map<String, dynamic> localStorage_keys = {};
            var keys = this.dataColumnType.keys;
            Map<String, dynamic> temp_textEditingController = {};
            temp_textEditingController = TextEditingControllerCreate(
                localStorage_keys,
                keys,
                temp_textEditingController,
                this.dataColumnType);
            var data = await showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(defaultPadding),
                  title: new Text("新增資料"),
                  content: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (final key in keys)
                                Builder(builder: (context) {
                                  if (dataColumnType[key]["createDisplay"]) {
                                    return ObjectFactory().generateDialogFiled(
                                        this.dataColumnType[key],
                                        key,
                                        temp_textEditingController[key]!,
                                        "create",
                                        dataTableManage);
                                  } else {
                                    return SizedBox();
                                  }
                                })
                            ],
                          ),
                        )),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context, "cancel");
                        }),
                    new FlatButton(
                        child: const Text('Add'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            var row = TextEditingControllerToJson(
                                keys, temp_textEditingController);
                            print(row);
                          }
                          Navigator.pop(context, temp_textEditingController);
                        })
                  ],
                );
              },
            );
            if (data == "cancel") {
            } else {
              setState(() {
                this.textEditingControllers.add(data);
                this.reloadData();
              });
            }
          },
          child: Icon(Icons.add),
        )
      ],
    );
  }

  getlocalStorage(keys) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localStorage_keys = localStorage.getKeys();

    Map<String, dynamic> res = {};
    for (final localStorage_key in localStorage_keys) {
      if (keys.contains(localStorage_key)) {
        res[localStorage_key.toString()] =
            localStorage.getString(localStorage_key.toString());
      }
    }
    return res;
  }

  editData(i, j) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: new Text("新增資料"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final key in this.tags[i][j].keys)
                        Builder(builder: (context) {
                          return ObjectFactory().generateDialogFiled(
                              dataColumnType[key],
                              key,
                              this.textEditingControllers[i * this.rowLimit + j]
                                  [key],
                              "edit",
                              dataTableManage);
                        })
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Delete'),
                onPressed: () {
                  setState(() {
                    this.textEditingControllers.removeAt(i * this.rowLimit + j);
                    this.reloadData();
                  });
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Add'),
                onPressed: () async {
                  var row = TextEditingControllerToJson(
                      this.dataColumnType.keys,
                      this.textEditingControllers[i * this.rowLimit + j]);
                  setState(() {
                    for (var key in row.keys) {
                      this
                          .textEditingControllers[i * this.rowLimit + j][key]
                          .text = row[key];
                    }
                  });

                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  reloadData() {
    this.tags = [];
    for (var i = 0; i < this.textEditingControllers.length; i += rowLimit) {
      var temp = (this.textEditingControllers.sublist(
          i,
          i + rowLimit > this.textEditingControllers.length
              ? this.textEditingControllers.length
              : i + rowLimit));
      this.tags.add(temp);
    }
  }

  TextEditingControllerToJson(keys, textEditingControllers) {
    var row = {};
    keys.forEach((key) {
      switch (textEditingControllers[key].runtimeType.toString()) {
        case 'TextEditingController':
          if (textEditingControllers[key]!.text == "true") {
            row[key] = "1";
          } else if (textEditingControllers[key]!.text == "false") {
            row[key] == "0";
          } else {
            row[key] = textEditingControllers[key]!.text;
          }
          break;
        case 'Null':
          break;
        default:
          row[key] = TextEditingControllerToJson(
              textEditingControllers[key].keys, textEditingControllers[key]);
      }
    });
    return row;
  }

  TextEditingControllerCreate(Map<String, dynamic> localStorage_keys, keys,
      temp_textEditingController, dataColumnType) {
    keys.forEach((str) {
      var textEditingController;
      try {
        if (dataColumnType[str]["type"].toString() == "group") {
          textEditingController = TextEditingControllerCreate(
              localStorage_keys,
              dataColumnType[str]["item"].keys,
              <String, dynamic>{},
              dataColumnType[str]["item"]);
        } else {
          textEditingController = new TextEditingController();
          if (localStorage_keys.keys.contains(str)) {
            if (localStorage_keys[str].toString().replaceAll("\"", "") !=
                "null") {
              textEditingController.text =
                  localStorage_keys[str].toString().replaceAll("\"", "");
            }
          }
        }
      } catch (e) {
        textEditingController = new TextEditingController();
      }
      if (dataColumnType[str]["createDisplay"]) {
        temp_textEditingController.putIfAbsent(
            str, () => textEditingController);
      }
    });
    return temp_textEditingController;
  }
}
