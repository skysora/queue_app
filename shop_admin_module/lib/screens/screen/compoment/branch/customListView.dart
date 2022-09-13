import 'package:flutter/material.dart';

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'dart:math' as math;
import 'package:shop_admin_module/screens/Class/server.dart';
import 'package:shop_admin_module/screens/components/DataTable/cardHeader.dart';
import 'package:shop_admin_module/screens/components/DataTable/myDataTableData.dart';
import 'package:shop_admin_module/screens/components/Dialog/CustomDialog.dart';
import 'package:shop_admin_module/screens/setting/constants.dart';

import 'listViewCard.dart';

class CustomListView extends StatefulWidget {
  CustomListView({
    Key? key,
    this.header,
    this.dataAPI,
    this.controller,
    this.setting,
    this.actions,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.firstRowIndex = 0,
    this.rowsPerPage = defaultRowsPerPage,
    this.dragStartBehavior = DragStartBehavior.start,
    this.showFirstLastButtons = false,
    this.arrowHeadColor,
    this.onPageChanged,
    required this.source,
    this.checkboxHorizontalMargin,
    this.initialFirstRowIndex,
  })  : assert(actions == null || (actions != null && header != null)),
        assert(dragStartBehavior != null),
        assert(headingRowHeight != null),
        assert(horizontalMargin != null),
        assert(columnSpacing != null),
        assert(source != null),
        super(key: key);

  /// The table card's optional header.
  ///
  /// This is typically a [Text] widget, but can also be a [Row] of
  /// [TextButton]s. To show icon buttons at the top end side of the table with
  /// a header, set the [actions] property.
  ///
  /// If items in the table are selectable, then, when the selection is not
  /// empty, the header is replaced by a count of the selected items. The
  /// [actions] are still visible when items are selected.
  final Widget? header;
  final String? dataAPI;
  final setting;
  final ScrollController? controller;
  final int firstRowIndex;
  static const int defaultRowsPerPage = 10;
  final int rowsPerPage;
  final ValueChanged<List>? onPageChanged;

  /// Flag to display the pagination buttons to go to the first and last pages.
  final bool showFirstLastButtons;

  /// Icon buttons to show at the top end side of the table. The [header] must
  /// not be null to show the actions.
  ///
  /// Typically, the exact actions included in this list will vary based on
  /// whether any rows are selected or not.
  ///
  /// These should be size 24.0 with default padding (8.0).
  final List<Widget>? actions;

  /// The height of the heading row.
  ///
  /// This value is optional and defaults to 56.0 if not specified.
  final double headingRowHeight;

  /// The horizontal margin between the edges of the table and the content
  /// in the first and last cells of each row.
  ///
  /// When a checkbox is displayed, it is also the margin between the checkbox
  /// the content in the first data column.
  ///
  /// This value defaults to 24.0 to adhere to the Material Design specifications.
  ///
  /// If [checkboxHorizontalMargin] is null, then [horizontalMargin] is also the
  /// margin between the edge of the table and the checkbox, as well as the
  /// margin between the checkbox and the content in the first data column.
  final double horizontalMargin;

  /// The horizontal margin between the contents of each data column.
  ///
  /// This value defaults to 56.0 to adhere to the Material Design specifications.
  final double columnSpacing;

  /// The index of the first row to display when the widget is first created.
  final int? initialFirstRowIndex;

  /// The data source which provides data to show in each row. Must be non-null.
  ///
  /// This object should generally have a lifetime longer than the
  /// [PaginatedDataTable] widget itself; it should be reused each time the
  /// [PaginatedDataTable] constructor is called.
  final MyDataTableData source;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// Horizontal margin around the checkbox, if it is displayed.
  ///
  /// If null, then [horizontalMargin] is used as the margin between the edge
  /// of the table and the checkbox, as well as the margin between the checkbox
  /// and the content in the first data column. This value defaults to 24.0.
  final double? checkboxHorizontalMargin;

  /// Defines the color of the arrow heads in the footer.
  final Color? arrowHeadColor;

  @override
  CustomListViewState createState() => CustomListViewState();
}

/// Holds the state of a [PaginatedDataTable].
///
/// The table can be programmatically paged using the [pageTo] method.
class CustomListViewState extends State<CustomListView> {
  late int _rowCount;
  late bool _rowCountApproximate;
  int _selectedRowCount = 0;
  late int _firstRowIndex;
  final Map<int, DataRow?> _rows = <int, DataRow?>{};

  @override
  void initState() {
    super.initState();
    _firstRowIndex = widget.firstRowIndex;
    // print(PageStorage.of(context)?.readState(context) as int);
    // PageStorage.of(context)?.readState(context) as int? ??
    //     widget.initialFirstRowIndex ??
    //     0;
    widget.source.addListener(_handleDataSourceChanged);
    _handleDataSourceChanged();
  }

  @override
  void didUpdateWidget(CustomListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      _rows.clear();
    });
  }

  /// Ensures that the given row is visible.
  Future<void> pageTo(int rowIndex) async {
    final int oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final int rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
    });
    if ((widget.onPageChanged != null) &&
        (oldFirstRowIndex != _firstRowIndex)) {
      final int rowsPerPage = widget.rowsPerPage;
      int paged = ((_firstRowIndex / rowsPerPage) as int) + 1;
      var data = await Server().onPageChanged(
        paged,
        widget.setting,
        context,
      );
      if (data.isEmpty) {
        setState(() {
          _firstRowIndex = _firstRowIndex - rowsPerPage;
        });
      }
      widget.onPageChanged!(data);
    }
  }

  void _handleFirst() {
    pageTo(0);
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex - widget.rowsPerPage, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex + widget.rowsPerPage);
  }

  void _handleLast() {
    pageTo(((_rowCount - 1) / widget.rowsPerPage).floor() * widget.rowsPerPage);
  }

  bool _isNextPageUnavailable() =>
      !_rowCountApproximate &&
      (_firstRowIndex + widget.rowsPerPage >= _rowCount);

  final GlobalKey _tableKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    // FOOTER
    final TextStyle? footerTextStyle = themeData.textTheme.caption;
    final List<Widget> footerWidgets = <Widget>[];
    // 可以選擇跳頁的選單

    footerWidgets.addAll(<Widget>[
      Container(width: 32.0),
      // 顯示所有頁數
      // Text(
      //   localizations.pageRowsInfoTitle(
      //     _firstRowIndex + 1,
      //     _firstRowIndex + widget.rowsPerPage,
      //     _rowCount,
      //     _rowCountApproximate,
      //   ),
      // ),
      // Container(width: 32.0),

      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_previous, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.firstPageTooltip,
          onPressed: _firstRowIndex <= 0 ? null : _handleFirst,
        ),
      // 顯示上一頁及下一頁
      if (widget.onPageChanged != null)
        IconButton(
          icon: Icon(Icons.chevron_left, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.previousPageTooltip,
          onPressed: _handlePrevious,
        ),
      Container(width: 24.0),
      if (widget.onPageChanged != null)
        IconButton(
          icon: Icon(Icons.chevron_right, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.nextPageTooltip,
          onPressed: _handleNext,
        ),

      if (widget.showFirstLastButtons)
        IconButton(
          icon: Icon(Icons.skip_next, color: widget.arrowHeadColor),
          padding: EdgeInsets.zero,
          tooltip: localizations.lastPageTooltip,
          onPressed: _isNextPageUnavailable() ? null : _handleLast,
        ),
      Container(width: 14.0),
    ]);
    // CARD
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CardHeader(
                    setting: widget.setting, dataTableManage: widget.source),
                // Semantics(
                //   container: true,
                //   child: DefaultTextStyle(
                //     style: Theme.of(context)
                //         .textTheme
                //         .headline6!
                //         .copyWith(fontWeight: FontWeight.w400),
                //     child: IconTheme.merge(
                //       data: const IconThemeData(
                //         opacity: 0.54,
                //       ),
                //       child: Ink(
                //         height: DataTableHeaderHeight,
                //         // color: themeData.secondaryHeaderColor,
                //         child: Padding(
                //           padding: const EdgeInsetsDirectional.only(
                //               start: 24, end: 14.0),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             children: [
                //               Expanded(
                //                   child:
                //                       Text("分店", style: dataTableTitleStyle)),
                //               ElevatedButton(
                //                 child: Row(
                //                   children: [
                //                     Image.asset(
                //                       'assets/icons/add_role.png',
                //                       width: addButtonIconSize,
                //                       height: addButtonIconSize,
                //                     ),
                //                     SizedBox(
                //                       width: 5,
                //                     ),
                //                     Text("新增分店",
                //                         style: TextStyle(
                //                             color: Color(0xFF6C5231),
                //                             fontSize: addButtonTextSize,
                //                             fontWeight: FontWeight.bold)),
                //                   ],
                //                 ),
                //                 style: ElevatedButton.styleFrom(
                //                   primary: Color((0xFFFFE34B)),
                //                   padding: EdgeInsets.all(defaultPadding),
                //                 ),
                //                 onPressed: () async {
                // var res = await CustomDialogState()
                //     .showBranchAddDialogBox(
                //   context,
                //   widget.source,
                //   widget.setting["addButton"]
                //       ["objectSetting"],
                // );
                //                 },
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                // header分隔線
                Divider(color: Color(0xFFF0F0F0)),
                Container(
                  height: MediaQuery.of(context).size.height - 140,
                  child: SingleChildScrollView(
                    controller: widget.controller,
                    scrollDirection: Axis.vertical,
                    dragStartBehavior: widget.dragStartBehavior,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: constraints.minWidth,
                            maxHeight: double.infinity),
                        child: Column(
                          children: [
                            for (var index = 0;
                                index < widget.source.data.length;
                                index++)
                              SizedBox(
                                  child: ListViewCard("我的商戶", widget.source,
                                      index, widget.dataAPI!, widget.setting)),
                          ],
                        )),
                  ),
                ),
                DefaultTextStyle(
                  style: footerTextStyle!,
                  child: IconTheme.merge(
                    data: const IconThemeData(
                      opacity: 0.54,
                    ),
                    child: SizedBox(
                      // TODO(bkonyi): this won't handle text zoom correctly,
                      //  https://github.com/flutter/flutter/issues/48522
                      height: 56.0,
                      child: SingleChildScrollView(
                        dragStartBehavior: widget.dragStartBehavior,
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Row(
                          children: footerWidgets,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
