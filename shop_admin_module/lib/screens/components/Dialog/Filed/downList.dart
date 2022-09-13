import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class DownListPicker extends StatefulWidget {
  const DownListPicker({
    Key? key,
    required this.setting,
    required this.textController,
    required this.type,
    required this.dropdownMenuItemList,
  }) : super(key: key);
  final setting;
  final TextEditingController textController;
  final type;
  final Map<String, String> dropdownMenuItemList;
  @override
  _DownListPickerState createState() =>
      _DownListPickerState(setting, textController, type, dropdownMenuItemList);
}

class _DownListPickerState extends State<DownListPicker> {
  TextEditingController textController = new TextEditingController();
  var setting;
  late String type;
  String _pickingType = "";
  Map<String, String> dropdownMenuItemListDict = {};
  List<String> dropdownMenuItemList = [];
  _DownListPickerState(
    setting,
    TextEditingController textController,
    type,
    Map<String, String> dropdownMenuItemListDict,
  ) {
    this.setting = setting;
    this.textController = textController;
    dropdownMenuItemListDict
        .forEach((key, value) => {this.dropdownMenuItemListDict[value] = key});
    this.dropdownMenuItemList =
        List<String>.from(this.dropdownMenuItemListDict.keys);
  }

  @override
  void initState() {
    super.initState();
    this._pickingType = dropdownMenuItemList[0];
    this.textController.text =
        dropdownMenuItemListDict[dropdownMenuItemList[0]].toString();
  }

  @override
  Widget build(BuildContext context) {
    String title = setting["objectName"].toString();
    bool required = setting["required"];
    String helperText = setting["helperText"];
    return SizedBox(
        child: InputDecorator(
      decoration: InputDecoration(
          icon: Icon(Icons.arrow_drop_down_outlined),
          contentPadding: EdgeInsets.all(defaultPadding / 2),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
          ),
          labelText: title,
          helperText: helperText),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: (this.setting["read-only"]) ? false : true,
          hint: const Text('LOAD PATH FROM'),
          value: _pickingType,
          items: dropdownMenuItemList.map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _pickingType = value.toString();
            this.textController.text =
                this.dropdownMenuItemListDict[value].toString();
          }),
        ),
      ),
    ));
  }
}
