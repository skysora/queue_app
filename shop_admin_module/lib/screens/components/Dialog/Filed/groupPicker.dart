import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class GroupFiled extends StatefulWidget {
  const GroupFiled({
    Key? key,
    required this.setting,
    required this.textController,
    required this.type,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final Map<String, dynamic> textController;
  final type;
  final DataTableSource dataTableManage;
  @override
  _GroupFiledState createState() =>
      _GroupFiledState(setting, type, textController, dataTableManage);
}

class _GroupFiledState extends State<GroupFiled> {
  late var textController;
  var setting;
  late String type;

  late Map<String, dynamic> dataColumnType;
  late MyDataTableData dataTableManage;
  _GroupFiledState(setting, String type, Map<String, dynamic> textController,
      dataTableManage) {
    this.setting = setting;
    this.type = type;
    this.dataColumnType = json.decode(jsonEncode(this.setting["item"]));
    this.textController = textController;
    this.dataTableManage = dataTableManage;
  }
  @override
  Widget build(BuildContext context) {
    var keys = this.dataColumnType.keys;
    String title = setting["objectName"].toString();
    bool required = setting["required"];
    String helperText = setting["helperText"];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final key in keys)
                  Builder(builder: (context) {
                    return ObjectFactory().generateDialogFiled(
                        this.dataColumnType[key],
                        key,
                        this.textController[key]!,
                        "create",
                        this.dataTableManage);
                  })
              ],
            )),
      ],
    );
  }
}
