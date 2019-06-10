import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_processor.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/ui/widgets/card_info.dart';
import 'package:mon_guide_musculation/ui/widgets/circular_user_avatar.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/ui/widgets/common_icon_value.dart';
import 'package:mon_guide_musculation/ui/widgets/wix_block_list.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class ForumThreadWidget extends StatelessWidget {
  final ForumThread forumThread;

  const ForumThreadWidget({
    Key key,
    this.forumThread,
  }) : super(key: key);

  Widget _buildTile(BuildContext context) => ListTile(
        leading: CircularUserAvatar(
          user: forumThread.owner,
        ),
        title: Text(forumThread.title),
        subtitle: Text(forumThread.owner.name + "\n" + Texts.answerCount(forumThread.content.totalComments)),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForumScreen(
                    forumThread: forumThread,
                  ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class ForumScreen extends StatefulWidget {
  final ForumThread forumThread;

  const ForumScreen({
    Key key,
    this.forumThread,
  }) : super(key: key);

  @override
  State<ForumScreen> createState() {
    if (forumThread == null) {
      return _ForumScreenListingState();
    }

    return _ForumScreenReadingState(
      forumThread: forumThread,
    );
  }
}

class _ForumScreenListingState extends State<ForumScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _error = false;
  bool _initialized = false;

  List<ForumThread> items = new List();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      this._refreshIndicatorKey.currentState.show();
    });
  }

  Future<void> _updateItem() {
    return Managers.forumManager.fetchPost(!_initialized).then((results) {
      if (this.mounted) {
        setState(() {
          items = results;
        });

        _error = false;
        _initialized = true;

        Scaffold.of(context).hideCurrentSnackBar();
      }
    }).catchError((error) {
      print(error);

      setState(() {
        items = [];

        _error = true;
        _initialized = false;
      });

      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(Texts.snackBarError),
        action: SnackBarAction(
          label: Texts.snackBarButtonClose,
          onPressed: () {
            // Some code to undo the change!
          },
        ),
      ));
    });
  }

  Widget _buildItem(BuildContext context, int index) {
    return SizedBox(
      child: ForumThreadWidget(
        forumThread: items[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("building: " + items.length.toString());

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Constants.colorAccent,
        child: _error
            ? ListView(
                children: <Widget>[InfoCard.templateFailedToLoad()],
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _buildItem(context, index);
                },
              ),
        onRefresh: () async {
          await _updateItem();
        },
      ),
    );
  }
}

class _ForumScreenReadingState extends State<ForumScreen> {
  final ForumThread forumThread;
  List<ForumThread> items = new List();

  _ForumScreenReadingState({
    this.forumThread,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(forumThread.title),
          elevation: 0.0,
          backgroundColor: Constants.colorAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () async => openInBrowser(WixUtils.formatStaticWixPostUrl(forumThread.slug)),
              tooltip: Texts.tooltipOpenInBrowser,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.forum)),
              Tab(icon: Icon(Icons.comment)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ForumThreadTab(forumThread),
            _ForumAnwserTab(forumThread),
          ],
        ),
      ),
    );
  }
}

class _ForumThreadTab extends StatefulWidget {
  final ForumThread forumThread;

  const _ForumThreadTab(
    this.forumThread, {
    Key key,
  }) : super(key: key);

  @override
  State<_ForumThreadTab> createState() => _ForumThreadTabState(forumThread);
}

class _ForumThreadTabState extends State<_ForumThreadTab> with AutomaticKeepAliveClientMixin<_ForumThreadTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _initialized = false;

  final ForumThread forumThread;
  List<ForumThreadAnswer> items = new List();

  _ForumThreadTabState(this.forumThread);

  @override
  bool get wantKeepAlive => true;

  

  Widget _buildThreadInfoCard(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            Center(
              child: CircularUserAvatar(
                user: forumThread.owner,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              forumThread.owner.name,
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.0,
            ),
            CommonDivider(),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconValue(Icons.comment, forumThread.stats.totalComments),
                IconValue(Icons.thumb_up, forumThread.stats.likeCount),
                IconValue(Icons.remove_red_eye, forumThread.stats.viewCount),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    print("building comment: " + items.length.toString());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    children: <Widget>[
                      _buildThreadInfoCard(context),
                      WixBlockList(
                        allItems: forumThread.content.autoProcessor().organize(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumAnwserTab extends StatefulWidget {
  final ForumThread forumThread;

  const _ForumAnwserTab(
    this.forumThread, {
    Key key,
  }) : super(key: key);

  @override
  State<_ForumAnwserTab> createState() => _ForumAnwserTabState(forumThread);
}

class _ForumAnwserTabState extends State<_ForumAnwserTab> with AutomaticKeepAliveClientMixin<_ForumAnwserTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  bool _initialized = false;
  bool _error = false;

  final ForumThread forumThread;
  List<ForumThreadAnswer> items = new List();

  _ForumAnwserTabState(this.forumThread);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      this._refreshIndicatorKey.currentState.show();
    });
  }

  Future<void> _updateItem() {
    return Managers.forumManager.fetchPostAnswer(forumThread, !_initialized).then((results) {
      if (this.mounted) {
        setState(() {
          items = results;
        });

        _initialized = true;
        _error = false;
      }
    }).catchError((error) {
      print(error);

      setState(() {
        items = [];

        _initialized = false;
        _error = true;
      });

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Erreur'),
        action: SnackBarAction(
          label: 'FERMER',
          onPressed: () {
            // Some code to undo the change!
          },
        ),
      ));
    });
  }

  Widget _buildAnswerWidget(BuildContext context, ForumThreadAnswer answer) {
    bool hasChildren = answer.children.length != 0;

    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 48.0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    CircularUserAvatar(
                      user: answer.owner,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(answer.owner.name),
                    ),
                  ],
                ),
              ),
            ),
            CommonDivider(),
            WixBlockList(
              allItems: WixBlockProcessor(
                blocks: answer.items,
              ).organize(context),
            ),
            hasChildren ? CommonDivider() : Container(),
            hasChildren
                ? Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.white),
                    child: ExpansionTile(
                      title: Text(Texts.answerCount(answer.children.length)),
                      children: <Widget>[
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: answer.children.length,
                            itemBuilder: (context, index) {
                              return _buildAnswerWidget(context, answer.children[index]);
                            },
                          ),
                          decoration: new BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Constants.colorAccent,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeInfoCard() {
    Widget widget;

    if ((!_initialized && !_error) || (!_initialized && items.isEmpty && !_error)) {
      widget = Container();
    } else {
      if (_error) {
        widget = InfoCard.templateFailedToLoad();
      } else {
        widget = InfoCard.templateNoAnswer();
      }
    }

    return ListView(
      children: <Widget>[
        widget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          RefreshIndicator(
            key: _refreshIndicatorKey,
            color: Constants.colorAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: items.length == 0
                  ? _buildAlternativeInfoCard()
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildAnswerWidget(context, items[index]);
                      },
                    ),
            ),
            onRefresh: () async {
              await _updateItem();
            },
          ),
        ],
      ),
    );
  }
}
