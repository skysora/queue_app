import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
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
  _DatePickerState createState() =>
      _DatePickerState(required, title, type, textController, readOnly);
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  TextEditingController textController = new TextEditingController();
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  _DatePickerState(bool required, String title, String type,
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
                width: FromTextFieldWidth,
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
                      labelText: "Select Date" //label text of field
                      ),
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

                    if (pickedDate != null) {
                      //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        textController.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {
                    }
                  },
                  decoration: InputDecoration(
                      labelText: "Select Date" //label text of field
                      ),
                ));
          }
        }),
      ],
    );
  }
}
