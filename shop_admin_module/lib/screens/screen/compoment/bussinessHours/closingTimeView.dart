import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'closingTimeCard.dart';

class ClosingTimeView extends StatefulWidget {
  const ClosingTimeView({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final dynamic setting;
  final MyDataTableData dataTableManage;
  @override
  _ClosingTimeViewState createState() =>
      _ClosingTimeViewState(setting, dataTableManage);
}

class _ClosingTimeViewState extends State<ClosingTimeView> {
  var setting;
  late Widget? header;
  late List<Widget>? actions;
  late MyDataTableData dataTableManage;
  List<TableInformation> dataList = [];
  _ClosingTimeViewState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }
  var data = {};
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    // top block
    var tagLineCount = 5;
    var JsonDecode_timeList = Server().dataToJson(
        this.dataTableManage.data[0].data["working_hour"].toString());
    var tempTimeList = [];
    for (var i = 0; i < JsonDecode_timeList.length; i += tagLineCount) {
      var temp = (JsonDecode_timeList.sublist(
          i,
          i + tagLineCount > JsonDecode_timeList.length
              ? JsonDecode_timeList.length
              : i + tagLineCount));
      tempTimeList.add(temp);
    }
    data["working_hour"] = tempTimeList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: MediaQuery.of(context).size.height * setting["height"] -
          myAppBarHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // CardHeader(
                    //     setting: this.setting,
                    //     dataTableManage: this.dataTableManage),
                    Semantics(
                      container: true,
                      child: DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.w400),
                        child: IconTheme.merge(
                          data: const IconThemeData(
                            opacity: 0.54,
                          ),
                          child: Ink(
                            height: DataTableHeaderHeight,
                            // color: themeData.secondaryHeaderColor,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 24, end: 14.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Text("商戶資訊",
                                          style: dataTableTitleStyle)),
                                  ElevatedButton(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/add_role.png',
                                          width: addButtonIconSize,
                                          height: addButtonIconSize,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("編輯",
                                            style: TextStyle(
                                                color: Color(0xFF6C5231),
                                                fontSize: addButtonTextSize,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Color((0xFFFFE34B)),
                                      padding: EdgeInsets.all(defaultPadding),
                                    ),
                                    onPressed: () async {
                                      var res = await CustomDialogState()
                                          .showclosingTimeCardEditDialogBox(
                                        context,
                                        dataTableManage,
                                        this.setting["editButton"]
                                            ["objectSetting"],
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // header分隔線
                    Divider(color: Color(0xFFF0F0F0)),
                    Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      width: MediaQuery.of(context).size.width *
                          this.setting['width'],
                      child: timeBlock(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column timeBlock() {
    const cardWidth = 0.15;
    const cardHeight = 0.40;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int i = 0; i < data["working_hour"]!.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                for (int j = 0; j < data["working_hour"]![i].length; j++)
                  ClosingTimeCard(
                    cardHeight: cardHeight,
                    cardWidth: cardWidth,
                    data: data["working_hour"]![i][j],
                    setting: setting,
                    dataManager: this.dataTableManage,
                    keyword: "status",
                  )
              ],
            )
        ]);
  }
}
