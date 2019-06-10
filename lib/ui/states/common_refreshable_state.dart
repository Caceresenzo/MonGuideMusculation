import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/ui/widgets/card_info.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

abstract class CommonRefreshableState<T extends StatefulWidget, K> extends State<T> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _error = false;
  bool _initialized = false;

  List<K> _items = new List();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      this._refreshIndicatorKey.currentState.show();
    });
  }

  @protected
  Future<void> getFuture();
  @protected
  List<K> getNewItemListState();

  Future<void> _updateItem() {
    return getFuture().then((_) {
      if (this.mounted) {
        setState(() {
          _items = getNewItemListState();
        });

        _error = false;
        _initialized = true;

        _scaffoldKey.currentState.hideCurrentSnackBar();
      }
    }).catchError((error) {
      print(error);

      setState(() {
        _items = [];

        _error = true;
        _initialized = false;
      });

      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(_buildErrorSnackBar());
    });
  }

  SnackBar _buildErrorSnackBar() {
    return SnackBar(
      content: Text(Texts.snackBarError),
      action: SnackBarAction(
        label: Texts.snackBarButtonClose,
        onPressed: () {},
      ),
    );
  }

  @protected
  Widget buildItem(BuildContext context, List<K> items, int index);

  @protected
  Widget buildAppBar(BuildContext context) => null;

  @protected
  Widget buildBottomBar(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    print("building: " + _items.length.toString());

    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomBar(context),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Constants.colorAccent,
            child: _error
                ? ListView(
                    children: <Widget>[InfoCard.templateFailedToLoad()],
                  )
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return buildItem(context, _items, index);
                    },
                  ),
            onRefresh: () async {
              await _updateItem();
            },
          );
        },
      ),
    );
  }

  bool hasInitialized() => _initialized;
  bool hasError() => _error;
}
