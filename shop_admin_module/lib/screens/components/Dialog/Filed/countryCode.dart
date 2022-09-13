import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/autoDownloadPackage/intl_phone_number_input/country_code.dart';
import 'package:shop_admin_module/screens/autoDownloadPackage/intl_phone_number_input/country_code_picker.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class CountryCodeFiled extends StatefulWidget {
  const CountryCodeFiled({
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
  _CountryCodeFiledState createState() => new _CountryCodeFiledState(
      required, title, type, textController, readOnly);
}

class _CountryCodeFiledState extends State<CountryCodeFiled> {
  TextEditingController textController = new TextEditingController();
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  _CountryCodeFiledState(bool required, String title, String type,
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
    String initCountryCode = "+852";
    if (this.textController.text != "") {
      initCountryCode = "+" + this.textController.text;
    }
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        SizedBox(
          width: 10,
        ),
        Builder(builder: (BuildContext context) {
          if (readOnly) {
            return SizedBox(
              width: FromTextFieldWidth,
              child: CountryCodePicker(
                  onChanged: (code) {
                    this.nowCode = code;
                    this.textController.text = "";
                    this.textController.text = "${this.nowCode.dialCode}";
                  },
                  enabled: false,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'IT',
                  // countryFilter: ['IT', 'FR'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                  comparator: (a, b) => b.name!.compareTo(a.name!),
                  onInit: (code) {
                    this.nowCode = code!;
                    this.textController.text = "";
                    this.textController.text = "${this.nowCode.dialCode}";
                    // print("on init ${code!.name} ${code.dialCode} ${code.name}");
                  }),
            );
          } else {
            return SizedBox(
              width: FromTextFieldWidth,
              child: CountryCodePicker(
                onChanged: (code) {
                  this.nowCode = code;
                  this.textController.text = "";
                  this.textController.text =
                      "${this.nowCode.dialCode}".replaceAll("+", "");
                  print(this.textController.text);
                },
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: initCountryCode,
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
                comparator: (a, b) => b.name!.compareTo(a.name!),
              ),
            );
          }
        }),
      ],
    );
  }
}
