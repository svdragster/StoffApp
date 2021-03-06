import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stoff/AddEvent.dart';

void main() => runApp(Stoff());

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddEventPage()));
        },
        child: Icon(Icons.add_box),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('StoffEvents')
          .orderBy('startTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(0xFF, 0x33, 0x33, 0xFF)),
          );
        }

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.eventName),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Dismissible(
          key: Key(record.eventName),
          onDismissed: (direction) {
             _transactionalDelete(record);
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("${record.eventName} dismissed")));
          },
          child: ListTile(
              title: Text(record.eventName),
              trailing: Text(record.startTime.toString()),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildAboutDialog(context, record),
                );
              }),
        ),
      ),
    );
  }

  void _addTime(Record record, int timeToAdd) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      final freshSnapshot = await transaction.get(record.reference);
      final fresh = Record.fromSnapshot(freshSnapshot);

      await transaction.update(record.reference,
          {'startTime': fresh.startTime.add(Duration(minutes: 5))});
    });

    Navigator.of(context).pop();
  }

  Future _transactionalDelete(Record record) async {
    Firestore.instance.runTransaction((transaction) async {
      await transaction.delete(record.reference);
    });

    print("$record deleted");
  }

  Widget _buildAboutDialog(BuildContext context, Record record) {
    return new AlertDialog(
      title: Text(record.eventName),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FlatButton(
              onPressed: () => _addTime(record, 5),
              child: Text(
                '+5 minutes',
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildAboutText() {
    return new RichText(
      text: new TextSpan(
        text:
            'Android Popup Menu displays the menu below the anchor text if space is available otherwise above the anchor text. It disappears if you click outside the popup menu.\n\n',
        style: const TextStyle(color: Colors.black87),
        children: <TextSpan>[
          const TextSpan(text: 'The app was developed with '),
          new TextSpan(
            text: 'Flutter',
          ),
          const TextSpan(
            text: ' and it\'s open source; check out the source '
                'code yourself from ',
          ),
          new TextSpan(
            text: 'www.codesnippettalk.com',
          ),
          const TextSpan(text: '.'),
        ],
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
        startTime = map['startTime'] is Timestamp
            ? map['startTime'].toDate()
            : map['startTime'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$eventName:$startTime>";
}
