import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FireStore obj = FireStore();
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();

  final Map<String, Color> colorOptions = {
    'None': Colors.transparent,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Red': Colors.red,
  };

  final Map<String, Color> iconColors = {
    'None': Colors.transparent,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Red': Colors.red,
  };

  void updateColor(String docID, String selectedColor) {
    obj.updateClr(docID, selectedColor);
  }

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
          const SizedBox(
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
                    icon: const Icon(Icons.close)),
                IconButton(
                    onPressed: () {
                      obj.addTodo(text2.text);
                      text2.clear();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check)),
              ],
              content: TextField(
                controller: text2,
              ),
            ));
  }

  void showColorDialog(String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: iconColors.entries.map((entry) {
            return GestureDetector(
              onTap: () {
                updateColor(docID, entry.key);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: entry.value,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.black, width: 1),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("TO DO")),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: obj.readTodo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> orderList = snapshot.data!.docs;

            return ReorderableListView.builder(
              itemCount: orderList.length,
              onReorder: (int oldIndex, int newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                setState(() {
                  final item = orderList.removeAt(oldIndex);
                  orderList.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                DocumentSnapshot document = orderList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String todoText = data['text'];
                String selectedColor = data['clr'] ?? 'None';
                bool isCompleted = data['completed'] ?? false;

                bool isColoredTile = selectedColor != 'None';

                return Container(
                  key: ValueKey(docID),
                  child: Column(
                    children: [
                      ListTile(
                        tileColor:
                            colorOptions[selectedColor] ?? Colors.transparent,
                        leading: Checkbox(
                          value: isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              obj.updateCompletion(docID, value!);
                            });
                          },
                        ),
                        title: Text(
                          todoText,
                          style: TextStyle(
                            color: isColoredTile ? Colors.black : null,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showColorDialog(docID);
                              },
                              icon: Icon(Icons.star,
                                  color: isColoredTile ? Colors.black : null),
                            ),
                            IconButton(
                              onPressed: () {
                                update(docID, todoText);
                              },
                              icon: Icon(Icons.edit,
                                  color: isColoredTile ? Colors.black : null),
                            ),
                            IconButton(
                              onPressed: () {
                                delete(docID);
                              },
                              icon: Icon(Icons.delete,
                                  color: isColoredTile ? Colors.black : null),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 3,
                        color: Colors.black,
                      ),
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
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }
}
