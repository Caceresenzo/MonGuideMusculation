import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/article_processor/article_processor.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:mon_guide_musculation/ui/arc_clipper.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/ui/widgets/top_round_background.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticlesListFragment extends StatelessWidget {
  //column1
  Widget profileColumn(BuildContext context, WebArticle article) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
              //NetworkImage(Constants.formatStaticWixImageUrl(article.authorProfilePictureSource)),
              backgroundImage: CachedNetworkImageProvider(Constants.formatStaticWixImageUrl(article.authorProfilePictureSource))),
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
          ))
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
            )
            /*FlatButton.icon(
                onPressed: null,
                icon: Icon(Icons.remove_red_eye),
                label: Text(
                  "${article.viewCount}",
                )),
            FlatButton.icon(
              onPressed: null,
              icon: Icon(Icons.thumb_up),
              label: Text("${article.likeCount}"),
            ),
            FlatButton.icon(
              onPressed: null,
              icon: Icon(Icons.comment),
              label: Text("${article.totalComments}"),
            ),*/
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  article.seoDescription,
                  style: TextStyle(fontWeight: FontWeight.normal),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              article.coverImageSource != null ? networkImage(Constants.formatStaticWixImageUrl(article.coverImageSource)) : Container(),
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
    return FutureBuilder<List<WebArticle>>(
      future: WebArticle.fetchPost(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? CustomScrollView(
                slivers: <Widget>[
                  bodyList(snapshot.data),
                ],
              )
            : Center(child: CircularProgressIndicator());
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
    List<List<ArticleContentItem>> allItems = ArticleProcessor(article: article).organize(context);

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
            widget: networkImage(Constants.formatStaticWixImageUrl(article.coverImageSource)),
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
                      ListView.builder(
                        shrinkWrap: true, // todo comment this out and check the result
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, position) {
                          List<ArticleContentItem> widgets = allItems[position];

                          return Card(
                            child: Column(
                              children: <Widget>[
                                Card(
                                  child: Container(
                                    width: double.infinity,
                                    child: widgets[0].toWidget(context),
                                  ),
                                  color: Constants.colorAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 5.0,
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true, // todo comment this out and check the result
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, position) {
                                      Widget widget = widgets[position + 1].toWidget(context);

                                      return widget;
                                    },
                                    itemCount: widgets.length - 1,
                                  ),
                                )
                              ],
                            ),
                            color: Colors.white,
                          );
                        },
                        itemCount: allItems.length,
                      ),
                      /*Card(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              article.title,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                        color: Constants.colorAccent,
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true, // todo comment this out and check the result
                            physics: ClampingScrollPhysics(),
                            itemCount: article.content.items.length,
                            itemBuilder: (context, position) {
                              var item = article.content.items[position];

                              return Padding(
                                padding: EdgeInsets.all(0),
                                child: item.toWidget(context),
                              );
                            },
                          ),
                        ),
                      ),*/
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
