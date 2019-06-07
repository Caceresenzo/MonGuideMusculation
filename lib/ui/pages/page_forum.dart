import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/ui/widgets/circular_user_avatar.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/ui/widgets/wix_block_list.dart';
import 'package:mon_guide_musculation/utils/constants.dart';

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
        subtitle: Text(forumThread.owner.name + "\n" + Texts.responseCount(forumThread.content.totalComments)),
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

        _initialized = true;
      }
    });
  }

  Widget buildItem(BuildContext context, int index) {
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
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return buildItem(context, index);
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

  Widget _buildIconValue(IconData icon, dynamic value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 2.0,
      ),
      child: Row(
        children: <Widget>[
          Icon(icon),
          Container(
            width: 8,
          ),
          Text(value.toString()),
        ],
      ),
    );
  }

  Widget _buildThreadInfoCard(BuildContext context) {
    return Card(
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
                _buildIconValue(Icons.comment, forumThread.stats.totalComments),
                _buildIconValue(Icons.thumb_up, forumThread.stats.likeCount),
                _buildIconValue(Icons.remove_red_eye, forumThread.stats.viewCount),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(forumThread.title),
        backgroundColor: Constants.colorAccent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
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
