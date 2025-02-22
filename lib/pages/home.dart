import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late String _userInput;
  List todoList = [];

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('ToDo'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: Text('Нет дел'));

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var itemDoc = snapshot.data!.docs[index];

              return Dismissible(
                key: Key(itemDoc.id),
                background: Container(color: Colors.red),
                child: Card(
                  child: ListTile(
                    title: Text(itemDoc.get('item')),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_sweep,
                        color: Colors.deepOrangeAccent,
                      ),
                      onPressed: () {
                        // Удаление элемента из Firestore
                        FirebaseFirestore.instance.collection('items').doc(itemDoc.id).delete();
                      },
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  // Удаление элемента из Firestore при смахивании
                  FirebaseFirestore.instance.collection('items').doc(itemDoc.id).delete();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item dismissed")));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text('Добавить дело'),
                content: TextField(
                  onChanged: (String value) {
                    _userInput = value;

                  },
                ),
                actions: [
                  ElevatedButton(onPressed: (){
                      FirebaseFirestore.instance.collection('items').add({'item': _userInput});

                      Navigator.of(context).pop();
                  }, child: Text('Добавить'))
                ],
              );
            });
      },
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}
