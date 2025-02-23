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
        title: Text('Список дел'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
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
                background: Container(
                    color: Colors.green,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
                ),
                  secondaryBackground: const ColoredBox(
                    color: Colors.redAccent,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                direction: DismissDirection.horizontal,
                onDismissed: (DismissDirection direction) {
                  // Удаление элемента из Firestore при смахивании
                  if(direction==DismissDirection.endToStart){
                    FirebaseFirestore.instance.collection('items').doc(itemDoc.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Удалено")));
                  }
                  if(direction==DismissDirection.startToEnd){
                    FirebaseFirestore.instance.collection('comp').add({'comp': itemDoc.get('item')});
                    FirebaseFirestore.instance.collection('items').doc(itemDoc.id).delete();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Завершено")));
                  }
                  },
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
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Удалено")));
                      },
                    ),
                  ),
                )
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return AlertDialog(
                title: Text('Добавить дело'),
                content: TextField(
                  decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                      hintText: 'Введите дело'
                  ),
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
