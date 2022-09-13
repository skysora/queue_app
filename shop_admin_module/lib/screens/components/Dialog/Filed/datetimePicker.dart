import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class DatetimePicker extends StatefulWidget {
  const DatetimePicker({
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
  _DatetimePickerState createState() =>
      _DatetimePickerState(required, title, type, textController, readOnly);
}

class _DatetimePickerState extends State<DatetimePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  TextEditingController textController = new TextEditingController();
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  _DatetimePickerState(bool required, String title, String type,
      TextEditingController textController, bool readOnly) {
    this.required = required;
    this.title = title;
    this.type = type;
    this.textController = textController;
    this.readOnly = readOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title.toString())),
        SizedBox(
          width: 10,
        ),
        Builder(builder: (BuildContext context) {
          if (readOnly) {
            return SizedBox(
                width: FromTextFieldWidth / 2 - 5,
                child: TextFormField(
                  controller:
                      textController, //editing controller of this TextField
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
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                      ),
                      labelText: "Select Datetime"),
                ));
          } else {
            return SizedBox(
                width: FromTextFieldWidth,
                child: TextFormField(
                    controller:
                        textController, //editing controller of this TextField
                    enabled:
                        true, //set it true, so that user will not able to edit text
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
                      var pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      var newTime = await showTimePicker(
                        context: context,
                        initialTime: _time,
                      );

                      if (pickedDate != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('y-mm-dd').format(pickedDate);
                        setState(() {
                          textController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                      if (newTime != null) {
                        setState(() {
                          _time = newTime;
                          DateTime _oldTime =
                              DateTime.parse(textController.text.toString());

                          String _newTime = DateFormat('yyyy-MM-dd kk:mm')
                              .format(DateTime(
                                  _oldTime.year,
                                  _oldTime.month,
                                  _oldTime.day,
                                  _oldTime.hour + _time.hour,
                                  _oldTime.minute + _time.minute));
                          this.textController.text = _newTime.toString();
                        });
                      }
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
                        ),
                        labelText: "Select Datetime")));
          }
        })
      ],
    );
  }
}
