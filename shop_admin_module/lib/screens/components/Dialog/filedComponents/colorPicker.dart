import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ColorPickerDemo extends StatefulWidget {
  const ColorPickerDemo({
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
  _ColorPickerDemoState createState() =>
      _ColorPickerDemoState(required, title, type, textController, readOnly);
}

class _ColorPickerDemoState extends State<ColorPickerDemo> {
  late Color dialogPickerColor; // Color for picker in dialog using onChanged
  late Color dialogSelectColor; // Color for picker using color select dialog.

  // Define some custom colors for the custom picker segment.
  // The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };

  TextEditingController textController = new TextEditingController();
  bool required = false;
  String title = "";
  String type = "";
  bool readOnly = false;
  _ColorPickerDemoState(bool required, String title, String type,
      TextEditingController textController, bool readOnly) {
    this.required = required;
    this.title = title;
    this.type = type;
    this.textController = textController;
    this.readOnly = readOnly;
  }

  @override
  void initState() {
    dialogPickerColor = Colors.red;
    dialogSelectColor = const Color(0xFFA239CA);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        SizedBox(
          width: 10,
        ),
        Builder(builder: (BuildContext context) {
          if (readOnly) {
            return SizedBox(
                width: FromTextFieldWidth - 54,
                child: TextFormField(
                  enabled: false,
                  controller: textController,
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
                      hintText: "Click this color to modify it in a dialog"),
                ));
          } else {
            return SizedBox(
                width: FromTextFieldWidth - 54,
                child: TextFormField(
                  enabled: true,
                  controller: textController,
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
                      hintText: "Click this color to modify it in a dialog"),
                ));
          }
        }),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          child: ColorIndicator(
            width: 44,
            height: 44,
            borderRadius: 4,
            color: dialogPickerColor,
            onSelectFocus: false,
            onSelect: () async {
              // Store current color before we open the dialog.
              final Color colorBeforeDialog = dialogPickerColor;
              // Wait for the picker to close, if dialog was dismissed,
              // then restore the color we had before it was opened.
              if (!(await colorPickerDialog())) {
                setState(() {
                  dialogPickerColor = colorBeforeDialog;
                  this.textController.text =
                      '${ColorTools.materialNameAndCode(dialogSelectColor)} ';
                });
              }
            },
          ),
        )
      ],
    );
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: dialogPickerColor,
      onColorChanged: (Color color) {
        // Color(0xffaabbcc).toHex()
        setState(() => dialogPickerColor = color);
        this.textController.text = dialogSelectColor.hex.toString();
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyText2,
      colorCodePrefixStyle: Theme.of(context).textTheme.caption,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: true,
        ColorPickerType.wheel: true,
      },
      customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }
}
