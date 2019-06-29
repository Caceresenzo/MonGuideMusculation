import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mon_guide_musculation/logic/managers/base_manager.dart';
import 'package:mon_guide_musculation/models/sportprogram.dart';
import 'package:mon_guide_musculation/ui/pages/page_bodybuilding.dart';
import 'package:mon_guide_musculation/ui/states/common_refreshable_state.dart';
import 'package:mon_guide_musculation/ui/widgets/common_divider.dart';
import 'package:mon_guide_musculation/utils/constants.dart';
import 'package:date_format/date_format.dart';

class SportProgramWidget extends StatelessWidget {
  final SportProgram sportProgram;

  const SportProgramWidget(
    this.sportProgram, {
    Key key,
  })  : assert(sportProgram != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return ListTile(
      title: Text("Programme sans nom"),
      subtitle: Text("Contient " + Texts.exerciseCount(sportProgram.items.length) + "\n" + "Fait le " + formatDate(DateTime.parse(sportProgram.createdDate), [dd, '/', mm, '/', yyyy, ' à ', HH, ':', nn, ':', ss]) + "\n" + "Pour " + sportProgram.target),
      isThreeLine: true,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SportProgramScreen(
                    sportProgram: sportProgram,
                  ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramItemWidget extends StatelessWidget {
  final SportProgramItem item;

  const SportProgramItemWidget(
    this.item, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      size: 28.0,
      color: Constants.colorAccent,
    );
  }

  Widget _buildObjectiveWidget(String name, int value, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 16.0,
      ),
      child: Column(
        children: <Widget>[
          //_buildIcon(icon),
          Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0),
          ),
          Text(
            /*value.toString() + "\n" + */ name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      item.exercise.title,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 8.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SportProgramEvolutionScreen(item.parent),
                            ),
                          );
                        },
                        child: _buildIcon(Icons.show_chart),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      GestureDetector(
                        child: _buildIcon(Icons.info),
                        onTap: () {
                          BodyBuildingExerciseReadingScreen.open(context, item.exercise);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            CommonDivider(),
            SizedBox(
              height: 4.0,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildObjectiveWidget(" séries", item.series, Icons.repeat),
                  Text(
                    "de",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  _buildObjectiveWidget(" répétitions", item.repetitions, Icons.format_list_numbered),
                  Text(
                    "à",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.0),
                  ),
                  _buildObjectiveWidget(" kg", item.weight, Icons.line_weight),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }
}

class SimpleSportProgramItemWidget extends StatelessWidget {
  final SportProgramItem item;

  const SimpleSportProgramItemWidget(
    this.item, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return ListTile(
      title: Text(item.exercise.title),
      subtitle: Text("${item.series} ser. de ${item.repetitions} rep. à ${item.weight} kg"),
      trailing: GestureDetector(
        child: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Constants.colorAccent,
        ),
        onTap: () => BodyBuildingExerciseReadingScreen.open(context, item.exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramEvolutionGraphWidget extends StatelessWidget {
  final SportProgram item;
  final SportProgramEvolutionType evolutionType;

  const SportProgramEvolutionGraphWidget(
    this.item,
    this.evolutionType, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return Card(
      child: Text(evolutionType.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramItemEvolutionGraphWidget extends StatelessWidget {
  final SportProgramItem item;
  final SportProgramEvolutionType evolutionType;

  const SportProgramItemEvolutionGraphWidget(
    this.item,
    this.evolutionType, {
    Key key,
  })  : assert(item != null),
        super(key: key);

  Widget _buildTile(BuildContext context) {
    return Card(
      child: Text(evolutionType.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTile(context);
  }
}

class SportProgramScreen extends StatefulWidget {
  final SportProgram sportProgram;

  SportProgramScreen({
    this.sportProgram,
  });

  @override
  State<SportProgramScreen> createState() {
    if (sportProgram != null) {
      return _SportProgramScreenItemsListingState(sportProgram);
    }

    return _SportProgramScreenSavedItemsListingState();
  }
}

class SportProgramImportScreen extends StatefulWidget {
  final String token;

  SportProgramImportScreen(
    this.token,
  ) : assert(token != null);

  @override
  State<SportProgramImportScreen> createState() {
    return _SportProgramImportScreenItemsListingState(token);
  }
}

class SportProgramEvolutionScreen extends StatefulWidget {
  final SportProgram sportProgram;
  final SportProgramEvolutionType evolutionType;

  SportProgramEvolutionScreen(
    this.sportProgram, {
    this.evolutionType,
  });

  @override
  State<SportProgramEvolutionScreen> createState() {
    if (evolutionType != null) {
      return _SportProgramEvolutionScreenTypeState(sportProgram, evolutionType);
    }

    return _SportProgramEvolutionScreenState(sportProgram);
  }
}

class _SportProgramScreenItemsListingState extends State<SportProgramScreen> {
  final SportProgram sportProgram;

  _SportProgramScreenItemsListingState(
    this.sportProgram,
  ) : assert(sportProgram != null);

  Widget _buildHeaderIcon(BuildContext context, IconData icon, String subtitle, void onTap()) {
    return InkWell(
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 3.8,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 8.0,
            ),
            child: Column(
              children: <Widget>[
                Icon(
                  icon,
                  size: 40,
                  color: Constants.colorAccent,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildHeaderIcon(context, Icons.show_chart, "évolution".toUpperCase(), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SportProgramEvolutionScreen(sportProgram),
                ),
              );
            }),
            _buildHeaderIcon(context, Icons.play_circle_outline, "démarrer".toUpperCase(), () {}),
            _buildHeaderIcon(context, Icons.edit, "éditer".toUpperCase(), () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return SizedBox(
      child: SportProgramItemWidget(sportProgram.items[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(sportProgram.name),
        backgroundColor: Constants.colorAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildHeaderCard(context),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: sportProgram.items.length,
            itemBuilder: (context, index) => _buildItem(context, index),
          )
        ],
      ),
    );
  }
}

class _SportProgramScreenSavedItemsListingState extends CommonRefreshableState<SportProgramScreen, SportProgram> {
  @override
  Future<void> getFuture() {
    return Managers.sportProgramManager.retriveSaved();
  }

  @override
  List<SportProgram> getNewItemListState() {
    return Managers.sportProgramManager.savedPrograms;
  }

  @override
  Widget buildItem(BuildContext context, List<SportProgram> items, int index) {
    return SizedBox(
      child: SportProgramWidget(items[index]),
    );
  }
}

class _SportProgramImportScreenItemsListingState extends CommonRefreshableState<SportProgramImportScreen, SportProgramItem> {
  final String token;

  _SportProgramImportScreenItemsListingState(
    this.token,
  );

  @override
  Future<void> getFuture() {
    return Managers.sportProgramManager.fetchByToken(token);
  }

  @override
  List<SportProgramItem> getNewItemListState() {
    return Managers.sportProgramManager.cachedProgram.items;
  }

  @override
  Color getBackgroundColor(BuildContext context) => Colors.white;

  @override
  List<Widget> itemsBefore(BuildContext context) {
    SportProgram sportProgram = items.isNotEmpty ? items[0].parent : null;

    if (sportProgram == null) {
      return null;
    }

    return <Widget>[
      Container(
        width: double.infinity,
        child: Center(
          child: Text(
            sportProgram.target,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      CommonDivider(),
    ];
  }

  @override
  Widget buildItem(BuildContext context, List<SportProgramItem> items, int index) {
    return SizedBox(
      child: SimpleSportProgramItemWidget(items[index]),
    );
  }
}

class _SportProgramEvolutionScreenState extends State<SportProgramEvolutionScreen> {
  final SportProgram sportProgram;

  _SportProgramEvolutionScreenState(
    this.sportProgram,
  ) : assert(sportProgram != null);

  @protected
  Widget buildGraph(BuildContext context, SportProgramEvolutionType evolutionType) {
    return SizedBox(
      child: Text(evolutionType.toString()),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return SizedBox(
      child: SportProgramEvolutionGraphWidget(sportProgram, SportProgramEvolutionType.values[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(Texts.evolutionScreenTitlePrefix + sportProgram.name),
        backgroundColor: Constants.colorAccent,
      ),
      body: ListView(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: SportProgramEvolutionType.values.length,
            itemBuilder: (context, index) => _buildItem(context, index),
          )
        ],
      ),
    );
  }
}

class _SportProgramEvolutionScreenTypeState extends _SportProgramEvolutionScreenState {
  final SportProgramEvolutionType evolutionType;

  _SportProgramEvolutionScreenTypeState(
    SportProgram sportProgram,
    this.evolutionType,
  )   : assert(evolutionType != null),
        super(sportProgram);
}
