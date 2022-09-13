// const gobalUrl = 'http://192.168.1.112:80';
import 'package:shop_admin_module/screens/screen/pageSetting/accountManagement.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/mainScreen.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/roleMangement.dart';
import 'package:shop_admin_module/screens/screen/pageSetting/shopMangement.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/addressInformation.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/advertiseManagement.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/bookOrder.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/bussinessHours.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/couponManagement.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/meauManagement.dart';
import 'package:shop_admin_module/screens/screen/shopMeau/shopInformation.dart';

const gobalUrl = 'https://uatqueuing.eshf-it.com';
// const gobalUrl = 'http://0.0.0.0:80';
// const gobalUrl = 'http://127.0.0.1';
const gobalUrlAPI = gobalUrl + '/api/';

// baseSetting
final pageSetting = [
  {
    "isGroup": false,
    "title": "儀表板",
    "onTop": true,
    "svgSrc": "assets/icons/dashboard.png",
    "svgSrc_selected": "assets/icons/dashboard.png",
    "onPress": MainScreen(),
  },
  {
    "isGroup": false,
    "title": "我的商戶",
    "onTop": false,
    "svgSrc": "assets/icons/myshop.png",
    "svgSrc_selected": "assets/icons/myshop_selected.png",
    "onPress": ShopMangementScreen(),
  },
  {
    "isGroup": false,
    "title": "帳戶管理",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": AccountManagementScreen(),
  },
  {
    "isGroup": false,
    "title": "角色管理",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": RoleMangementScreen(),
  },
];

final shopMeau = [
  {
    "isGroup": false,
    "title": "預約訂單",
    "onTop": true,
    "svgSrc": "assets/icons/dashboard.png",
    "svgSrc_selected": "assets/icons/dashboard.png",
    "onPress": BookOrder(),
  },
  {
    "isGroup": false,
    "title": "廣告管理",
    "onTop": false,
    "svgSrc": "assets/icons/myshop.png",
    "svgSrc_selected": "assets/icons/myshop_selected.png",
    "onPress": AdvertiseManagement(),
  },
  {
    "isGroup": false,
    "title": "商戶資訊",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": ShopInformation(),
  },
  {
    "isGroup": false,
    "title": "營業時間",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": BussinessHours(),
  },
  {
    "isGroup": false,
    "title": "地址訊息",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": AddressInformation(),
  },
  {
    "isGroup": false,
    "title": "菜單管理",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": MeauManagement(),
  },
  {
    "isGroup": false,
    "title": "優惠卷管理",
    "onTop": false,
    "svgSrc": "assets/icons/account.png",
    "svgSrc_selected": "assets/icons/account_selected.png",
    "onPress": CouponManagement(),
  },
];
// POST
const loginAPI = '/api/auth/shopuser/login';
const forgetPasswordAPI = '/api/auth/shopuser/forgetPassword';
const forgetPasswordVerifyAPI = '/api/auth/shopuser/forgetPasswordVerify';

const getUserShopIDAPI = '/api/shopUser/shops/users/info/';

// GET
const getMeauHaederIconAPI =
    gobalUrl + '/api/images/image+logo+profileIcon.png';
const getProfileImageAPI = gobalUrl + '/api/images/image+logo+profileIcon.png';

// 以下兩個暫時沒使用
const fileStoreAPI = '/api/storeFile';
const editfileAPI = '/api/getFile';
