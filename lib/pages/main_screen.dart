import 'package:flutter/material.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Список дел'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            iconAlignment: IconAlignment.end,
            icon: Icon(
              Icons.check,
              color: Colors.green,
              size: 30.0,
            ),
              onPressed: () {
                Navigator.pushNamed(context, '/complete');
              },
              label: Text('Перейти к завершенным делам')),

          ElevatedButton.icon(
              iconAlignment: IconAlignment.end,
              icon: Icon(
                Icons.circle_outlined,
                color: Colors.orange,
                size: 30.0,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/todo');
              },
              label: Text('Перейти к списку дел')),
        ],
      ),
    );
  }
}

