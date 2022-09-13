import 'package:flutter/material.dart';
import 'package:shop_admin_module/screens/components/Screen/dashboardScreen.dart';

class AccountManagementScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return DashboardScreen(
      pageName: '帳戶管理',
      api:
          'shopUser/views/pageSetting/accountManagement',
      rowData: '',
    );
  }
}
