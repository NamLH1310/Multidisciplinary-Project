import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/global.dart';

class CollectionRef {
  final String collectionName;
  final int limit;
  CollectionRef(this.collectionName, {this.limit = 10});

  Future<List<DataInput>> getData() async {
    try {
      final collectionRef = firestore.collection(collectionName);
      final docSnapshots = await collectionRef
          .limit(limit)
          .orderBy("createAt", descending: true)
          .get();
      final List<DataInput> data = [];
      for (int i = docSnapshots.docs.length - 1; i >= 0; i--) {
        data.add(DataInput(
            x: i.toDouble(),
            y: (docSnapshots.docs[i].data()["value"] as int).toDouble()));
      }
      return data;
    } on FirebaseException catch (error) {
      debugPrint("Firestore excetption: ${error.message}");
    } catch (error) {
      debugPrint("Helper.dart: $error");
    }
    return [];
  }
}

class DataInput {
  final double y;
  final double x;

  DataInput({this.y = 0, this.x = 0});
}
