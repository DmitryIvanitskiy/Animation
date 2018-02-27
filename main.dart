import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  ScrollController _myScrollController = new ScrollController(); //More info https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/scroll_position.dart

  List<Widget> _itemList = new List.generate(100, (index) {
    return new Text("item number $index",);
  });

  _scrollTop() {
    _myScrollController.animateTo(
      _myScrollController.position.minScrollExtent, //initial offset, in our case 0.0
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _scrollBottom() {
    _myScrollController.animateTo(
      _myScrollController.position.maxScrollExtent, //Maximum offset
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(
      title: const Text('Use arrows to scroll'),
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.arrow_downward),
          onPressed: _scrollBottom,
          tooltip: 'scroll to end of list',
        ),
        new IconButton(
          icon: const Icon(Icons.arrow_upward),
          onPressed: _scrollTop,
          tooltip: 'scroll to start of list',
        ),
      ],
    ),
      body: new ListView(
        controller: _myScrollController,
        children:  _itemList,
      ),
    );
  }
}