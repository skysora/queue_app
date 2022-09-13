import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'DataTable/myDataTableData.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
    required this.dataTableManage,
  }) : super(key: key);

  final MyDataTableData dataTableManage;
  @override
  SearchFieldState createState() => SearchFieldState(dataTableManage);
}

class SearchFieldState extends State<SearchField> {
  final searchController = TextEditingController();

  List<TableInformation> data = [];
  MyDataTableData dataTableManage = new MyDataTableData();
  SearchFieldState(MyDataTableData data) {
    this.dataTableManage = data;
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: searchFieldWidth,
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
            hintText: "Search",
            fillColor: searchFieldBackgroud,
            filled: true,
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: searchFieldborderSideColor,
                    width: searchFieldborderSideWidth),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            suffixIcon: InkWell(
              onTap: () {
                // 如果要自己搞定
                var updateDataTableData = Server()
                    .search(searchController.text, dataTableManage.allData);
                dataTableManage.updateData(updateDataTableData);
              },
              child: Container(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  decoration: BoxDecoration(
                      color: searchFieldIconBackgroud,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: SvgPicture.asset("assets/icons/Search.svg")),
            )),
      ),
    );
  }
}
