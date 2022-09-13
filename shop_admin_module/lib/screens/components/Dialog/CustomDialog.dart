import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/customAlterDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class CustomDialog extends StatefulWidget {
  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  bool fileFlag = false;
  showAddDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    var dataColumnType = dataManager.dataColumnType;
    var keys = dataColumnType.keys;
    textEditingControllers =
        TextAddControllerCreate(keys, textEditingControllers, dataColumnType);
    var response;
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final key in keys)
                        Builder(builder: (context) {
                          if (setting["dataColumnType"][key]["objectSetting"]
                              ["display"]["create"]) {
                            return ObjectFactory().generateDialogFiled(
                                dataColumnType[key],
                                key,
                                textEditingControllers[key]!,
                                "create",
                                dataManager);
                          } else {
                            return SizedBox();
                          }
                        })
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      response = "cancel";
                      Navigator.pop(context, dataManager);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        var row = TextEditingControllerToJson(
                            textEditingControllers, dataColumnType);
                        print("------create------");
                        print(setting["createAPI"]);
                        print(row);
                        var res = await Server()
                            .createRow(row, setting["API"]["main"]);
                        var body = json.decode(res.body);
                        print(body);
                        print("------create------");
                        if (body['status'] == "success") {
                          dataManager.addRow(row);
                          response = dataManager;
                          Navigator.pop(context, dataManager);
                        } else {
                          CostomAlterDiaglogState().showDialogBox(
                              context,
                              "Input:$row\nOutput:" + body.toString(),
                              "Error Message");
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
    return response;
  }

  showDeleteDialogBox(BuildContext context, setting, int index,
      MyDataTableData dataManager, bool backLastPage) async {
    // flutter defined function
    var res = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DeleteDiaglogTitle),
          content: Text(DeleteDiaglogContent),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                var primaryKey =
                    dataManager.data[index].data[setting["primaryKey"]];
                var res = await Server()
                    .deleteRow(setting["API"]["deleteAPI"] + primaryKey);
                var body = json.decode(res.body);
                if (body['status'] == "success") {
                  dataManager.deleteRow(setting["objectName"], index);
                  Navigator.pop(context, dataManager);
                } else {
                  CostomAlterDiaglogState()
                      .showDialogBox(context, body.toString(), "Error Message");
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "cancel");
              },
            ),
          ],
        );
      },
    );
    return res;
  }

  showEditDialogBox(BuildContext context, int index,
      MyDataTableData dataManager, setting) async {
    var dataColumnType = dataManager.dataColumnType;
    var keys = dataColumnType.keys;
    var data = dataManager.data;
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        Map<String, dynamic> textEditingControllers = {};
        final _formKey = GlobalKey<FormState>();
        textEditingControllers = TextEditingControllerCreate(
            textEditingControllers, dataColumnType, data[index].data);

        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
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
                          return ObjectFactory().generateDialogFiled(
                              dataColumnType[key],
                              key,
                              textEditingControllers[key]!,
                              "create",
                              dataManager);
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
                child: const Text('Edit'),
                onPressed: () async {
                  var row = TextEditingControllerToJson(
                      textEditingControllers, dataColumnType);
                  var primaryKey =
                      dataManager.data[index].data[setting["primaryKey"]];
                  print("------update------");
                  print(setting["API"]["updateAPI"] + primaryKey);
                  print(row);
                  var res = await Server()
                      .updateRow(row, setting["API"]["updateAPI"] + primaryKey);
                  var body = json.decode(res.body);
                  print("response:$body");
                  print("------update------");
                  if (body['status'] == "success") {
                    dataManager.editRow(row, index);
                    Navigator.pop(context, dataManager);
                  } else {
                    CostomAlterDiaglogState().showDialogBox(
                        context,
                        "Input:$row\nOutput:" + body.toString(),
                        "Error Message");
                  }
                })
          ],
        );
      },
    );
    return res;
  }

  showReservationAddDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showBranchDetailEditDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showclosingTimeCardEditDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showMapEditDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showMeauEditDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showCouponAddDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  showBranchAddDialogBox(
      BuildContext context, MyDataTableData dataManager, setting) async {
    // This list of controllers can be used to set and get the text from/to the TextFields
    Map<String, dynamic> textEditingControllers = {};
    final _formKey = GlobalKey<FormState>();
    FromTextFieldWidth = MediaQuery.of(context).size.width * 0.5;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: const EdgeInsets.all(defaultPadding),
          title: Text(setting["objectName"]),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Your Components
                    ],
                  ),
                )),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: addButtonTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Color((0xFFFFE34B)),
                        padding: EdgeInsets.all(defaultPadding)),
                    onPressed: () async {
                      //upload
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Map<String, dynamic> TextAddControllerCreate(
      keys, Map<String, dynamic> textEditingControllers, dataColumnType) {
    for (var key in keys) {
      if (!dataColumnType[key]["objectSetting"]["display"]["create"]) {
        continue;
      }
      var textEditingController;
      switch (dataColumnType[key]["objectSetting"]["type"]) {
        case "group":
          textEditingController = TextAddControllerCreate(
              dataColumnType[key]["objectSetting"]["item"].keys,
              <String, dynamic>{},
              dataColumnType[key]["objectSetting"]["item"]);
          break;
        case "file":
          textEditingController = <PlatformFile>[];
          break;
        case "mutiDownlist":
          textEditingController = <String>[];
          break;
        default:
          textEditingController = new TextEditingController();
      }
      textEditingControllers.putIfAbsent(key, () => textEditingController);
    }
    return textEditingControllers;
  }

  Map<dynamic, dynamic> TextEditingControllerToJson(
      textEditingControllers, dataColumnType) {
    var row = {};
    var keys = textEditingControllers.keys;
    keys.forEach((key) {
      switch (dataColumnType[key]["objectSetting"]["type"]) {
        case 'mutiData':
          row[key] = [];
          for (final rowData in textEditingControllers[key]) {
            row[key].add(TextEditingControllerToJson(
                rowData, dataColumnType[key]["item"]));
          }
          break;
        case 'file':
          if (textEditingControllers[key].length > 0) {
            this.fileFlag = true;
            textEditingControllers[key].forEach((element) {
              row[key] = element.name;
            });
          }
          break;
        case 'mutiDownlist':
          if (textEditingControllers[key].length > 0) {
            row[key] = [];
            textEditingControllers[key].forEach((element) {
              row[key].add(element);
            });
          }
          break;
        case 'group':
          row[key] = TextEditingControllerToJson(textEditingControllers[key],
              dataColumnType[key]["objectSetting"]["item"]);
          break;
        default:
          row[key] = textEditingControllers[key]!.text;
          //custom
          if (key == "deleted") {
            if (textEditingControllers[key]!.text == "enable") {
              row[key] = true;
            } else {
              row[key] = false;
            }
          }
        //custom
      }
    });
    return row;
  }

  Map<String, dynamic> TextEditingControllerCreate(
      Map<String, dynamic> textEditingControllers, dataColumnType, data) {
    var keys = dataColumnType.keys;

    for (var key in keys) {
      if (!dataColumnType[key]["objectSetting"]["display"]["edit"]) {
        continue;
      }
      var textEditingController;
      switch (dataColumnType[key]["objectSetting"]["type"]) {
        case "group":
          var tempData = {};
          try {
            tempData = Server().dataToJson(data[key].toString())[0];
          } catch (error) {
            try {
              tempData = Server().convertLanguageToJson(data[key].toString());
            } catch (error) {
              tempData =
                  Server().convertDescriptionsToJson(data[key].toString());
            }
          }
          textEditingController = TextEditingControllerCreate(
              <String, dynamic>{},
              dataColumnType[key]["objectSetting"]["item"],
              tempData);
          break;
        case "mutiData":
          var tempData = Server().dataToJson(data[key].toString());
          textEditingController = [];
          for (final rowData in tempData) {
            textEditingController.add(TextEditingControllerCreate(
                <String, dynamic>{}, dataColumnType[key]["item"], rowData));
          }
          break;
        case "mutiDownlist":
          textEditingController = <String>[];
          List<String> list = data[key]
              .toString()
              .replaceAll("[", "")
              .replaceAll("]", "")
              .replaceAll(" ", "")
              .split(",");
          List templete = dataColumnType[key]["objectSetting"]["statusItemList"]
              .keys
              .toList();
          for (var row in list) {
            if (templete.contains(row.toString())) {
              textEditingController.add(row.toString());
            }
          }
          break;
        case "file":
          textEditingController = <PlatformFile>[];
          break;
        default:
          textEditingController = new TextEditingController();
          textEditingController.text = data[key].toString();
      }
      textEditingControllers.putIfAbsent(key, () => textEditingController);
    }
    return textEditingControllers;
  }
}
