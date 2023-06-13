import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _dataText = '';
  List<Todo> _todos = [];

  final dio = Dio();

  _fetchTodos() async {
    final response =
        await Dio().get("https://jsonplaceholder.typicode.com/todos");

    final processedData = response.data as List<dynamic>;

    List<Todo> todos = processedData
        .map((json) => Todo(
              id: json['id'],
              userId: json['userId'],
              title: json['title'],
              completed: json['completed'],
            ))
        .toList();

    setState(() {
      _todos = todos;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _todos.isEmpty
            ? TextButton(
                onPressed: _fetchTodos,
                child: const Text(
                  'Fetch Data',
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _todos[index].title,
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Todo {
  final int id;
  final int userId;
  final String title;
  final bool completed;

  Todo({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });
}
