import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardScreen.dart';

class RoleMangementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DashboardScreen(
      pageName: '角色管理',
      api: 'shopUser/views/pageSetting/roleMangement',
      // api: 'shopUser/views/pageSetting/accountManagement',
      rowData: '',
    );
  }
}
