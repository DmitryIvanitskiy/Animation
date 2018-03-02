import 'package:flutter/material.dart';
import 'dart:async';

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
  List<Widget> _truncatedList = new List();
  List<Widget> _tempList = new List();
  List<Widget> _itemList = new List.generate(100, (index) {
    return new Text("item number $index");
  });
  int counter =100;
  int success = 0;
  int fail = 0;
  double scrollTo;
  double offset;
  double scrollLineOffset;
  bool set = false;
  final TextEditingController _controller = new TextEditingController();
  List<Widget> list2 =  new List.generate(1, (index) {
  return new Text("item number $index",);
  });

  _scrollTop() {
    _myScrollController.animateTo(
      0.0, //initial offset, in our case 0.0
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _scrollBottom() {
    _myScrollController.animateTo(
      _myScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  _addItem(){
    counter ++;
    setState(() {
      _itemList.add(new Text('Offset:'+ _myScrollController.position.maxScrollExtent.toString() + ' , item' + counter.toString() ));
    });
  }

  waitScroll () {
    double offset = _myScrollController.position.maxScrollExtent;
    new Timer(new Duration(milliseconds: 100), (){
      if (offset == _myScrollController.position.maxScrollExtent){ //if ScrollController not updated
        fail++;
        print ('failed ' + fail.toString());
        _myScrollController.animateTo(
            _myScrollController.position.maxScrollExtent-.1, //trigger ScrollController update by almost invisible shift
            duration: const Duration(milliseconds: 10),
            curve: Curves.easeOut,
        );
        waitScroll(); //wait for changes
      } else {  //ScrollController finally updated
        success++;
        print('Successfull ' + success.toString());
        _scrollBottom();
        if (!set){
          scrollTo = _myScrollController.position.maxScrollExtent + _myScrollController.position.viewportDimension/2;
          set = true;
        }
      }
    });
  }

  _scrollToLine(scrollToLIne){
    int lineIndex = int.parse(scrollToLIne);
    _tempList = _itemList;
    _truncatedList =_itemList.sublist(0,lineIndex); //Render it to define offset and save it to 'tempOffset'

    setState(() {
      _itemList = _truncatedList;
    });

    _waitForRenderTruncatedList();
  }

   _waitForRenderTruncatedList(){
    double offset = _myScrollController.position.maxScrollExtent;
    new Timer(new Duration(milliseconds: 100), (){
                                        print('_waitForRender start, with offset ' + offset.toString());
      if (offset == _myScrollController.position.maxScrollExtent) { //if ScrollController not updated

        _myScrollController.animateTo(
          _myScrollController.position.maxScrollExtent - .1, //trigger ScrollController update by almost invisible shift
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
            print('_waitForRender update rendering with offset:' + offset.toString());
        _waitForRenderTruncatedList();

      } else {
        scrollLineOffset = _myScrollController.position.maxScrollExtent;
            print ('_waitForRender finished, tempOffset defined:' + scrollLineOffset.toString());
            print ('now rendering full list and scrolling it to tempOffset');
        setState(() {
          _itemList = _tempList;
        });
        _waitForRenderFullList();
      }
    });
  }

  _waitForRenderFullList(){
    double offset = _myScrollController.position.maxScrollExtent;

    new Timer(new Duration(milliseconds: 100), (){

      if (offset == _myScrollController.position.maxScrollExtent) { //if ScrollController not updated
        _myScrollController.animateTo(
          _myScrollController.position.maxScrollExtent - .1, //trigger ScrollController update by almost invisible shift
          duration: const Duration(milliseconds: 10),
          curve: Curves.easeOut,
        );
              print('update rendering in waitForRender2 with offset:' + offset.toString());
        _waitForRenderFullList();
      } else {
              print(' _waitForRender2 finished with offset:' + scrollLineOffset.toString());
        _myScrollController.animateTo(
          scrollLineOffset + _myScrollController.position.viewportDimension/2, //centering vertically
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(
      title: new TextField(
        controller: _controller,
        onSubmitted: _scrollToLine,
        decoration: new InputDecoration(
          hintText: 'Enter line № to scroll',
        ),
      ),
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
        new IconButton(
          icon: const Icon(Icons.plus_one),
          onPressed: () {
            _addItem();
            waitScroll();
            },
        tooltip: 'add item',
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
