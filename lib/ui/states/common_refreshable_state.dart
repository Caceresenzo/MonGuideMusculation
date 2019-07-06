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

    initialize();
  }

  @protected
  void initialize() {}

  @protected
  Future<void> getFuture();
  @protected
  List<K> getNewItemListState();

  Future<void> _updateItem() {
    return getFuture().then((_) {
      if (this.mounted) {
        setState(() {
          _items = getNewItemListState();

          if (_items == null) {
            _items = [];
          }
        });

        _error = false;
        _initialized = true;

        _scaffoldKey.currentState.hideCurrentSnackBar();

        onItemUpdated(context);
      }
    }).catchError((error) {
      print(error);

      setState(() {
        _items = [];

        _error = true;
        _initialized = false;
      });

      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(buildErrorSnackBar());
    });
  }

  SnackBar buildErrorSnackBar({String message}) {
    return SnackBar(
      content: Text(message ?? Texts.snackBarError),
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

  @protected
  Color getBackgroundColor(BuildContext context) => null;

  @protected
  void onItemUpdated(BuildContext context) => null;

  @protected
  List<Widget> itemsBefore(BuildContext context) => null;

  @protected
  List<Widget> itemsAfter(BuildContext context) => null;

  @protected
  Widget floatingButtonAction(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    print("Building ${_items.length.toString()} item(s).");

    List<Widget> itemsBefore = this.itemsBefore(context);
    List<Widget> itemsAfter = this.itemsAfter(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomBar(context),
      floatingActionButton: floatingButtonAction(context),
      body: Builder(
        builder: (context) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Constants.colorAccent,
            child: Container(
                color: getBackgroundColor(context),
                child: ListView(
                  children: <Widget>[
                    (itemsBefore != null && itemsBefore.isNotEmpty)
                        ? Column(
                            children: itemsBefore,
                          )
                        : Container(),
                    Builder(
                      builder: (context) {
                        if (_error) {
                          return InfoCard.templateFailedToLoad();
                        }

                        if (_items.isEmpty && _initialized) {
                          return InfoCard.templateNoContent();
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            return buildItem(context, _items, index);
                          },
                        );
                      },
                    ),
                    (itemsAfter != null && itemsAfter.isNotEmpty)
                        ? Column(
                            children: itemsAfter,
                          )
                        : Container(),
                  ],
                )),
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

  List<K> get items => _items;
  GlobalKey<RefreshIndicatorState> get refreshIndicatorKey => _refreshIndicatorKey;
}
