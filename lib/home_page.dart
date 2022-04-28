// ignore_for_file: unnecessary_new, prefer_const_constructors

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

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
              decoration: const InputDecoration(hintText: 'Enter Weight'),
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
            ElevatedButton(onPressed: () async {}, child: const Text('Logout')),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("weights")
                  .orderBy('createdTime', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Text("There are no weights");
                }

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
                      tileColor: Colors.white38,
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () async {
                              final blinkit = await openDialog();
                              databaseservice
                                  .editWeight(blinkit!, docId)
                                  .update((value) async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Weight edited successfully'),
                                  ),
                                );
                              });
                            },
                            icon: const Icon(Icons.edit_off)),
                        IconButton(
                            onPressed: () {
                              databaseservice.deleteWeight(docId).then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Weight deleted successfully'),
                                  ),
                                );
                              });
                            },
                            icon: const Icon(Icons.delete))
                      ]));
                }).toList());
              },
            ))
          ]),
    );
  }

  Future<double?> openDialog() => showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Edit weight'),
            content: TextField(
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(hintText: 'Enter new weight')),
            actions: [TextButton(child: Text('SUBMIT'), onPressed: submit)],
          ));

  void deleteWeight(reference, String docId) {}

  void submit() {
    Navigator.of(context).pop(double.parse(controller.text));
  }
}

class Firestore {
  static var instance;
}
