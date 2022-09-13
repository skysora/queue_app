import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class NormalFiled extends StatefulWidget {
  const NormalFiled({
    Key? key,
    required this.setting,
    required this.textController,
    required this.type,
  }) : super(key: key);
  final setting;
  final TextEditingController textController;
  final type;
  @override
  _NormalFiledState createState() =>
      _NormalFiledState(setting, textController, type);
}

class _NormalFiledState extends State<NormalFiled> {
  TextEditingController textController = new TextEditingController();
  var setting;
  late String type;
  _NormalFiledState(setting, TextEditingController textController, type) {
    this.setting = setting;
    this.textController = textController;
    this.type = type;
  }
  @override
  Widget build(BuildContext context) {
    String title = setting["objectName"].toString();
    bool required = setting["required"];
    String helperText = setting["helperText"];
    return SizedBox(
      child: TextFormField(
        controller: this.textController,
        enabled: (this.setting["read-only"] && type == "edit") ? false : true,
        validator: (value) {
          return customValidator(value, required, title);
        },
        decoration: InputDecoration(
            icon: Icon(Icons.send),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
            ),
            labelText: title,
            helperText: helperText),
      ),
    );
  }

  customValidator(value, required, title) {
    var errorMessage = "";
    if ((value == null || value.isEmpty) && required) {
      errorMessage = title + " 是需要的";
    }
    if (value!.isNotEmpty && type != "") {
      if (type == "int") {
        try {
          //Function which may throw an exception
          int.parse(value);
        } catch (error) {
          //Error handle
          errorMessage += " " + title + "類型錯誤";
        }
      }
    }
    if (errorMessage != "") {
      return errorMessage;
    }
    return null;
  }
}
