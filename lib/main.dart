import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(Stoff());

final dummySnapshot = [
  {"event": "Kaffee", "startTime": new DateTime.utc(2019, 6, 2)},
  {"event": "Tee", "startTime": new DateTime.utc(2019, 6, 3)},
  {"event": "Koks", "startTime": new DateTime.utc(2019, 6, 4)},
  {"event": "THC", "startTime": new DateTime.utc(2019, 6, 5)},
  {"event": "Morphium", "startTime": new DateTime.utc(2019, 6, 6)},
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

  Widget _buildBody(BuildContext context) {
    // TODO: get actual snapshot from Cloud Firestore
    return _buildList(context, dummySnapshot);
  }

  Widget _buildList(BuildContext context, List<Map> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Map data) {
    final record = Record.fromMap(data);

    return Padding(
      key: ValueKey(record.eventName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.eventName),
          trailing: Text(record.startTime.toString()),
          onTap: () => print(record),
        ),
      ),
    );
  }
}

class Record {
  final String eventName;
  final DateTime startTime;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['event'] != null),
        assert(map['startTime'] != null),
        eventName = map['event'],
        startTime = map['startTime'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$eventName:$startTime>";
}