import 'package:flutter/material.dart';
import 'package:todo/model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FireStore obj = FireStore();
    TextEditingController text = TextEditingController();
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
                        obj.addTodo(text.text);
                        text.clear();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.check)),
                ],
                content: TextField(
                  controller: text,
                ),
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("TO DO")),
      ),
      body: Text("data"),
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
