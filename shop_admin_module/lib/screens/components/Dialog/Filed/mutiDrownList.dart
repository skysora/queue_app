import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:multiselect/multiselect.dart';

import '../CustomDialog.dart';

class MutiDrownList extends StatefulWidget {
  const MutiDrownList({
    Key? key,
    required this.setting,
    required this.dataTableManage,
    required this.textController,
    required this.type,
    required this.dropdownMenuItemList,
  }) : super(key: key);
  final setting;
  final textController;
  final type;
  final MyDataTableData dataTableManage;
  final Map<String, String> dropdownMenuItemList;
  @override
  _MutiDrownListState createState() => _MutiDrownListState(
      setting, textController, type, dropdownMenuItemList, dataTableManage);
}

class _MutiDrownListState extends State<MutiDrownList> {
  List<String> textController = [];
  var setting;
  late String type;
  String _pickingType = "";
  Map<String, String> dropdownMenuItemListDict = {};
  Map<String, String> dropdownMenuItemValueToKeyDict = {};
  List<String> dropdownMenuItemList = [];
  List<String> selectList = [];
  late MyDataTableData dataTableManage;
  _MutiDrownListState(setting, textController, type,
      Map<String, String> dropdownMenuItemListDict, dataTableManage) {
    this.setting = setting;
    this.type = type;
    this.textController = textController;
    this.dropdownMenuItemValueToKeyDict = dropdownMenuItemListDict;
    dropdownMenuItemListDict
        .forEach((key, value) => {this.dropdownMenuItemListDict[value] = key});
    this.dropdownMenuItemList =
        List<String>.from(this.dropdownMenuItemListDict.keys);
    this.dataTableManage = dataTableManage;
  }

  @override
  void initState() {
    super.initState();
    print(this.textController);
    if (this.textController.isEmpty) {
      this.selectList = [];
    } else {
      for (var key in this.textController) {
        this
            .selectList
            .add(this.dropdownMenuItemValueToKeyDict[key].toString());
      }
    }
    print(this.selectList);
  }

  @override
  Widget build(BuildContext context) {
    String title = setting["objectName"].toString();
    String helperText = setting["helperText"];
    return (!this.setting["read-only"])
        ? SizedBox(
            child: DropDownMultiSelect(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(defaultPadding / 2),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    width: 2,
                  ))),
              onChanged: (List<String> x) {},
              options: this.dropdownMenuItemList,
              selectedValues: this.selectList,
              whenEmpty: this._pickingType,
            ),
          )
        : SizedBox(
            child: DropDownMultiSelect(
            decoration: InputDecoration(
                icon: Icon(Icons.arrow_drop_down_outlined),
                contentPadding: const EdgeInsets.all(defaultPadding),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                ),
                labelText: title,
                helperText: helperText,
                suffixIcon: (setting["addButton"] != null)
                    ? IconButton(
                        onPressed: () async {
                          var res = await CustomDialogState().showAddDialogBox(
                            context,
                            dataTableManage,
                            setting,
                          );
                          if (res.toString() != "cancel") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ObjectFactory()
                                      .generateClass(setting["page"])),
                            );
                          }
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                      )
                    : null),
            onChanged: (List<String> x) {
              setState(() {
                this.textController.removeRange(0, this.textController.length);
                x.forEach((element) {
                  this
                      .textController
                      .add(dropdownMenuItemListDict[element].toString());
                });
                this.selectList = x;
              });
            },
            options: this.dropdownMenuItemList,
            selectedValues: this.selectList,
            whenEmpty: this._pickingType,
          ));
  }
}
