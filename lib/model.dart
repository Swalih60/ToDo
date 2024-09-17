import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  final CollectionReference todos =
      FirebaseFirestore.instance.collection("todos");

  Future<void> addTodo(String todo) {
    return todos.add({
      'text': todo,
      'time': Timestamp.now(),
      "clr": " ",
    });
  }

  Stream<QuerySnapshot> readTodo() {
    final order = todos.orderBy('time', descending: true).snapshots();
    return order;
  }

  Future<void> deleteTodo(String docId) {
    return todos.doc(docId).delete();
  }

  Future<void> updateTodo(String docId, String newTodo) {
    return todos.doc(docId).update({'text': newTodo, 'time': Timestamp.now()});
  }

  Future<void> updateClr(String docId, String clr) {
    return todos.doc(docId).update({
      'clr': clr,
    });
  }
}
