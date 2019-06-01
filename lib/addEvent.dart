import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  DateTime eventTime = DateTime.now();
  TextEditingController eventNameController = new TextEditingController();
  String eventName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter event data"),
      ),
      body: Center(
        child: Column(children: <Widget>[
          TextField(
            controller: eventNameController,
            decoration: InputDecoration(
                //border: InputBorder.none,
                hintText: 'Event Name'),
          ),
          FlatButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true,
                    onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  print('confirm $date');
                  eventTime = date;
                  setState(() {});
                }, currentTime: DateTime.now());
              },
              child: Text(
                '$eventTime',
                style: TextStyle(color: Colors.blue),
              )),
          RaisedButton(
            onPressed: () {
              print(eventNameController.text + ' -> $eventTime');
              CollectionReference stoffEvents =
                  Firestore.instance.collection("StoffEvents");

              stoffEvents.add(
                  {'startTime': eventTime, 'event': eventNameController.text});
            },
            child: const Text('Add Event', style: TextStyle(fontSize: 20)),
          ),
          FlatButton(
            onPressed: () {},
            child: Text("Cancel"),
          ),
        ]),
      ),
    );
  }
}
