import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(storage: Storage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.storage}) : super(key: key);

  final Storage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _login = '';
  late TextEditingController _controller;


  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('counter')?? 0;
    _login = await widget.storage.readLogin();
    setState(() {});
  }

  void _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter')?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Storage'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hello  $_login',
                style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 80),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Введите логин',
                  border: OutlineInputBorder(),
                ),

              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Введите в текстовое поле логин')),
                    );
                  } else {
                    setState(() {
                      widget.storage.writeToFile(_controller.text);
                      _login = _controller.text;
                      _controller.text = '';
                    });


                  }
                },
                child: const Text('Сохранить')
              ),
              const SizedBox(height: 150),
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
