import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/components/ListView/switchView.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class MeauView extends StatefulWidget {
  MeauView({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  State<MeauView> createState() => _MeauViewState(setting, dataTableManage);
}

class _MeauViewState extends State<MeauView> {
  late var setting;
  late MyDataTableData dataTableManage;
  late Map<int, Color> color = {
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
  _MeauViewState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool hideDetail = true;
  var dayList = {};
  late List columnKeys;
  Map<String, bool> menuList = {};
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
      String category = Server().convertLanguageToJson(this
          .dataTableManage
          .data[index]
          .data["category_names"]
          .toString())["tc"];
      tempDict[index] = this.dataTableManage.data[index].data;
      if (this.dayList.containsKey(category)) {
        this.dayList[category]!.add(tempDict);
      } else {
        this.dayList[category] = [];
        this.dayList[category]!.add(tempDict);
      }
    }
    // top block
  }

  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width * this.setting['width'],
        height: (MediaQuery.of(context).size.height - myAppBarHeight) *
            setting["height"],
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Card(
            child: SingleChildScrollView(
              child: Column(
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
                                        .showMeauEditDialogBox(
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
                  bookingWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget bookingWidget() {
    double widgetWidth = width;
    double widgetHeight = height;
    return Container(
      height: widgetHeight,
      width: widgetWidth,
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: ListView.builder(
          itemCount: this.dayList.length,
          itemBuilder: (BuildContext context, int index) {
            return categoryWidget(this.dayList.keys.toList()[index]);
          }),
    );
  }

  Widget categoryWidget(category) {
    double widgetWidth = this.width;
    List columnwidth = [0.05, 0.1, 0.20, 0.1, 0.1, 0.1, 0.1];
    List dayRecord = this.dayList[category]!;
    if (dayRecord.isEmpty) {
      return Container();
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: (menuList[category] ?? false)
                  ? const BorderSide(
                      color: Color.fromRGBO(255, 137, 47, 1),
                      width: 5.0,
                    )
                  : const BorderSide(
                      color: Color.fromRGBO(240, 240, 240, 1),
                      width: 1.0,
                    ),
              right: const BorderSide(
                color: Color.fromRGBO(240, 240, 240, 1),
                width: 1.0,
              ),
              bottom: const BorderSide(
                color: Color.fromRGBO(240, 240, 240, 1),
                width: 1.0,
              ),
              top: const BorderSide(
                color: Color.fromRGBO(240, 240, 240, 1),
                width: 1.0,
              ),
            ),
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
          child: ExpansionTile(
            title: Text(
              category,
              style: const TextStyle(
                  fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1)),
            ),
            backgroundColor: Colors.white,
            onExpansionChanged: (value) {
              setState(() {
                menuList[category] = value;
              });
            },
            initiallyExpanded: false, // 是否默认展开
            children: <Widget>[],
          ),
        ),
        // column title
        (menuList[category] ?? false)
            // column title
            ? Container(
                height: DataTableHeadingRowHeight,
                width: this.width,
                color: const Color.fromRGBO(245, 245, 245, 1),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: widgetWidth * columnwidth[0],
                      ),
                      //菜單圖片
                      SizedBox(
                        width: widgetWidth * columnwidth[1],
                        child: const Text(
                          "菜品圖片",
                          style: columnTitleStyle,
                        ),
                      ),
                      //菜名
                      SizedBox(
                        width: widgetWidth * columnwidth[2],
                        child: const Text(
                          "菜名",
                          style: columnTitleStyle,
                        ),
                      ),
                      //售價
                      SizedBox(
                        width: widgetWidth * columnwidth[3],
                        child: const Text(
                          "售價(HK\$)",
                          style: columnTitleStyle,
                        ),
                      ),
                      //會員價
                      SizedBox(
                        width: widgetWidth * columnwidth[4],
                        child: const Text(
                          "會員價(HK\$)",
                          style: columnTitleStyle,
                        ),
                      ),
                      //市價下架時間
                      SizedBox(
                        width: widgetWidth * columnwidth[5],
                        child: const Text(
                          "上架/下架時間",
                          style: columnTitleStyle,
                        ),
                      ),
                      //狀態
                      SizedBox(
                        width: widgetWidth * columnwidth[6],
                        child: const Text(
                          "狀態",
                          style: columnTitleStyle,
                        ),
                      ),
                      //操作
                      SizedBox(
                        width: widgetWidth * 0.1,
                        child: const Text(
                          "操作",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(153, 153, 153, 1)),
                        ),
                      ),
                    ]),
              )
            : Container(),
        (menuList[category] ?? false)
            ? Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                height: (dayRecord.length * 100) + 40,
                child: ReorderableListView(
                  children: dayList[category]!.map<Widget>((record) {
                    int key = record.keys.first as int;
                    record = record[key];
                    int index = dayList[category]!
                        .indexWhere((element) => element['id'] == record['id']);

                    String icon_path = record['icon_path'].toString();
                    String name = Server().convertLanguageToJson(
                            record['name'].toString())["tc"] ??
                        "";
                    String price = record['price'] ?? "";
                    String member_price = "無對應欄位";
                    String start_datetime = record['start_datetime'];
                    String end_datetime = record['end_datetime'];
                    String status = record['status'];

                    return Container(
                      key: Key(record['id'].toString()),
                      height: 100,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: widgetWidth * columnwidth[0],
                                child: const Center(
                                  child: Icon(Icons.menu,
                                      color: Color.fromRGBO(224, 224, 224, 1)),
                                )),
                            // 菜單圖片
                            SizedBox(
                              width: widgetWidth * columnwidth[1],
                              child: ClipRRect(
                                child: Image.network(
                                    gobalUrl +
                                        '/api/images/' +
                                        icon_path.replaceAll("/", "+"),
                                    width: widgetWidth * columnwidth[1] * 0.8),
                              ),
                            ),
                            // 菜名
                            SizedBox(
                              width: widgetWidth * columnwidth[2],
                              child: Text(
                                name,
                                style: columnValueStyle,
                              ),
                            ),
                            // 售價
                            SizedBox(
                              width: widgetWidth * columnwidth[3],
                              child: Text(
                                price,
                                style: columnValueStyle,
                              ),
                            ),
                            // 會員售價
                            SizedBox(
                              width: widgetWidth * columnwidth[4],
                              child: Text(
                                member_price,
                                style: columnValueStyle,
                              ),
                            ),
                            //上架下架時間
                            SizedBox(
                              width: widgetWidth * columnwidth[5],
                              child: Column(
                                children: [
                                  Row(children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: defaultPadding / 4),
                                      child: const Text(
                                        "始",
                                        style: columnValueStyle,
                                      ),
                                    ),
                                    Text(
                                      start_datetime,
                                      style: columnValueDateTimeStyle,
                                    ),
                                  ]),
                                  Row(children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: defaultPadding / 4),
                                      child: const Text(
                                        "止",
                                        style: columnValueStyle,
                                      ),
                                    ),
                                    Text(
                                      end_datetime,
                                      style: columnValueDateTimeStyle,
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                            // 狀態
                            SizedBox(
                              width: widgetWidth * columnwidth[6], //SET width
                              child: SwitchView(
                                status: status.toString(),
                                setting: setting,
                                data: null,
                                dataManager: MyDataTableData(),
                                keyword: null,
                              ),
                            ),

                            SizedBox(
                              width: widgetWidth * 0.1,
                              child: Row(
                                children: [
                                  // Edit
                                  TextButton(
                                      onPressed: () {
                                        CustomDialogState().showEditDialogBox(
                                          context,
                                          index,
                                          this.dataTableManage,
                                          setting,
                                        );
                                      },
                                      child:
                                          Text("編輯", style: columnEditStyle)),
                                  SizedBox(
                                    width: defaultPadding / 4,
                                  ),
                                  // Delete
                                  IconButton(
                                    onPressed: () {
                                      CustomDialogState().showDeleteDialogBox(
                                          context,
                                          setting,
                                          index,
                                          this.dataTableManage,
                                          false);
                                    },
                                    icon: Image.asset(
                                        "assets/icons/delete_role.png"),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    );
                  }).toList(),
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      //交换数据
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final Map item = dayList[category]!.removeAt(oldIndex);
                      dayList[category]!.insert(newIndex, item);
                    });
                  },
                ),
              )
            : Container()
      ],
    );
  }

  bool ToBoolean(value) {
    switch (value) {
      case "true":
        return true;
      case "t":
        return true;
      case "1":
        return true;
      case "0":
        return false;
      case "false":
        return false;
      case "f":
        return false;
      default:
        return false;
    }
  }
}
