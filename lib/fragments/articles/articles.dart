import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            FlatButton.icon(icon: Icon(Icons.remove_red_eye), label: Text("${article.viewCount}")),
            /*LabelIcon(
              label: "${article.likesCount} Likes",
              icon: FontAwesomeIcons.solidThumbsUp,
              iconColor: Colors.green,
            ), */
            //Text("${article.likeCount} J'Aime"),
            FlatButton.icon(icon: Icon(Icons.thumb_up), label: Text("${article.likeCount}")),
            /*LabelIcon(
              label: "${article.commentsCount} Comments",
              icon: FontAwesomeIcons.comment,
              iconColor: Colors.blue,
            ), */
            //Text("${article.totalComments} Commentaire"),
            FlatButton.icon(icon: Icon(Icons.comment), label: Text("${article.totalComments}")),
          ],
        ),
      );

  //post cards
  Widget postCard(BuildContext context, WebArticle article) {
    return GestureDetector(
      child: Card(
        elevation: 2.0,
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
            article.coverImageSource != null
                ? CachedNetworkImage(
                    imageUrl: Constants.formatStaticWixImageUrl(article.coverImageSource),
                    placeholder: (context, url) => new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fit: BoxFit.cover,
                  )
                /*Image.network(
                    Constants.formatStaticWixImageUrl(article.coverImageSource),
                    fit: BoxFit.cover,
                  ) */
                : Container(),
            article.coverImageSource != null ? Container() : CommonDivider(),
            actionColumn(article),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticleReaderFragment(
                    article: article,
                  )),
        );
      },
    );
  }

  Widget bodyList(List<WebArticle> posts) => SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
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
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: <Widget>[
                Text(
                  'HEADER',
                  style: Theme.of(context).textTheme.body2,
                ),
                ListView.builder(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
