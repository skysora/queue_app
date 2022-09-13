import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/objectFactory.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class MyDataTableData extends DataTableSource {
  List<TableInformation> data = [];
  List<TableInformation> allData = [];
  var setting = {};
  var columns = {};
  double columnWidth = 100.0;
  int _selectCount = 0; //當前選中的行數
  bool _isRowCountApproximate = false; //行數確定
  late BuildContext context;
  late var backContext;
  var dataColumnType;
  String dataAPI = "";
  int idIndex = 0;

  set(
    List<TableInformation> data,
    setting,
  ) {
    this.data = data;
    this.setting = setting;
    this.dataColumnType = setting["dataColumnType"];
    for (var key in setting["dataColumnType"].keys) {
      var row = this.dataColumnType[key];
      if (row["objectSetting"]["display"]["page"]) {
        columns[key] = row["objectSetting"]["objectName"];
      }
    }
  }

  @override
  // 資料
  DataRow getRow(int index) {
    if (index >= data.length || index < 0) throw FlutterError('Data Error');
    var cells = <DataCell>[];
    // 選擇前端需要的顯示的columns
    var columnKeys = columns.keys;
    // 決定column value
    for (final key in columnKeys) {
      cells.add(DataCell(ObjectFactory().generateDataColumn(
          this.dataColumnType[key]["objectSetting"],
          this,
          index,
          key,
          setting,)));
    }
    // Action Button
    cells.add(DataCell(Container(
      alignment: Alignment.center,
      width: (MediaQuery.of(context).size.width * this.setting['width']) * 0.10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // Edit
          TextButton(
              onPressed: () async {
                var res = await CustomDialogState().showEditDialogBox(
                  context,
                  index,
                  this,
                  this.setting,
                );
                if (res.toString() != "cancel") {
                  this.data = res.data;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ObjectFactory().generateClass(setting["page"])),
                  );
                }
              },
              child: Text(
                "編輯",
                style: columnEditStyle,
              )),
          SizedBox(
            width: defaultPadding / 4,
          ),
          // Delete
          IconButton(
            onPressed: () async {
              var res = await CustomDialogState().showDeleteDialogBox(
                context,
                setting,
                index,
                this,
                false,
              );
              if (res.toString() != "cancel") {
                this.data = res.data;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ObjectFactory().generateClass(setting["page"])),
                );
              }
            },
            icon: Image.asset("assets/icons/delete_role.png"),
          ),
        ],
      ),
    )));
    return DataRow.byIndex(
      cells: cells,
      index: index,
    );
  }

  @override //是否行數不確定
  bool get isRowCountApproximate => _isRowCountApproximate;

  @override //有多少行
  int get rowCount => data.length;

  @override //選中的行數
  int get selectedRowCount => _selectCount;

  void setData(data, context, dataAPI) {
    this.data = data;
    this.context = context;
    this.dataAPI = dataAPI;
    this.allData = data;
  }

  void updateData(data) {
    this.data = data;
    notifyListeners();
  }

  void addRow(row) {
    var temp = TableInformation.convertNewRow(row);
    data.add(temp);
    notifyListeners();
  }

  void editRow(row, index) {
    for (final name in data[index].data.keys) {
      data[index].data[name] = row[name].toString();
    }
    notifyListeners();
  }

  void deleteRow(dataAPI, index) {
    data.removeAt(index);
    notifyListeners();
  }

  //排序,
  void sort(String itemName, bool _isAscending) {
    if (_isAscending) {
      data.sort((a, b) => a.data[itemName]!.compareTo(b.data[itemName]!));
    } else {
      data.sort((a, b) => b.data[itemName]!.compareTo(a.data[itemName]!));
    }
    notifyListeners();
  }

  List getDataList() {
    return this.data;
  }
}
