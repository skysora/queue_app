import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    Key? key,
    required this.setting,
    required this.dataTableManage,
  }) : super(key: key);
  final dynamic setting;
  final MyDataTableData dataTableManage;
  @override
  _CustomMapState createState() => _CustomMapState(setting, dataTableManage);
}

class _CustomMapState extends State<CustomMap> {
  var setting;
  late Widget? header;
  late List<Widget>? actions;
  late MyDataTableData dataTableManage;
  List<TableInformation> dataList = [];
  _CustomMapState(setting, MyDataTableData dataTableManage) {
    this.setting = setting;
    this.dataTableManage = dataTableManage;
  }
  void initState() {
    super.initState();
    getData();
  }

  var data = {};
  getData() {
    // top block
    data["address_line1"] = Server().convertLanguageToJson(
            this.dataTableManage.data[0].data["address_line1"].toString()) ??
        {};
    data["address_line2"] = Server().convertLanguageToJson(
            this.dataTableManage.data[0].data["address_line2"].toString()) ??
        {};
    data["address_line3"] = Server().convertLanguageToJson(
            this.dataTableManage.data[0].data["address_line3"].toString()) ??
        {};
    data["latitude"] = this.dataTableManage.data[0].data["latitude"];
    data["longitude"] = this.dataTableManage.data[0].data["longitude"];

    data["address_en"] = data["address_line1"]["en"].toString() +
        " " +
        data["address_line2"]["en"].toString() +
        " " +
        data["address_line3"]["en"].toString();
    data["address_tc"] = data["address_line1"]["tc"].toString() +
        " " +
        data["address_line2"]["tc"].toString() +
        " " +
        data["address_line3"]["tc"].toString();
    data["address_sc"] = data["address_line1"]["sc"].toString() +
        " " +
        data["address_line2"]["sc"].toString() +
        " " +
        data["address_line3"]["sc"].toString();
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
                    //     setting: setting, dataTableManage: dataTableManage),
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
                                          .showMapEditDialogBox(
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
                    // Map
                    map(),
                    bottomBlock()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container map() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      width: MediaQuery.of(context).size.width * this.setting['width'],
      height: MediaQuery.of(context).size.height * this.setting['height'],
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(double.parse(data["latitude"].toString()),
              double.parse(data["longitude"].toString())),
          zoom: 18.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            // attributionBuilder: (_) {
            //   return Text("© OpenStreetMap contributors");
            // },
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(double.parse(data["latitude"].toString()),
                    double.parse(data["longitude"].toString())),
                builder: (context) => Scaffold(
                  backgroundColor: Colors.transparent,
                  body: IconButton(
                    icon: Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45.0,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container bottomBlock() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      width: MediaQuery.of(context).size.width * this.setting['width'],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("英文地址", style: shopDetailMeauListTitleLeadingTextStyle),
                Text(this.data["address_en"].toString(),
                    style: shopDetailMeauListTitleTrailingTextStyle),
              ],
            ),
          ),
          Spacer(),
          SizedBox(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("繁體中文地址", style: shopDetailMeauListTitleLeadingTextStyle),
              Text(this.data["address_tc"].toString(),
                  style: shopDetailMeauListTitleTrailingTextStyle)
            ],
          )),
          Spacer(),
          SizedBox(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("繁體中文地址", style: shopDetailMeauListTitleLeadingTextStyle),
              Text(this.data["address_sc"].toString(),
                  style: shopDetailMeauListTitleTrailingTextStyle)
            ],
          ))
        ],
      ),
    );
  }
}
