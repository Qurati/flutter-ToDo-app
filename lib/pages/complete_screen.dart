import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Complete extends StatelessWidget {
  const Complete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Завершенные дела'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('comp').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: Text('Нет завершенных дел'));
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var itemDoc = snapshot.data!.docs[index];

              return Dismissible(
                  key: Key(itemDoc.id),
                  background: Container(
                    color: Colors.redAccent,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.delete, color: Colors.white, size: 30.0,),
                      ),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (DismissDirection direction) {
                    // Удаление элемента из Firestore при смахивании
                      FirebaseFirestore.instance.collection('comp').doc(itemDoc.id).delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Удалено")));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(itemDoc.get('comp')),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )
              );
            },
          );
        },
      ),
      );
  }
}

