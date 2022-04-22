import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference allWeights =
      FirebaseFirestore.instance.collection('weights');
  late double weight;
  @override
  Widget build(BuildContext context) {
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
                await allWeights.add({
                  'weight': weight,
                  'createdTime': FieldValue.serverTimestamp()
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weight added successfully'),
                    ),
                  );
                });
              },
              child: const Text('Submit data'))
        ],
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
