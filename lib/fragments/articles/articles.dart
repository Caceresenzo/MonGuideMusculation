import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_processor.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/ui/widgets/top_round_background.dart';
import 'package:mon_guide_musculation/ui/widgets/wix_block_list.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesListFragment extends StatelessWidget {
  //column1
  Widget profileColumn(BuildContext context, WebArticle article) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(backgroundImage: CachedNetworkImageProvider(WixUtils.formatStaticWixImageUrl(article.authorProfilePictureSource))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.body1.apply(fontWeightDelta: 700),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "Écrit par ${article.author}",
                    style: Theme.of(context).textTheme.caption.apply(color: Colors.pink),
                  )
                ],
              ),
            ),
          )
        ],
      );

  //column last
  Widget actionColumn(WebArticle article) => FittedBox(
        fit: BoxFit.contain,
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text("${article.viewCount} Vues"),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.remove_red_eye),
                    Container(
                      width: 8,
                    ),
                    Text(article.viewCount.toString()),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.thumb_up),
                    Container(
                      width: 8,
                    ),
                    Text(article.likeCount.toString()),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.comment),
                    Container(
                      width: 8,
                    ),
                    Text(article.totalComments.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  //post cards
  Widget postCard(BuildContext context, WebArticle article) {
    return Card(
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleReaderFragment(
                    article: article,
                  ),
            ),
          );
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: profileColumn(context, article),
              ),
              article.seoDescription != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        article.seoDescription,
                        style: TextStyle(fontWeight: FontWeight.normal),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10.0,
              ),
              article.coverImageSource != null ? networkImage(WixUtils.formatStaticWixImageUrl(article.coverImageSource)) : Container(),
              article.coverImageSource != null ? Container() : CommonDivider(),
              actionColumn(article),
            ],
          ),
        ),
      ),
    );
  }

  Widget bodyList(List<WebArticle> posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            child: postCard(context, posts[index]),
          );
        }, childCount: posts.length),
      );

  Widget bodySliverList() {
    return RefreshIndicator(
      child: FutureBuilder<List<WebArticle>>(
        future: Managers.articleManager.fetchPost(true),
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
  }
}

class ArticleReaderFragment extends StatelessWidget {
  final WebArticle article;

  const ArticleReaderFragment({Key key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<WixBlockItem>> allItems = WixBlockProcessor(blocks: article.content.items).organize(context);

    var deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Constants.colorAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_browser),
            onPressed: () async {
              String url = article.toRemoteUrl();
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            tooltip: Texts.tooltipAbout,
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          TopRoundBackground(
            widget: networkImage(WixUtils.formatStaticWixImageUrl(article.coverImageSource)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: <Widget>[
                      /*Text(
                        'HEADER',
                        style: Theme.of(context).textTheme.body2,
                      ),*/
                      SizedBox(
                        height: deviceSize.height / 5,
                      ),
                      WixBlockList(
                        allItems: allItems,
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
