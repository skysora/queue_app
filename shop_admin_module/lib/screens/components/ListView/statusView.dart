import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class StatusView extends StatefulWidget {
  StatusView({
    Key? key,
    required this.status,
  }) : super(key: key);
  final String status;
  @override
  State<StatusView> createState() => StatusViewViewState(status);
}

class StatusViewViewState extends State<StatusView> {
  late String status;

  String text = "啟用";
  Color myColor = Color(0xFF00D377);
  StatusViewViewState(String status) {
    this.status = status;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (this.status != "enable") {
        this.text = "關閉";
        this.myColor = Color(0xFFCCCCCC);
      }
      return Container(
        margin:
            const EdgeInsets.only(left: defaultPadding, bottom: defaultPadding),
        // margin: const EdgeInsets.all(defaultPadding),
        child: Container(
          width: 50,
          height: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: this.myColor,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Align(
                alignment: AlignmentDirectional.center,
                child: Text(text,
                    style: TextStyle(fontSize: 12, color: Color(0xFFFFFFFF)))),
          ),
        ),
      );
    });
  }
}
