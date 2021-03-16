import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:intl/intl.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading and Writing Files',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:FlutterDemo(storage: CounterStorage()),
    );
  }
}

class FlutterDemo extends StatefulWidget {
  final CounterStorage storage;

  FlutterDemo({Key key, @required this.storage}) : super(key: key);

  @override
  _FlutterDemoState createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  var tagEvent = {
    'poo': {'ts': '', 'counter': 0},
    'pee': {'ts': '', 'counter': 0},
    'asleep': {'ts': '', 'counter': 0},
    'envNoise': {'ts': '', 'counter': 0},
    'breathNoise': {'ts': '', 'counter': 0}
  };
  String _tag = '';

  // @override
  // void initState() {
  //   super.initState();
  //   widget.storage.readCounter().then((int value) {
  //     setState(() {
  //       _counter = value;
  //     });
  //   });
  // }

  Future<File> _tagging(String typ) {
    setState((){
      tagEvent[typ]['ts'] = DateFormat('yyyy-M-d HH:mm:ss').format(DateTime.now());
      int cnt = tagEvent[typ]['counter'];
      cnt ++;
      tagEvent[typ]['counter'] = cnt;
      _tag = '$typ,${tagEvent[typ]['counter']},${tagEvent[typ]['ts']}';
    });
    // Write the variable as a string to the file.
    return widget.storage.writeTag(_tag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading and Writing Files')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tag Event...',
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => _tagging("poo"),
                    child: Text(
                      'poo',
                    )),
                Text(
                  '${tagEvent['poo']['counter']},${tagEvent['poo']['ts']}',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _tagging('pee'),
                  child: Text('pee'),
                  style: TextButton.styleFrom(primary: Colors.white),
                ),
                Text(
                  '${tagEvent['pee']['counter']},${tagEvent['pee']['ts']}',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _tagging('asleep'),
                  child: Text('Asleep'),
                  style: TextButton.styleFrom(primary: Colors.white),
                ),
                Text(
                  '${tagEvent['asleep']['counter']},${tagEvent['asleep']['ts']}',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _tagging('envNoise'),
                  child: Text('envNoise'),
                  style: TextButton.styleFrom(primary: Colors.white),
                ),
                Text(
                  '${tagEvent['envNoise']['counter']},${tagEvent['envNoise']['ts']}',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _tagging('breathNoise'),
                  child: Text('breathNoise'),
                  style: TextButton.styleFrom(primary: Colors.white),
                ),
                Text(
                  '${tagEvent['breathNoise']['counter']},${tagEvent['breathNoise']['ts']}',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    final directory = await getExternalStorageDirectory();
    // print('get _localPath $directory.path');

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // print('get _localFile $path/counter.txt');
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      // print('readCounter() $contents');
      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeTag(String tag) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$tag\n',mode:FileMode.append);
  }
}