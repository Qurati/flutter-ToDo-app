import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late String _userInput;
  List todoList = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('ToDo'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (BuildContext context, int index){
            return Dismissible(
                key: Key(todoList[index]),
                child: Card(
                  child: ListTile(title: Text(todoList[index]),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_sweep,
                      color: Colors.deepOrangeAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        todoList.removeAt(index);
                      });
                    },
                  ),
                  ),
                ),
              onDismissed: (direction){
                  if(direction == DismissDirection.endToStart){
                    setState(() {
                      todoList.removeAt(index);
                    });
                  }
              },
            );
          }
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
                    setState(() {
                      todoList.add(_userInput);
                      Navigator.of(context).pop();
                    });
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
