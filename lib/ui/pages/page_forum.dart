import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/models/user.dart';
import 'package:mon_guide_musculation/ui/widgets/circular_user_avatar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(forumThread.title),
        backgroundColor: Constants.colorAccent,
      ),
      body: Text(forumThread.title),
    );
  }
}
