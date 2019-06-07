import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:mon_guide_musculation/models/forum.dart';
import 'package:mon_guide_musculation/ui/widgets/circular_user_avatar.dart';

String horseUrl = 'https://i.stack.imgur.com/Dw6f7.png';
String cowUrl = 'https://i.stack.imgur.com/XPOr3.png';
String camelUrl = 'https://i.stack.imgur.com/YN0m7.png';
String sheepUrl = 'https://i.stack.imgur.com/wKzo8.png';
String goatUrl = 'https://i.stack.imgur.com/Qt4JP.png';

class XForumWidget extends StatelessWidget {
  Widget bodyList(List<ForumThread> threads) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          ForumThread thread = threads[index];

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: ListTile(
              leading: CircularUserAvatar(
                user: thread.owner,
              ),
              title: Text(thread.title),
            ),
          );
        }, childCount: threads.length),
      );

  Widget bodySliverList() {
    return RefreshIndicator(
      child: FutureBuilder<List<ForumThread>>(
        future: Managers.forumManager.fetchPost(true),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                  slivers: <Widget>[
                    bodyList(snapshot.data),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      onRefresh: () async {
        await Managers.articleManager.fetchPost(false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodySliverList(),
    );

    /*ListView(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.account_circle),
          ),
          title: Text('dev: test1'),
          subtitle: Text('Enzo CACERES (dev) · Admin\n59 réponses'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            print('sheep');
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://static.wixstatic.com/media/1bf8c6_93938e2c2d1a4f6aab8bccf32a262750~mv2.jpeg"),
          ),
          title: Text('Bienvenue sur le Forum !'),
          subtitle: Text('Mahé · Admin\n8 réponses'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            print('goat');
          },
        ),
      ],
    ); */
  }
}
