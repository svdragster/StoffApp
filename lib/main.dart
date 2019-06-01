import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(Stoff());

final dummySnapshot = [
  {"event": "Kaffee", "timeToStart": 15},
  {"event": "Tee", "timeToStart": 14},
  {"event": "Koks", "timeToStart": 11},
  {"event": "THC", "timeToStart": 10},
  {"event": "Morphium", "timeToStart": 1},
];

class Stoff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stoff',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoffPage(title: 'Stoff'),
    );
  }
}

class StoffPage extends StatefulWidget {
  StoffPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _StoffPageState createState() => _StoffPageState();
}

class _StoffPageState extends State<StoffPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(context),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'We will meet in ',
          ),
          Text(
            ' minutes',
          ),
        ],
      ),
    );
  }
}
