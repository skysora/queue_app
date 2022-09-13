import 'package:flutter/material.dart';

class PasswordFiled extends StatefulWidget {
  const PasswordFiled({
    Key? key,
    required this.setting,
    required this.textController,
    required this.type,
  }) : super(key: key);
  final setting;
  final TextEditingController textController;
  final type;
  @override
  _PasswordFiledState createState() =>
      _PasswordFiledState(setting, textController, type);
}

class _PasswordFiledState extends State<PasswordFiled> {
  TextEditingController textController = new TextEditingController();
  var setting;
  late String type;
  bool _passwordVisible = false;
  _PasswordFiledState(setting, TextEditingController textController, type) {
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
      enabled: (this.setting["read-only"] && type == "edit") ? false : true,
      keyboardType: TextInputType.text,
      controller: textController,
      validator: (value) {
        return customValidator(value, required, title);
      },
      obscureText: !_passwordVisible, //This will obscure text dynamically
      decoration: InputDecoration(
          icon: Icon(Icons.lock_open),
          hintText: '請輸入密碼',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
          ),
          // Here is key idea
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).primaryColorDark,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
          labelText: title.toString(),
          helperText: helperText),
    ));
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
          errorMessage += " " + title + " 類型錯誤";
        }
      }
    }
    if (errorMessage != "") {
      return errorMessage;
    }
    return null;
  }
}
