import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/customAlterDialog.dart';

class SwitchView extends StatefulWidget {
  SwitchView({
    Key? key,
    required this.status,
    required this.setting,
    required this.data,
    required this.dataManager,
    required this.keyword,
  }) : super(key: key);
  final String status;
  final setting;
  final data;
  final keyword;
  final MyDataTableData dataManager;
  @override
  State<SwitchView> createState() =>
      SwitchViewState(status, setting, data, dataManager, keyword);
}

class SwitchViewState extends State<SwitchView> {
  late String status;
  var setting;
  var data;
  String keyword = "";
  bool _value = true;
  Color myColor = Color(0xFF00D377);
  late MyDataTableData dataManager;
  SwitchViewState(String status, setting, data, dataManager, key) {
    this.status = status;
    this.setting = setting;
    this.data = data;
    this.dataManager = dataManager;
    this.keyword = key;
  }

  @override
  void initState() {
    super.initState();
    if (this.status == "enable" || this.status == "1") {
      this._value = true;
      status = "已啟動";
    } else {
      this._value = false;
      status = "未啟動";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return FlutterSwitch(
        value: this._value,
        borderRadius: 45.0,
        activeColor: const Color.fromRGBO(0, 211, 119, 1),
        onToggle: (val) async {
          if (setting != null) {
            setState(() {
              this._value = val;
            });
            var row =
                TextEditingControllerToJson(data, setting["dataColumnType"]);

            if (row[keyword] == "enable" || row[keyword] == "1") {
              row[keyword] = "disable";
            } else {
              row[keyword] = "enable";
            }

            var primaryKey = data[setting["primaryKey"]];
            var res = await Server()
                .updateRow(row, setting["API"]["updateAPI"] + primaryKey);
            var body = json.decode(res.body);
            if (body['status'] == "success") {
              print(body);
            } else {
              CostomAlterDiaglogState().showDialogBox(context,
                  "Input:$data\nOutput:" + body.toString(), "Error Message");
            }
          }
        },
      );
    });
  }
}

Map<dynamic, dynamic> TextEditingControllerToJson(
    textEditingControllers, dataColumnType) {
  var row = {};
  var keys = dataColumnType.keys;
  List templete = textEditingControllers.keys.toList();
  for (var key in keys) {
    if (!templete.contains(key)) {
      continue;
    }
    switch (dataColumnType[key]["objectSetting"]["type"]) {
      case 'mutiData':
        row[key] = [];
        for (final rowData in textEditingControllers[key]) {
          row[key].add(TextEditingControllerToJson(
              rowData, dataColumnType[key]["item"]));
        }
        break;
      case 'mutiDownlist':
        List<String> list = textEditingControllers[key]
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .replaceAll(" ", "")
            .split(",");
        if (textEditingControllers[key].length > 0) {
          row[key] = [];
          list.forEach((element) {
            row[key].add(element);
          });
        }
        break;
      case 'group':
        row[key] = TextEditingControllerToJson(
            textEditingControllers[key], dataColumnType[key]["item"]);
        break;
      default:
        row[key] = textEditingControllers[key];
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
  }
  ;
  return row;
}
