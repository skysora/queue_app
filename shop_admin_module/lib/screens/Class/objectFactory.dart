import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_admin_module/screens/Class/TableInformation.dart';
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/fileFiled/datetimePicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/mutiDrownList.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/countryCode.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/downList.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/fileFiled/filePicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/filedComponents/mutiDataPicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/passwordFiled.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/normalFiled.dart';
import 'package:shop_admin_module/screens/components/ListView/switchView.dart';
import 'package:shop_admin_module/screens/screen/compoment/branch/ShopListViewSideBar.dart';
import 'package:shop_admin_module/screens/screen/compoment/callNumber/callNumberTopBar.dart';
import 'package:shop_admin_module/screens/screen/compoment/callNumber/callNumberView.dart';
import 'package:shop_admin_module/screens/screen/compoment/coupon/couponView.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTable.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/filedComponents/colorPicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/filedComponents/datePicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/emailPicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/groupPicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/filedComponents/phonePicker.dart';
import 'package:shop_admin_module/screens/components/Dialog/Filed/timePicker.dart';
import 'package:shop_admin_module/screens/screen/compoment/branch/myListView.dart';
import 'package:shop_admin_module/screens/components/Screen/DataManageView.dart';
import 'package:shop_admin_module/screens/components/Screen/myAppBar.dart';
import 'package:shop_admin_module/screens/components/Screen/myAppPageBar.dart';
import 'package:shop_admin_module/screens/components/SideMeau/side_meau.dart';
import 'package:shop_admin_module/screens/screen/compoment/branchDetail/ShopDetailView.dart';
import 'package:shop_admin_module/screens/screen/compoment/ShopViewTopBar.dart';
import 'package:shop_admin_module/screens/screen/compoment/Reservation/bookingListView.dart';
import 'package:shop_admin_module/screens/screen/compoment/bussinessHours/closingTimeView.dart';
import 'package:shop_admin_module/screens/screen/compoment/getTicketView.dart';
import 'package:shop_admin_module/screens/screen/compoment/map/CustomMap.dart';
import 'package:shop_admin_module/screens/screen/compoment/meau/meauView.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/accountManagement.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/mainScreen.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/roleMangement.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/shopMangement.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/bookOrder.dart';
import 'package:shop_admin_module/screens/setting/api.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

class ObjectFactory {
  Builder generateObject(objects) {
    var setting = objects['objectSetting'];
    var data = objects['data'];
    var api = objects["API"];
    return Builder(builder: (BuildContext context) {
      switch (setting["type"]) {
        // if you need to user MyDataTableData load data add
        // type to here and change generateLoadDataObject function
        case "hDatatable":
        case "listView":
        case "map":
        case "shopDetailPage":
        case "closingTimeCard":
        case "callNumberView":
        case "getTicketView":
        case "meauView":
        case "couponView":
        case "shopListViewSideBar":
        case "ShopViewTopBar":
        case "bookingListView":
          return DataManageView(
            setting: setting,
          );
        case "sideMeauList":
          return SideMeau(
            setting: setting,
          );
        case "card":
          return generateCard(objects, setting, context);
        case "page":
          return generatePage(data, setting, context);
        default:
          return SizedBox();
      }
    });
  }

  Padding generateDialogFiled(objects, key, textEditingControllers, String type,
      MyDataTableData dataTableManage,
      {int index = 0}) {
    var setting = objects['objectSetting'];
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Builder(builder: (BuildContext context) {
        try {
          switch (setting['type']) {
            case "normalFiled":
              return NormalFiled(
                  setting: setting,
                  type: type,
                  textController: textEditingControllers);
            case "passwordFiled":
              return PasswordFiled(
                  setting: setting,
                  type: type,
                  textController: textEditingControllers);
            case "status":
              return DownListPicker(
                  setting: setting,
                  type: type,
                  textController: textEditingControllers,
                  dropdownMenuItemList:
                      Map<String, String>.from(setting['statusItemList']));
            case "downlist":
              return DownListPicker(
                  setting: setting,
                  type: type,
                  textController: textEditingControllers,
                  dropdownMenuItemList:
                      Map<String, String>.from(setting['statusItemList']));
            case "mutiDownlist":
              MyDataTableData sub_dataTableManage = MyDataTableData();
              if (setting["addButton"] != null) {
                List parsed = Server().dataToJson(
                    sub_dataTableManage.data[index].data[key].toString());

                List<TableInformation> dataList = parsed
                    .map<TableInformation>(
                        (json) => TableInformation.fromJson(json))
                    .toList();
                sub_dataTableManage.set(dataList, setting);
                sub_dataTableManage.context = context;
              }
              return MutiDrownList(
                setting: setting,
                textController: textEditingControllers,
                dropdownMenuItemList:
                    Map<String, String>.from(setting['statusItemList']),
                type: type,
                dataTableManage: sub_dataTableManage,
              );
            case "group":
              return GroupFiled(
                setting: setting,
                type: type,
                textController: textEditingControllers,
                dataTableManage: dataTableManage,
              );
            case "email":
              return EmailPicker(
                  setting: setting,
                  type: type,
                  textController: textEditingControllers);
            case "file":
              return FilePickerDemo(
                required: setting['required'],
                title: setting['objectName'],
                type: setting['itemType'],
                textController: textEditingControllers,
                mutiFile: setting['mutiFile'],
                readOnly: false,
                add: true,
              );

            case "time":
              return TimePicker(
                  required: setting['required'],
                  title: setting['objectName'],
                  type: setting['itemType'],
                  textController: textEditingControllers,
                  readOnly: false);
            case "color":
              return ColorPickerDemo(
                required: setting['required'],
                title: setting['objectName'],
                type: setting['itemType'],
                textController: textEditingControllers,
                readOnly: false,
              );
            case "date":
              return DatePicker(
                  required: setting['required'],
                  title: setting['objectName'],
                  type: setting['itemType'],
                  textController: textEditingControllers,
                  readOnly: false);
            case "datetime":
              return DatetimePicker(
                  required: setting['required'],
                  title: setting['objectName'],
                  type: setting['itemType'],
                  textController: textEditingControllers,
                  readOnly: false);
            case "phone":
              return PhonePicker(
                  required: setting['required'],
                  title: setting['objectName'],
                  type: setting['itemType'],
                  textController: textEditingControllers,
                  readOnly: false);
            case "countrycode":
              return CountryCodeFiled(
                  required: setting['required'],
                  title: setting['objectName'],
                  type: setting['itemType'],
                  textController: textEditingControllers,
                  readOnly: false);

            case "mutiData":
              return MutiDataPicker(
                objects: setting,
                type: type,
                textController: textEditingControllers,
                dataTableManage: dataTableManage,
              );
            default:
              return Text(setting['objectName'].toString());
          }
        } catch (error) {
          print(error.toString());
          return SizedBox();
        }
      }),
    );
  }

  Builder generateLoadDataObject(setting, dataTableManage) {
    return Builder(builder: (BuildContext context) {
      switch (setting["type"]) {
        case "hDatatable":
          return MyDataTable(
              setting: setting, dataTableManage: dataTableManage);
        case "listView":
          return MyListView(dataTableManage: dataTableManage, setting: setting);
        case "map":
          return CustomMap(setting: setting, dataTableManage: dataTableManage);
        case "ShopViewTopBar":
          return ShopViewTopBar(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "shopDetailPage":
          return ShopDetailPage(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "closingTimeCard":
          return ClosingTimeView(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "callNumberView":
          return CallNumberView(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "getTicketView":
          return GetTicketView(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "bookingListView":
          return BookingListView(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "meauView":
          return MeauView(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "couponView":
          return CouponView(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        case "shopListViewSideBar":
          return ShopListViewSideBar(
            setting: setting,
            dataTableManage: dataTableManage,
          );
        default:
          return SizedBox();
      }
    });
  }

  Container generateCard(data, setting, context) {
    return Container(
      width: MediaQuery.of(context).size.width * setting['width'],
      height: MediaQuery.of(context).size.height * setting['height'],
      child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              for (final object in data["data"]!) generateObject(object),
            ],
          )),
    );
  }

  Scaffold generatePage(data, setting, context) {
    // 第一步:先產生位置資訊
    Map<int, Map<int, List>> table = generatePositionTable(data);
    // 產生物件
    return Scaffold(
        appBar: selectAppBar(setting["bar"] ?? "", setting),
        body: SafeArea(child: Builder(builder: (context) {
          return Column(
            children: [
              for (var i = 0; i < table.length; i++)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // card level
                    for (final j in table[i]!.keys)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (final object in table[i]![j]!)
                            generateObject(object),
                        ],
                      )
                  ],
                ),
            ],
          );
        })));
  }

  Map<int, Map<int, List>> generatePositionTable(data) {
    Map<int, Map<int, List>> table = {};
    for (final object in data) {
      int i = object["objectSetting"]["position"]["row"];
      int j = object["objectSetting"]["position"]["column"];
      if (table[i] == null) {
        table[i] = {
          j: [object]
        };
      } else {
        if (table[i]![j] == null) {
          table[i]![j] = [object];
        } else {
          table[i]![j]!.add(object);
        }
      }
    }
    return table;
  }

  PreferredSizeWidget? selectAppBar(String type, setting) {
    switch (type) {
      case "callNumberTopBar":
        return CallNumberTopBar();
      case "myAppBar":
        return MyAppBar();
      case "MyAppPageBar":
        return MyAppPageBar(
          setting: setting,
        );
      default:
        return AppBar();
    }
  }

  generateDataColumn(dataColumnType, MyDataTableData dataManager, int index,
      String key, setting) {
    List<TableInformation> data = dataManager.data;
    switch (dataColumnType["type"]) {
      case "status":
        return (Container(
            alignment: Alignment.center,
            child: SwitchView(
              setting: setting,
              status: data[index].data[key].toString(),
              data: data[index].data,
              dataManager: dataManager,
              keyword: key,
            )));
      case "passwordFiled":
        return (Container(
          alignment: Alignment.center,
          child: Text(
            "******",
            style: columnValueDateTimeStyle,
          ),
        ));
      case "datetime":
        String date = DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(DateTime.now().toString()));
        if (data[index].data[key].toString() != "null") {
          date = DateFormat('yyyy-MM-dd')
              .format(DateTime.parse(data[index].data[key].toString()));
        }
        return ((Container(
          alignment: Alignment.center,
          child: Text(
            date.toString(),
            style: columnValueDateTimeStyle,
          ),
        )));
      case "file":
        return (Container(
            width: dataManager.columnWidth,
            child: ClipRRect(
              child: Image.network(
                gobalUrl +
                    '/api/images/' +
                    data[index].data[key].toString().replaceAll("/", "+"),
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/icon.png');
                },
              ),
            )));
      default:
        return (Container(
            alignment: Alignment.center,
            child: Text(data[index].data[key].toString())));
    }
  }

  generateClass(String page) {
    switch (page) {
      case "MainScreen":
        return MainScreen();
      case "ShopMangementScreen":
        return ShopMangementScreen();
      case "AccountManagementScreen":
        return AccountManagementScreen();
      case "RoleMangementScreen":
        return RoleMangementScreen();
      case "BookOrder":
        return BookOrder();
      default:
        return MainScreen();
    }
  }
}
