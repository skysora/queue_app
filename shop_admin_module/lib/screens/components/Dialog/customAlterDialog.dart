import 'package:flutter/material.dart';

class CostomAlterDialog extends StatefulWidget {
  @override
  CostomAlterDiaglogState createState() => CostomAlterDiaglogState();
}

class CostomAlterDiaglogState extends State<CostomAlterDialog> {
  void showDialogBox(BuildContext context, String message, String title) {
    // flutter defined function
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
