import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';

import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';

import 'myDataTableData.dart';

class VerticalDataTable extends StatefulWidget {
  const VerticalDataTable({
    Key? key,
    required this.dataAPI,
    required this.keys,
    required this.title,
    required this.dataTableManage,
    required this.index,
  }) : super(key: key);
  final String dataAPI;
  final keys;
  final String title;
  final MyDataTableData dataTableManage;
  final int index;
  @override
  VerticalDataTableState createState() =>
      VerticalDataTableState(dataAPI, keys, title, dataTableManage, index);
}

class VerticalDataTableState extends State<VerticalDataTable> {
  late int index = 0;
  String dataAPI = "";
  var keys;
  String title = "";
  List<TableInformation> dataList = [];
  MyDataTableData dataTableManage = MyDataTableData();
  VerticalDataTableState(String dataAPI, keys, String title,
      MyDataTableData dataTableManage, int index) {
    this.dataAPI = dataAPI;
    this.keys = keys;
    this.title = title;
    this.dataTableManage = dataTableManage;
    this.index = index;
  }

  get http => null;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
          color: dataTableBackgroud,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 1.5,
                          vertical: defaultPadding),
                    ),
                    onPressed: () async {
                      var res = await CustomDialogState().showEditDialogBox(
                        context,
                        index,
                        dataTableManage,
                        dataAPI,
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text("編輯")),
                SizedBox(
                  width: defaultPadding,
                ),
                ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding * 1.5,
                          vertical: defaultPadding),
                    ),
                    onPressed: () async {
                      await CustomDialogState().showDeleteDialogBox(
                          context, this.dataAPI, index, dataTableManage, true);
                    },
                    icon: Icon(Icons.add),
                    label: Text("刪除")),
              ],
            ),
          ),
          SizedBox(
            child: Text(this.title,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          SizedBox(
            child: FutureBuilder<List<TableInformation>>(
              future: fetchData(dataAPI),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error!.toString()),
                    // child: Text('An error has occurred!'),
                  );
                } else if (snapshot.hasData) {
                  this.dataList = snapshot.data!;
                  dataTableManage.setData([dataList[index]], context, dataAPI);
                  return Container(
                    color: Colors.white,
                    child: Table(
                      border: TableBorder(
                          horizontalInside: BorderSide(
                              width: 2,
                              color: Color(0xFFF0F0F0),
                              style: BorderStyle.solid)),
                      columnWidths: {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(4),
                      },
                      children: [
                        TableRow(children: [
                          Container(
                            padding: EdgeInsets.all(defaultPadding / 2),
                            child: Text('Field',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: defaultNormalSzie,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            padding: EdgeInsets.all(defaultPadding / 2),
                            child: Text('Info',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: defaultNormalSzie,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                        for (final key in keys)
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.all(defaultPadding / 2),
                              child: Text(key,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: defaultNormalSzie,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Container(
                              padding: EdgeInsets.all(defaultPadding / 2),
                              child: Text(
                                  snapshot.data![index].data[key].toString(),
                                  textAlign: TextAlign.center),
                            ),
                          ]),
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
