import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({
    Key? key,
    required this.required,
    required this.title,
    required this.type,
    required this.textController,
    required this.readOnly,
  }) : super(key: key);
  final bool required;
  final String title;
  final String type;
  final bool readOnly;
  final TextEditingController textController;
  @override
  _TimePickerState createState() =>
      _TimePickerState(required, title, type, textController, readOnly);
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  TextEditingController textController = new TextEditingController();
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  _TimePickerState(bool required, String title, String type,
      TextEditingController textController, bool readOnly) {
    this.required = required;
    this.title = title;
    this.type = type;
    this.textController = textController;
    this.readOnly = readOnly;
  }

  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title.toString())),
      SizedBox(
        width: 10,
      ),
      Builder(builder: (BuildContext context) {
        if (readOnly) {
          return SizedBox(
            width: FromTextFieldWidth,
            child: TextFormField(
              controller: textController,
              enabled: false,
              validator: (value) {
                var errorMessage = "";
                if ((value == null || value.isEmpty) && required) {
                  errorMessage = title + " is required";
                }
                if (errorMessage != "") {
                  return errorMessage;
                }
                return null;
              },
              decoration: InputDecoration(labelText: "Select time"),
            ),
          );
        } else {
          return SizedBox(
            width: FromTextFieldWidth,
            child: TextFormField(
              controller: textController,
              enabled: true,
              validator: (value) {
                var errorMessage = "";
                if ((value == null || value.isEmpty) && required) {
                  errorMessage = title + " is required";
                }
                if (errorMessage != "") {
                  return errorMessage;
                }
                return null;
              },
              onTap: () async {
                var newTime = await showTimePicker(
                  context: context,
                  initialTime: _time,
                );
                if (newTime != null) {
                  setState(() {
                    _time = newTime;
                    textController.text = '${_time.hour}:${_time.minute}';
                  });
                }
              },
              decoration: InputDecoration(labelText: "Select time"),
            ),
          );
        }
      })
    ]);
  }
}
