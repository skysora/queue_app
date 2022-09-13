import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class TextListView extends StatefulWidget {
  TextListView({
    Key? key,
    required this.data,
    required this.rowLimit,
  }) : super(key: key);
  final data;
  final int rowLimit;
  @override
  State<TextListView> createState() => TextListViewState(data, rowLimit);
}

class TextListViewState extends State<TextListView> {
  late var data;
  late int rowLimit;
  final Server server = Server();
  TextListViewState(data, rowLimit) {
    this.data = data;
    this.rowLimit = rowLimit;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var JsonDecode_timeList = this.data.split(",");
    JsonDecode_timeList.remove("{}");
    var tempTimeList = [];
    for (var i = 0; i < JsonDecode_timeList.length; i += this.rowLimit) {
      var temp = (JsonDecode_timeList.sublist(
          i,
          i + this.rowLimit > JsonDecode_timeList.length
              ? JsonDecode_timeList.length
              : i + this.rowLimit));
      tempTimeList.add(temp);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        for (int i = 0; i < tempTimeList.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < tempTimeList[i].length; j++)
                Builder(builder: (BuildContext context) {
                  return Container(
                      margin: EdgeInsets.only(right: defaultPadding / 4),
                      padding: const EdgeInsets.all(defaultPadding / 4),
                      child: Text(tempTimeList[i][j].toString(),
                          style: listViewLabelStyle));
                }),
            ],
          ),
      ],
    );
  }
}
