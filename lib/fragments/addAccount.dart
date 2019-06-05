import 'package:flutter/material.dart';


class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Account'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              textColor: Colors.white,
              color: Colors.greenAccent,
              child: Text('Add'),
              onPressed: () {
               Navigator.pop(context);
              },
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.redAccent,
              child: Text('Cancel'),
              onPressed: () {
               Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}