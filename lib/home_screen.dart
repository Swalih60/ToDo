import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FireStore obj = FireStore();
    TextEditingController text1 = TextEditingController();
    TextEditingController text2 = TextEditingController();

    void clr(String docId) {}

    void delete(String docID) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            SizedBox(
              width: 5,
            ),
            ElevatedButton(
              onPressed: () {
                obj.deleteTodo(docID);

                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
          content: const Text(
            "Is this task really done and dusted my G?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    void update(String docID, String todoText) {
      text1.text = todoText;
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                  IconButton(
                      onPressed: () {
                        obj.updateTodo(docID, text1.text);
                        text1.clear();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.check)),
                ],
                content: TextField(
                  controller: text1,
                ),
              ));
    }

    void dialog() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close)),
                  IconButton(
                      onPressed: () {
                        obj.addTodo(text2.text);
                        text2.clear();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.check)),
                ],
                content: TextField(
                  controller: text2,
                ),
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("TO DO")),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: obj.readTodo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List orderList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = orderList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String todoText = data['text'];
                return ListTile(
                  title: Text(todoText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            clr(docID);
                          },
                          icon: const Icon(Icons.star)),
                      IconButton(
                          onPressed: () {
                            update(docID, todoText);
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            delete(docID);
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Empty"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog();
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.grey),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
