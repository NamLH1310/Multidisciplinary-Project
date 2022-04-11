import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CollectionRef {
  final String collectionName;
  final int limit;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionRef(this.collectionName, {this.limit = 10});

  Future<List<DataInput>> getData() async {
    try {
      final collectionRef = firestore.collection(collectionName);
      QuerySnapshot<Map<String, dynamic>> docSnapshots =
          await collectionRef.limit(limit).get();
      final List<DataInput> data = [];
      for (int i = 0; i < docSnapshots.docs.length; i++) {
        data.add(DataInput(
            x: i.toDouble(),
            y: double.parse(docSnapshots.docs[i].data()["value"])));
      }
      return data;
    } on FirebaseException catch (error) {
      debugPrint("Firestore excetption: ${error.message}");
    } catch (error) {
      debugPrint("$error");
    }
    return [];
  }
}

class DataInput {
  final double y;
  final double x;

  DataInput({this.y = 0, this.x = 0});
}
