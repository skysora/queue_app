import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/autoDownloadPackage/intl_phone_number_input/country_code.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class PhonePicker extends StatefulWidget {
  const PhonePicker({
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
  _PhonePickerState createState() =>
      new _PhonePickerState(required, title, type, textController, readOnly);
}

class _PhonePickerState extends State<PhonePicker> {
  TextEditingController textController = new TextEditingController();
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  _PhonePickerState(bool required, String title, String type,
      TextEditingController textController, bool readOnly) {
    this.required = required;
    this.title = title;
    this.type = type;
    this.textController = textController;
    this.readOnly = readOnly;
  }

  late CountryCode nowCode = new CountryCode();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(title)),
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
                  setState(() {
                    this.textController.text = "";
                    this.textController.text =
                        "${value!.replaceAll("${this.nowCode.dialCode}", "")}";
                    // this.textController.text = "${this.nowCode.dialCode} ${value!}";
                  });
                  return null;
                },
                decoration: InputDecoration(labelText: this.nowCode.dialCode),
              ),
            );
          } else {
            return SizedBox(
              width: FromTextFieldWidth,
              child: TextFormField(
                controller: textController,
                enabled: true,
                validator: (value) {
                  setState(() {
                    this.textController.text = "";
                    this.textController.text =
                        "${value!.replaceAll("${this.nowCode.dialCode}", "")}";
                    // this.textController.text = "${this.nowCode.dialCode} ${value!}";
                  });
                  return null;
                },
                decoration: InputDecoration(labelText: this.nowCode.dialCode),
              ),
            );
          }
        }),
      ],
    );
  }
}
