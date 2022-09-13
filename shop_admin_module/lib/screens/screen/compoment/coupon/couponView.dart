import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:intl/intl.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class CouponView extends StatefulWidget {
  CouponView({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final setting;
  final MyDataTableData dataTableManage;
  @override
  State<CouponView> createState() => _CouponViewState(setting, dataTableManage);
}

class _CouponViewState extends State<CouponView> {
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
  _CouponViewState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    // columns
    List<DataColumn> columns = [];
    var columnKeys;
    if (this.dataTableManage.columns.isEmpty) {
      columnKeys = this.dataTableManage.data[0].data.keys;
    } else {
      columnKeys = this.dataTableManage.columns.keys;
    }
    return Container(
      height: widgetHeight,
      width: widgetWidth,
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: Column(
        children: [
          // header
          // CardHeader(setting: setting, dataTableManage: this.dataTableManage),
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
                    padding:
                        const EdgeInsetsDirectional.only(start: 24, end: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            child: Text("商戶資訊", style: dataTableTitleStyle)),
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
                                .showCouponAddDialogBox(
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

          //column title
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
                children: [
                  SizedBox(
                    width: widgetWidth * 0.25,
                    child: Text(
                      "優惠卷名稱",
                      style: columnValueStyle,
                    ),
                  ),
                  // 優惠額度
                  SizedBox(
                    width: widgetWidth * 0.10,
                    child: const Text(
                      "優惠額度",
                      style: columnValueStyle,
                    ),
                  ),
                  // 發放數量
                  SizedBox(width: widgetWidth * 0.10, child: Text("發放數量")),
                  // 有效期
                  SizedBox(
                    width: widgetWidth * 0.05,
                    height: DataTableHeadingRowHeight / 2,
                    child: Text("有效期"),
                  ),
                  // 上架/下架時間
                  SizedBox(
                      width: widgetWidth * 0.15,
                      height: 100,
                      child: Text("上架/下架時間")),
                  // 狀態
                  SizedBox(
                    width: widgetWidth * 0.15,
                    height: DataTableHeadingRowHeight / 2,
                    child: Text("狀態"),
                  ),
                  // 編輯&刪除
                  SizedBox(
                      width: widgetWidth * 0.15,
                      height: 100 / 2,
                      child: Text("操作")),
                ]),
          ),

          SizedBox(
            height: widgetHeight -
                DataTableHeadingRowHeight -
                DataTableHeaderHeight,
            child: ListView.builder(
                itemCount: this.dataTableManage.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return dayWidget(
                      this.dataTableManage.data[index].data, index);
                }),
          )
        ],
      ),
    );
  }

  Widget dayWidget(row, index) {
    double widgetWidth = this.width;
    String status = row['status'] ?? "";
    String timetravel = "";
    String start_date = "";
    String end_date = "";
    String remark = row["remark"] ?? "";
    var data = {};
    // 優惠卷名稱
    data["names"] = Server().dataToJson(
            this.dataTableManage.data[0].data["name"].toString())[0] ??
        {};
    data["product"] = "沒有對應欄位";
    if (row["threshold"] == "0") {
      data["threshold"] = "無門檻";
      if (row["unit"] == "fixed") {
        data["coupon"] = "現金卷";
      } else {
        data["coupon"] = "折扣卷";
      }
    } else {
      data["threshold"] = "滿" + row["threshold_unit"] + row["threshold"];
      if (row["unit"] == "fixed") {
        data["coupon"] = "滿減卷";
      } else {
        data["coupon"] = "折扣卷";
      }
    }
    //優惠額度
    if (row["unit"] == "fixed") {
      data["amount"] = row["dollar_unit"] + row["amount"];
    } else {
      data["amount"] = row["amount"] + "折";
    }
    //發放數量
    if (row["unit"] == "fixed") {
      data["amount"] = row["dollar_unit"] + row["amount"];
    } else {
      data["amount"] = row["amount"] + "折";
    }
    //發放數量
    data["quantity_per_user"] = row["quantity_per_user"] ?? "0";
    data["total_quantity"] = row["total_quantity"] ?? "0";
    //有效日期 &  上架下架日期
    try {
      // date = DateFormat('yyyy-MM-dd')
      //         .format(DateTime.parse(DateTime.now().toString()));
      data["start_date"] = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(row['start_datetime'].toString()));
      data["end_date"] = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(row['end_datetime'].toString()));
      var temp = DateFormat("yyyy-MM-dd")
          .parse(row['end_datetime'])
          .difference(DateFormat("yyyy-MM-dd").parse(row['end_datetime']));
      data["timetravel"] = temp.inDays.toString();
    } catch (error) {
      data["start_date"] = "";
      data["end_date"] = "";
      data["timetravel"] = "";
    }
    //狀態
    if (row[status] == "enable") {
      data["status"] = "已發放";
    } else {
      data["status"] = "已過期";
    }
    return Container(
      height: 100,
      padding: const EdgeInsets.all(defaultPadding),
      color: const Color.fromRGBO(255, 255, 255, 1),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // 優惠卷名稱
            SizedBox(
              width: widgetWidth * 0.25,
              child: ListTile(
                title: Text(
                  data["names"]["tc"].toString(),
                  style: columnValueStyle,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 20,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Align(
                              alignment: AlignmentDirectional.center,
                              child: Text(data["coupon"].toString(),
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xFFFFFFFF)))),
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        data["product"].toString(),
                        style: columnValueStyle,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        data["threshold"].toString(),
                        style: columnValueStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 優惠額度
            SizedBox(
              width: widgetWidth * 0.10,
              child: Text(
                data["amount"],
                style: columnValueStyle,
              ),
            ),
            // 發放數量
            SizedBox(
              width: widgetWidth * 0.10,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "發放量",
                        style: columnValueStyle,
                      ),
                      Text(
                        data["total_quantity"].toString(),
                        style: columnValueStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "已領取",
                        style: columnValueStyle,
                      ),
                      Text(
                        data["quantity_per_user"].toString(),
                        style: columnValueStyle,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "已使用",
                        style: columnValueStyle,
                      ),
                      Text(
                        "null",
                        style: columnValueStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 有效期
            SizedBox(
              width: widgetWidth * 0.05,
              height: DataTableHeadingRowHeight / 2,
              child: Text(data["timetravel"].toString()),
            ),
            // 上架/下架時間
            SizedBox(
              width: widgetWidth * 0.15,
              height: 100,
              child: Column(
                children: [
                  Text("始 " + data["start_date"].toString()),
                  Text("止 " + data["end_date"].toString()),
                ],
              ),
            ),
            // 狀態
            SizedBox(
              width: widgetWidth * 0.15,
              height: DataTableHeadingRowHeight / 2,
              child: Text(data["status"]),
            ),
            // 編輯&刪除
            SizedBox(
              width: widgetWidth * 0.15,
              height: 100 / 2,
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
                      child: Text("編輯", style: columnEditStyle)),
                  SizedBox(
                    width: defaultPadding / 4,
                  ),
                  // Delete
                  IconButton(
                    onPressed: () {
                      CustomDialogState().showDeleteDialogBox(
                          context, setting, index, this.dataTableManage, false);
                    },
                    icon: Image.asset("assets/icons/delete_role.png"),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
