import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/ListView/switchView.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ClosingTimeCard extends StatefulWidget {
  ClosingTimeCard({
    Key? key,
    required this.data,
    required this.cardWidth,
    required this.cardHeight,
    required this.setting,
    required this.keyword,
    required this.dataManager,
  }) : super(key: key);
  final data;
  final setting;
  final double cardWidth;
  final double cardHeight;
  final String keyword;
  final dataManager;
  @override
  State<ClosingTimeCard> createState() => ClosingTimeCardState(
      data, cardWidth, cardHeight, setting, keyword, dataManager);
}

class ClosingTimeCardState extends State<ClosingTimeCard> {
  late var data;
  late double cardWidth;
  late double cardHeight;
  late String keyword;
  late MyDataTableData dataManager = MyDataTableData();
  var setting;
  ClosingTimeCardState(
      data, cardWidth, cardHeight, setting, keyword, dataManager) {
    this.data = data;
    this.cardWidth = cardWidth;
    this.cardHeight = cardHeight;
    this.setting = setting;
    this.dataManager = dataManager;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      width: MediaQuery.of(context).size.width * cardWidth,
      height: MediaQuery.of(context).size.height * cardHeight,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "AM",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF999999)),
                  ),
                  Text(data["open_time"].toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            // 分隔線
            Divider(color: Color(0xFFF0F0F0)),
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "PM",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF999999)),
                  ),
                  Text(data["close_time"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Builder(builder: (context) {
                switch (data["weekday"].toString()) {
                  case "0":
                    return Text("星期一");
                  case "1":
                    return Text("星期二");
                  case "2":
                    return Text("星期三");
                  case "3":
                    return Text("星期四");
                  case "4":
                    return Text("星期五");
                  case "5":
                    return Text("星期六");
                  case "6":
                    return Text("星期七");
                  default:
                    return Text("無");
                }
              }),
            ),
            SwitchView(
              status: data["status"].toString(),
              setting: setting,
              data: this.dataManager.data[0].data,
              dataManager: this.dataManager,
              keyword: "status",
            )
          ],
        ),
      ),
    );
  }
}
