import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardPage.dart';

class MeauManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      '菜單管理',
      '', //rowData
      'shopUser/views/shopMeau/menu', //API
    );
  }
}
