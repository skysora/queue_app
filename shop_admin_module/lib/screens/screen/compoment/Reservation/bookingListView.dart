import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:intl/intl.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class BookingListView extends StatefulWidget {
  BookingListView({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  State<BookingListView> createState() =>
      _BookingListViewState(setting, dataTableManage);
}

class _BookingListViewState extends State<BookingListView> {
  late var setting;
  late MyDataTableData dataTableManage;
  late Map<int, Color> color = color = {
    50: Color.fromRGBO(255, 227, 75, .1),
    100: Color.fromRGBO(255, 227, 75, .2),
    200: Color.fromRGBO(255, 227, 75, .3),
    300: Color.fromRGBO(255, 227, 75, .4),
    400: Color.fromRGBO(255, 227, 75, .5),
    500: Color.fromRGBO(255, 227, 75, .6),
    600: Color.fromRGBO(255, 227, 75, .7),
    700: Color.fromRGBO(255, 227, 75, .8),
    800: Color.fromRGBO(255, 227, 75, .9),
    900: Color.fromRGBO(255, 227, 75, 1),
  };
  late MaterialColor colorCustom;
  late double height =
      (MediaQuery.of(context).size.height - myAppBarHeight) * setting["height"];
  late double width = MediaQuery.of(context).size.width * this.setting['width'];
  var dayList = {};
  late List columnKeys;
  _BookingListViewState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }

  @override
  void initState() {
    super.initState();
    getData();
    print(setting);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getData() {
    if (this.dataTableManage.columns.isEmpty) {
      columnKeys = this.dataTableManage.data[0].data.keys.toList();
    } else {
      columnKeys = this.dataTableManage.columns.keys.toList();
    }
    for (int index = 0; index < this.dataTableManage.data.length; index++) {
      var tempDict = {};
      DateTime date;
      String day = "";
      if (this.dataTableManage.data[index].data['start_datetime'].toString() !=
          "null") {
        date = DateFormat("yyyy-MM-dd hh:mm:ss")
            .parse(this.dataTableManage.data[index].data['start_datetime']!);
        day = DateFormat('MM月dd日').format(date);
      }
      tempDict[index] = this.dataTableManage.data[index].data;
      if (this.dayList.containsKey(day)) {
        this.dayList[day]!.add(tempDict);
      } else {
        this.dayList[day] = [];
        this.dayList[day]!.add(tempDict);
      }
    }
    // top block
  }

  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: (MediaQuery.of(context).size.height - myAppBarHeight) *
          setting["height"],
      child: Stack(
        children: <Widget>[
          bookingWidget(),
        ],
      ),
    );
  }

  Widget bookingWidget() {
    double widgetWidth = this.width;
    double widgetHeight = this.height;
    var columnwidth = widgetWidth * ((1.0 - 0.3) / this.columnKeys.length);
    return Container(
      height: widgetHeight,
      width: widgetWidth,
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: Column(
        children: [
          // header
          // CardHeader(setting: setting, dataTableManage: dataTableManage),
          Semantics(
            container: true,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.headline6!
                  .copyWith(fontWeight: FontWeight.w400),
              child: IconTheme.merge(
                data: const IconThemeData(
                  opacity: 0.54,
                ),
                child: Ink(
                  height: DataTableHeaderHeight,
                  // color: themeData.secondaryHeaderColor,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 24, end: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Text("預約訂單", style: dataTableTitleStyle)),
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
                              Text("預約訂單",
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
                                .showReservationAddDialogBox(
                              context,
                              dataTableManage,
                              this.setting["addButton"]["objectSetting"],
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

          Container(
            height: DataTableHeadingRowHeight,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(240, 240, 240, 1),
              ),
              color: const Color.fromRGBO(255, 255, 255, 1),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (final name in columnKeys)
                    Builder(builder: (context) {
                      String columnName =
                          this.dataTableManage.columns[name].toString();
                      return SizedBox(
                        width: columnwidth,
                        child: Text(
                          columnName,
                          style: defaultStyle,
                        ),
                      );
                    }),
                  SizedBox(
                    width: widgetWidth * 0.10,
                    child: Text(
                      "操作",
                      style: defaultStyle,
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: widgetHeight -
                DataTableHeadingRowHeight -
                DataTableHeaderHeight,
            child: ListView.builder(
                itemCount: this.dayList.length,
                itemBuilder: (BuildContext context, int index) {
                  return dayWidget(this.dayList.keys.toList()[index]);
                }),
          )
        ],
      ),
    );
  }

  Widget dayWidget(day) {
    double widgetWidth = this.width;
    var columnwidth = widgetWidth * ((1.0 - 0.3) / this.columnKeys.length);
    var dayRecord = this.dayList[day]!;
    if (dayRecord.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        // 日期分隔
        Container(
          height: DataTableHeadingRowHeight,
          padding: const EdgeInsets.all(defaultPadding),
          color: const Color.fromRGBO(245, 245, 245, 1),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              day,
              style: columnTitleStyle,
            ),
            DateFormat('MM月dd日').format(DateTime.now()) == day
                ? const Text(
                    "今日",
                    style: columnTitleStyle,
                  )
                : Container(),
          ]),
        ),
        // 資料
        Container(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            height: (dayRecord.length * DataTableHeadingRowHeight) +
                DataTableHeaderHeight,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayRecord.length,
              itemBuilder: (BuildContext context, int index) {
                final Map record = dayRecord[index];
                int key = record.keys.first as int;
                return Container(
                  // height: DataTableHeadingRowHeight,
                  padding: const EdgeInsets.all(defaultPadding),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        for (final name in columnKeys)
                          SizedBox(
                            width: columnwidth,
                            child: ObjectFactory().generateDataColumn(
                                this.dataTableManage.dataColumnType,
                                this.dataTableManage,
                                index,
                                name,
                                setting),
                          ),
                        SizedBox(
                          width: widgetWidth * 0.10,
                          child: Row(
                            children: [
                              //Detail
                              IconButton(
                                icon: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: addButtonTextSize,
                                    color: Color.fromRGBO(153, 153, 153, 1)),
                                onPressed: () {
                                  _showAlertDialog(context,
                                      this.dataTableManage.data[key].data);
                                },
                              ),
                              SizedBox(
                                width: defaultPadding / 4,
                              ),
                              //delete
                              IconButton(
                                onPressed: () async {
                                  var res = await CustomDialogState()
                                      .showDeleteDialogBox(context, setting,
                                          index, this.dataTableManage, false);
                                  if (res.toString() != "cancel") {
                                    this.dataTableManage = res;
                                    Route route = MaterialPageRoute(
                                        builder: (context) => ObjectFactory()
                                            .generateClass(setting["page"]));

                                    if (!setting["replacePage"]) {
                                      Navigator.push(context, route);
                                    } else {
                                      Navigator.pushReplacement(context, route);
                                    }
                                  }
                                },
                                icon:
                                    Image.asset("assets/icons/delete_role.png"),
                              ),
                            ],
                          ),
                        ),
                      ]),
                );
              },
            ))
      ],
    );
  }

  Widget statusWidget(status) {
    Map statusList = {
      "pending": {"text": "準時", "color": const Color.fromRGBO(56, 178, 255, 1)},
      "accepted": {
        "text": "準時",
        "color": const Color.fromRGBO(56, 178, 255, 1)
      },
      "rejected": {
        "text": "已取消",
        "color": const Color.fromRGBO(56, 178, 255, 1)
      },
      "absent": {"text": "已放棄", "color": const Color.fromRGBO(56, 178, 255, 1)},
      "queueing": {"text": "", "color": const Color.fromRGBO(56, 178, 255, 1)},
      "checked-in": {
        "text": "已入座",
        "color": const Color.fromRGBO(56, 178, 255, 1)
      },
      "completed": {
        "text": "準時",
        "color": const Color.fromRGBO(56, 178, 255, 1)
      }
    };
    var color;
    var text;
    try {
      color = statusList[status]['color'];
      text = statusList[status]['text'];
    } catch (error) {
      color = Colors.black;
      text = "資料有誤";
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultPadding / 4),
        color: color,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: addButtonTextSize,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String showWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return "星期一";
      case 2:
        return "星期二";
      case 3:
        return "星期三";
      case 4:
        return "星期四";
      case 5:
        return "星期五";
      case 6:
        return "星期六";
      case 7:
        return "星期日";
    }
    return "N/A";
  }

  Widget getRatingIcon(int rating) {
    final children = <Widget>[];
    for (var i = 0; i < rating; i++) {
      children.add(Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color.fromRGBO(255, 137, 47, 1),
          ),
          child: const Icon(
            Icons.star_rate_rounded,
            size: 28,
            color: Color.fromRGBO(255, 255, 255, 1),
          )));
    }
    for (var i = 0; i < (5 - rating); i++) {
      children.add(Container(
          height: 30,
          width: 30,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: const Color.fromRGBO(224, 224, 224, 1),
          ),
          child: const Icon(
            Icons.star_rate_rounded,
            size: 28,
            color: Color.fromRGBO(255, 255, 255, 1),
          )));
    }
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: children,
    );
  }

  Future<void> _showAlertDialog(BuildContext context, record) {
    double widgetWidth = this.width * 0.4;
    double widgetHeight = MediaQuery.of(context).size.height;

    Offset fromRight(Animation animation) {
      return Offset((1 - animation.value).toDouble(), 0);
    }

    DateTime date =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(record['start_datetime']);
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (ctx, animation, _, child) {
          return FractionalTranslation(
            translation: fromRight(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Material(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: widgetWidth,
                height: widgetHeight,
                color: const Color.fromRGBO(240, 240, 240, 1),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            width: 1.0,
                          ),
                          top: BorderSide(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            width: 1.0,
                          ),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: widgetWidth * 0.3,
                              child: const Text(
                                "訂單詳情",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ),
                            SizedBox(
                              width: widgetWidth * 0.15,
                              child: InkWell(
                                child: const Icon(Icons.clear_rounded,
                                    size: 36,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ]),
                    ),
                    Container(
                        height: widgetHeight * 0.25,
                        width: widgetWidth,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              width: 1.0,
                            ),
                            top: BorderSide(
                              color: Color.fromRGBO(240, 240, 240, 1),
                              width: 1.0,
                            ),
                          ),
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Row(children: [
                          Container(
                            height: widgetHeight * 0.3,
                            width: widgetWidth / 2,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: const Text(
                                      "預約時間",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(153, 153, 153, 1)),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('hh:mm').format(date),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        DateFormat('a').format(date),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Text(
                                      DateFormat('yyyy年MM月dd日').format(date),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    showWeekday(date),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(0, 0, 0, 1)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: widgetHeight * 0.3,
                            width: widgetWidth / 2,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Color.fromRGBO(240, 240, 240, 1),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: const Text(
                                      "當前時間",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(153, 153, 153, 1)),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('hh:mm')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color:
                                              Color.fromRGBO(255, 137, 47, 1)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        DateFormat('a').format(DateTime.now()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Color.fromRGBO(
                                                255, 137, 47, 1)),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Text(
                                      DateFormat('yyyy年MM月dd日')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color:
                                              Color.fromRGBO(255, 137, 47, 1)),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    showWeekday(DateTime.now()),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(255, 137, 47, 1)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ])),
                    Container(
                      height: widgetHeight * 0.25,
                      width: widgetWidth,
                      margin: const EdgeInsets.only(top: 10),
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                              "預訂信息",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "人數",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                const Text(
                                  "無",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "姓名",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                Text(
                                  record["last_name"].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "電話",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                Text(
                                  record["country_code"].toString() +
                                      " " +
                                      record["phone"].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "備註",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                Text(
                                  record["remark"].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: widgetHeight * 0.30,
                      width: widgetWidth,
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(defaultPadding),
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                              "更多信息",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "出席率",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                const Text(
                                  "無",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "準時率",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                const Text(
                                  "無",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: const Text(
                                    "評分",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                ),
                                getRatingIcon(4)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: widgetHeight * 0.20 - 20 - 80,
                      width: widgetWidth,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            width: 1.0,
                          ),
                        ),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: widgetWidth / 4,
                              color: const Color.fromRGBO(56, 178, 255, 1),
                              child: const Center(
                                child: Text(
                                  "準時",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: widgetWidth / 4,
                              color: const Color.fromRGBO(255, 137, 47, 1),
                              child: const Center(
                                child: Text(
                                  "遲到",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: widgetWidth / 4,
                              color: const Color.fromRGBO(0, 0, 0, 1),
                              child: const Center(
                                child: Text(
                                  "放棄",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {},
                              child: Container(
                                width: widgetWidth / 4,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                child: const Center(
                                  child: Text(
                                    "取消預約",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color.fromRGBO(0, 0, 0, 1)),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
