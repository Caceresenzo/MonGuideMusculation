import 'package:flutter/material.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/logic/wix_block_processor/wix_block_processor.dart';
import 'package:mon_guide_musculation/models/article.dart';
import 'package:mon_guide_musculation/models/wix.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/ui/widgets/common_icon_value.dart';
import 'package:mon_guide_musculation/ui/widgets/top_round_background.dart';
import 'package:mon_guide_musculation/ui/widgets/wix_block_list.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mon_guide_musculation/utils/functions.dart';
import 'package:mon_guide_musculation/utils/wix_utils.dart';

class ArticleItemWidget extends StatelessWidget {
  final WebArticle article;

  const ArticleItemWidget(
    this.article, {
    Key key,
  }) : super(key: key);

  Widget _buildCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Card(
        elevation: 0.0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleScreen(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(backgroundImage: CachedNetworkImageProvider(WixUtils.formatStaticWixImageUrl(article.author.profilePictureFile))),
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
                                Texts.articleWroteBy + article.author.name,
                                style: Theme.of(context).textTheme.caption.apply(color: Colors.pink),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
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
                article.coverImageSource != null ? networkImage(WixUtils.formatStaticWixImageUrl(article.coverImageSource)) : CommonDivider(),
                FittedBox(
                  fit: BoxFit.contain,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconValue(Icons.comment, article.stats.totalComments),
                      IconValue(Icons.thumb_up, article.stats.likeCount),
                      IconValue(Icons.remove_red_eye, article.stats.viewCount),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }
}

class ArticleScreen extends StatefulWidget {
  final WebArticle article;

  const ArticleScreen({
    Key key,
    this.article,
  }) : super(key: key);

  @override
  State<ArticleScreen> createState() {
    if (article != null) {
      return _ArticleScreenArticleReadingState(article);
    }

    return _ArticleScreenArticlesListingState();
  }
}

class _ArticleScreenArticlesListingState extends CommonRefreshableState<ArticleScreen, WebArticle> {
  @override
  Future<void> getFuture() {
    return Managers.articleManager.fetchPost(!hasInitialized());
  }

  @override
  List<WebArticle> getNewItemListState() {
    return Managers.articleManager.cachedArticles;
  }

  @override
  Widget buildItem(BuildContext context, List<WebArticle> items, int index) {
    return SizedBox(
      child: ArticleItemWidget(items[index]),
    );
  }
}

class _ArticleScreenArticleReadingState extends State<ArticleScreen> {
  final WebArticle article;

  _ArticleScreenArticleReadingState(
    this.article,
  ) : assert(article != null);

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
            onPressed: () async => openInBrowser(article.toRemoteUrl()),
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
