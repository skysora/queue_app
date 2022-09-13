# shop_admin_module
![](https://img.shields.io/static/v1?label=dart&message=2.15.0&color=yellow)

***這個 Module 可參考[CMS 前端](https://git.eshf-it.com/fok.alvin/cms-module/-/tree/shop_admin_module)***




## Table of Contents

- [Introduction](#introduction)
- [Install](#install)
- [Parameter](#parameter)
- [頁面說明](#api)
  - [main.dart](#main.dart)
  - [login.dart](#login.dart)
  - [ObjectFactory.dart](#ObjectFactory.dart)
<!-- - [Todo](#todo) -->




## Introduction

* 後端請參考[API postman](https://documenter.getpostman.com/view/17249486/UUy3ASbz#859eac29-dfc3-4dd0-9e26-d48b69b29a49)
  [前端UI](https://lanhuapp.com/web/#/item/project/detailDetach?pid=1472189d-4408-47f9-808d-59b2366f440b&project_id=1472189d-4408-47f9-808d-59b2366f440b&image_id=d17ab9aa-1c4b-47eb-805a-ed9f82c76e2d&fromEditor=true)
  [後端](https://git.eshf-it.com/queue-up/cms)


## Install

在下載專安之前，你需要先下載好[flutter](https://flutter.dev/docs/get-started/install).



```sh
$ git https://git.eshf-it.com/fok.alvin/cms-module.git
$ cd ./cms
$ flutter run
```
注意：你必須先選好網頁的模擬器，例如:Chrome.
檢查現有的Devices
```sh
flutter devices
```
指定Devices執行
```sh
flutter run -d <devices-ID>
```
  

## parameter

* 在檔案路徑./cms/shop_admin_module/lib/constants.dart 內，以下顯示本專安有用到的參數調整。
* constants 檔案主要在調整layouts

| Parameter | Description |
| --- | --- |
| gobalUrl | 連接你的IP address |
| loginAPI | 登入API address |
| getUserShopIDAPI | 獲取登入使用者資料API address |
| pageSetting | 獲取登入使用者資料API address |
| pageSetting | 儀表板、我的商戶、帳戶管理、角色管理、對應連結設定 |
| shopMeau | 預約訂單、廣告管理、商戶資訊、營業時間、地址訊息、菜單管理、優惠卷管理 對應連結設定 |


## 頁面說明

  * 大部分的修改在路徑./cms/shop_admin_module/lib/screens/setting/api.dart中。
  * api 檔案主要是在調整API路徑。
  * 與[CMS 前端](https://git.eshf-it.com/fok.alvin/cms-module/-/tree/shop_admin_module)重複API不加以論述
  * 頁面置放路徑在./cms/shop_admin_module/lib/screens中


## main.dart
  說明:此頁面會確認使用者是否儲存token，若有則能自動登入。
  注意：此token不一定是能通過登入的token

核心code:
```
void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }
```

## login.dart

  說明：主要驗證API是Server().authData(data, url),登入資料會再這邊做儲存，主要做登入，登入成功再去取使用者資料。
  注意:rowData是傳到後端的重要資訊，可擴充但要與後端對應。
 
核心code：
```
authData(data, apiUrl) async {
  1.登入
  2.成功去取使用者資料
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString('user', json.encode(body['user_id']));
  localStorage.setString(
            'username', json.encode(userDetail["data"]['username'].toString()));
  localStorage.setString('token', json.encode(body['token']));
  localStorage.setString(
            'shop_id', json.encode(userDetail["data"]['shop_id']));
  localStorage.setString(
            'branch_id', json.encode(userDetail["data"]['branch_id']));
  localStorage.setString(
            'group_id', json.encode(userDetail["data"]['group_id']));
  localStorage.setString('identifier', json.encode(data['identifier']));
  // rowData : shop_id+branch_id+group_id+identifier
  var rowData = userDetail["data"]['shop_id'].toString() +
            "+" +
            userDetail["data"]['branch_id'].toString() +
            "+" +
            userDetail["data"]['group_id'].toString() +
            "+" +
            data['identifier'].toString();

  localStorage.setString('rowData', json.encode(rowData));
}
```

## ObjectFactory.dart

此專案擴充的元件

LoadDataObject:
    * shopDetailPage
    * closingTimeCard
    * callNumberView
    * getTicketView
    * couponView
    * shopListViewSideBar
    * ShopViewTopBar
    * bookingListView

Appbar:
    * callNumberTopBar
    * myAppBar
    * MyAppPageBar




