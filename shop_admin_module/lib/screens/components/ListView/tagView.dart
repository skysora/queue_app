import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class TagView extends StatefulWidget {
  TagView({
    Key? key,
    required this.data,
    required this.rowLimit,
  }) : super(key: key);
  final data;
  final int rowLimit;
  @override
  State<TagView> createState() => TagViewState(data, rowLimit);
}

class TagViewState extends State<TagView> {
  late var data;
  late int rowLimit;
  final Server server = Server();
  TagViewState(data, int rowLimit) {
    this.data = data;
    this.rowLimit = rowLimit;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var tempTimeList = server.convertTagToJson(this.data, this.rowLimit);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (int i = 0; i < tempTimeList.length; i++)
          Row(
            children: [
              SizedBox(
                width: defaultPadding / 4,
              ),
              for (int j = 0; j < tempTimeList[i].length; j++)
                Builder(builder: (BuildContext context) {
                  return Container(
                      margin: EdgeInsets.only(left: defaultPadding / 4),
                      padding: const EdgeInsets.all(defaultPadding / 4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE0E0E0))),
                      child: Text(tempTimeList[i][j]["word"].toString(),
                          style: listViewLabelStyle));
                }),
            ],
          ),
      ],
    );
  }
}
