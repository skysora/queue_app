import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:email_validator/email_validator.dart';

class EmailPicker extends StatefulWidget {
  const EmailPicker({
    Key? key,
    required this.setting,
    required this.textController,
    required this.type,
  }) : super(key: key);
  final setting;
  final TextEditingController textController;
  final type;
  @override
  _EmailPickerState createState() =>
      _EmailPickerState(setting, textController, type);
}

class _EmailPickerState extends State<EmailPicker> {
  TextEditingController textController = new TextEditingController();
  var setting;
  late String type;
  _EmailPickerState(setting, TextEditingController textController, type) {
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
      controller: textController,
      enabled: (this.setting["read-only"] && type == "edit") ? false : true,
      validator: (value) {
        return customValidator(value, required, title);
      },
      decoration: InputDecoration(
          icon: Icon(Icons.email),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
          ),
          labelText: title,
          helperText: helperText),
    ));
  }

  customValidator(value, required, title) {
    var errorMessage = "";
    if ((value == null || value.isEmpty) && required) {
      errorMessage = title + " is required";
    } else if (!EmailValidator.validate(value)) {
      errorMessage = title + " type error";
    }
    if (errorMessage != "") {
      return errorMessage;
    } else {
      return null;
    }
  }
}
