import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class AdvertiseManagement extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '廣告管理',
      '', //rowData
      'shopUser/views/shopMeau/advertiseManagement', //API
    );
  }
}
