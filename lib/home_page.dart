// ignore_for_file: unnecessary_new

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weight_tracker/services/database_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DatabaseService databaseservice = DatabaseService();

  late double weight;
  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> _collectionRef;
    var instance;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            children: [
              TextField(
                onChanged: (value) {
                  weight = double.parse(value);
                },
                decoration: InputDecoration(hintText: 'Enter Weight'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    databaseservice.addWeight(weight).then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Weight added successfully'),
                        ),
                      );
                    });
                  },
                  child: const Text('Submit data')),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("weights")
                        .orderBy('createdTime', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return new Text("There are no weights");

                      var docs = snapshot.data!.docs;

                      return ListView(
                          children: docs.map((doc) {
                        var docId = doc.id;
                        var data = doc.data() as dynamic;
                        var createdTime = data['createdTime'] as Timestamp;
                        var docWeight = (data['weight'] + 0.0) as double;

                        return ListTile(
                          leading: Text(createdTime.toDate().toString()),
                          title: Text(docWeight.toString() + ' kg'),
                        );
                      }).toList());
                    }),
              )
            ]));
  }
}

class Firestore {
  static var instance;
}
