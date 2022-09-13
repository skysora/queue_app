import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/ListView/statusView.dart';
import 'package:shop_admin_module/screens/components/ListView/tagView.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ListViewCard extends StatefulWidget {
  late String header;
  final MyDataTableData dataTableManage;
  final int index;
  final String dataAPI;
  final setting;
  ListViewCard(
    this.header,
    this.dataTableManage,
    this.index,
    this.dataAPI,
    this.setting,
  );

  @override
  State<StatefulWidget> createState() {
    return ListViewCardState(dataTableManage, index, dataAPI, setting, header);
  }
}

class ListViewCardState extends State<ListViewCard> {
  late String header;
  late MyDataTableData dataTableManage;
  late int index;
  late Container icon;
  late Row title = Row();
  late Row subtitle = Row();
  late String dataAPI;
  late var setting;
  final Server server = Server();
  ListViewCardState(dataTableManage, index, dataAPI, setting, header) {
    this.header = header;
    this.dataTableManage = dataTableManage;
    this.index = index;
    this.dataAPI = dataAPI;
    this.setting = setting;
    dict = Map<String, String>();
  }
  late Map<String, String> dict;

  buildComponent() {
    this.dict = this.dataTableManage.data[index].data;
    for (final name in setting["columns"].keys) {
      switch (setting["columns"][name]) {
        case "title":
          Map<String, String> titleColumn = {};
          setting["title"].forEach((k, v) {
            titleColumn["$k"] = "$v";
          });

          this.title = Row(
            children: [
              for (final name in titleColumn.keys)
                Builder(builder: (context) {
                  switch (titleColumn[name]) {
                    case "text":
                      return Builder(builder: (context) {
                        var titleData =
                            Server().dataToJson(this.dict[name].toString());
                        return Container(
                          margin: const EdgeInsets.only(
                              left: defaultPadding, bottom: defaultPadding),
                          // margin: const EdgeInsets.all(defaultPadding),
                          child: Text(
                            titleData[0]["tc"],
                            style: listViewTitleStyle,
                          ),
                        );
                      });
                    case "statusView":
                      return StatusView(
                        status: this.dict[name].toString(),
                      );
                    default:
                      return SizedBox();
                  }
                }),
            ],
          );
          continue;
        case "subtitle":
          Map<String, String> subtitleColumn = {};

          setting["subtitle"].forEach((k, v) {
            subtitleColumn["$k"] = "$v";
          });
          this.subtitle = Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: defaultPadding),
              ),
              for (final name in subtitleColumn.keys)
                Builder(builder: (context) {
                  switch (subtitleColumn[name]) {
                    case "tagList":
                      return TagView(data: this.dict[name], rowLimit: 10);
                    case "text":
                      return Text(this.dict[name].toString());
                    default:
                      return SizedBox();
                  }
                }),
            ],
          );
          continue;
        case "icon":
          var filePath = "";
          if (this.dict[name].toString()[0] == "/") {
            filePath = (this.dict[name].toString()).replaceFirst("/", "");
          }
          var path = gobalUrl + '/api/images/' + filePath.replaceAll("/", "+");
          this.icon = Container(
            margin: const EdgeInsets.only(
                left: defaultPadding, bottom: defaultPadding),
            child: Transform.scale(
              scale: 2,
              child: Image.network(path,
                  errorBuilder: (BuildContext, Object, StackTrace) {
                return filePath == ""
                    ? Image.network(getProfileImageAPI)
                    : Image.network(path);
              }),
            ),
          );
          continue;
        default:
          continue;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // makesure data
  }

  @override
  Widget build(BuildContext context) {
    buildComponent();
    return InkWell(
      onTap: () {
        String rowData = "";
        Server().listViewCardButton(dataTableManage, index).then((result) {
          setState(() {
            rowData = result.toString();
          });
        });
        Route route = MaterialPageRoute(
            builder: (context) => DashboardPage(
                  setting["objectName"],
                  rowData,
                  this.dataAPI,
                ));
        if (!setting["replacePage"]) {
          Navigator.push(context, route);
        } else {
          Navigator.pushReplacement(context, route);
        }
      },
      child: Container(
        height: listViewCardHeight,
        child: Card(
            semanticContainer: true,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: this.icon,
                    title: this.title,
                    subtitle: this.subtitle,
                  ),
                ])),
      ),
    );
  }
}
