import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/global.dart';

class CollectionRef {
  final String collectionName;
  int counter = 0;
  CollectionRef(this.collectionName);

  Future<List<DataInput>> getData({int limit = 20}) async {
    try {
      final collectionRef = firestore.collection(collectionName);
      final docSnapshots = await collectionRef
          .limit(limit)
          .orderBy("createAt", descending: true)
          .get();
      final List<DataInput> data = [];
      for (int i = docSnapshots.docs.length - 1; i >= 0; i--) {
        var Y = docSnapshots.docs[i].data()["value"];
        var X = docSnapshots.docs[i].data()["createAt"];
        if (X is Timestamp) {
          X = X.seconds.toDouble();
        }
        data.add(DataInput(
          x: X,
          y: (Y is String) ? double.parse(Y) : Y,
        ));
      }
      return data;
    } on FirebaseException catch (error) {
      debugPrint("Firestore excetption: ${error.message}");
    } catch (error) {
      debugPrint("Helper.dart: $error");
    }
    return [];
  }

  Future<DataInput> getLatestData() async {
    return (await getData(limit: 1))[0];
  }
}

class DataInput extends LinkedListEntry<DataInput> {
  final double y;
  final double x;

  DataInput({this.y = 0, this.x = 0});
}
