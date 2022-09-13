import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardScreen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardScreen(
      pageName: '角色管理',
      api: 'shopUser/views/pageSetting/dashboard',
      rowData: '',
    );
  }
}
