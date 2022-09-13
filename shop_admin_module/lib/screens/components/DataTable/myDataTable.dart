import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/components/DataTable/customPaginated_data_table.dart';
import 'package:shop_admin_module/screens/components/Dialog/customAlterDialog.dart';

import 'package:shop_admin_module/screens/setting/constants.dart';

import 'myDataTableData.dart';

class MyDataTable extends StatefulWidget {
  MyDataTable({
    Key? key,
    required this.dataTableManage,
    required this.setting,
  }) : super(key: key);
  final MyDataTableData dataTableManage;
  final setting;
  @override
  MyDataTableState createState() => MyDataTableState(dataTableManage, setting);
}

class MyDataTableState extends State<MyDataTable> {
  List<TableInformation> dataList = [];
  late var setting;
  MyDataTableData dataTableManage = MyDataTableData();
  MyDataTableState(MyDataTableData dataTableManage, setting) {
    this.dataTableManage = dataTableManage;
    this.setting = setting;
  }
  int _currentSortColumn = 0;
  late bool _isAscending;

  int _rowsPerPage = 10;
  int firstRowIndex = 0;
  @override
  void initState() {
    _isAscending = false;
    super.initState();
  }

  void onSortColum(int columnIndex, bool ascending, String itemName) {
    if (_isAscending) {
      _isAscending = false;
      dataTableManage.sort(itemName, _isAscending);
    } else {
      _isAscending = true;
      dataTableManage.sort(itemName, _isAscending);
    }
  }

  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return Container(
        width: MediaQuery.of(context).size.width * this.setting['width'],
        height: (MediaQuery.of(context).size.height - myAppBarHeight) *
            setting["height"],
        child: SingleChildScrollView(
          child: Builder(builder: (BuildContext context) {
            // columns
            this.dataTableManage.columnWidth =
                (MediaQuery.of(context).size.width * this.setting['width']) *
                    ((0.60 - 0.10) / this.dataTableManage.columns.keys.length);
            // 選擇title的Style
            List<DataColumn> columns = generateDataTitleColumn();
            return SizedBox(
              child: Scrollbar(
                controller: _scrollController,
                child: CustomPaginatedDataTable(
                  controller: _scrollController,
                  setting: this.setting,
                  source: dataTableManage,
                  initialFirstRowIndex: 0,
                  showCheckboxColumn: false,
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  header:
                      Text(setting["objectName"], style: dataTableTitleStyle),
                  availableRowsPerPage: [10, 25, 30, 40],
                  rowsPerPage: _rowsPerPage,
                  firstRowIndex: firstRowIndex,
                  onPageChanged: (data) async {
                    if (data.isEmpty) {
                      CostomAlterDiaglogState()
                          .showDialogBox(context, "沒有下一頁哦", "Error Message");
                    } else {
                      setState(() {
                        dataTableManage.setData(data, context, setting['api']);
                      });
                    }
                  },
                  columns: columns,
                ),
              ),
            );
          }),
        ));
  }

  List<DataColumn> generateDataTitleColumn() {
    List<DataColumn> columns = [];
    for (final key in this.dataTableManage.columns.keys) {
      String columnName = this.dataTableManage.dataColumnType[key]
          ["objectSetting"]["objectName"];
      switch (this.dataTableManage.dataColumnType[key]["objectSetting"]
          ["type"]) {
        case "status":
          columns.add(DataColumn(
              label: Expanded(
                child: Text(
                  columnName,
                  style: columnTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _currentSortColumn = columnIndex;
                });
                onSortColum(columnIndex, ascending, key);
              }));
          continue;
        default:
          columns.add(DataColumn(
              label: Expanded(
                child: Text(
                  columnName,
                  style: columnTitleStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              onSort: (columnIndex, ascending) {
                setState(() {
                  _currentSortColumn = columnIndex;
                });
                onSortColum(columnIndex, ascending, key);
              }));
          continue;
      }
    }
    columns.add(DataColumn(
      label: Container(
          alignment: Alignment.center,
          width: (MediaQuery.of(context).size.width * this.setting['width']) *
              0.10,
          child: Text(
            '操作',
            style: columnTitleStyle,
            // textAlign: TextAlign.center,
          )),
    ));
    return columns;
  }
}
