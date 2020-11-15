import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:wikipediasearchtask/Model/Model.dart';
import 'package:wikipediasearchtask/UI/SearchDetailspage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Wikipedia Search'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final TextEditingController _filter = new TextEditingController();
  List<Search> search = List<Search>();
  var _isLoadingtodaylead = false;
  String message;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                // onChanged: _searchPressed(),
                controller: _filter,
                decoration: InputDecoration(
                  labelText: "Search by Anything",
                  hintText: "Type Here",
                  prefixIcon: Icon(Icons.search),
                  /*border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))*/
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 4, bottom: 4),
              child: RaisedButton(
                color: Colors.white,
                textColor: Colors.black,
                padding: const EdgeInsets.all(15.0),
                child: Text("Search".toUpperCase()),
                onPressed: () {
                  if (_filter.text.toString() != "") {
                    viewtodaysLeadsapi(_filter.text.toString());
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please Enter Missing Fields",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        // backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            Expanded(
              child: _isLoadingtodaylead
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildList(),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Search>> viewtodaysLeadsapi(String text) async {
    setState(() {
      _isLoadingtodaylead = true;
    });
    var url =
        'https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=' +
            text;

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var responseJson = null;
    var response = await http.get(url, headers: headers);
    responseJson = json.decode(response.body);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      if (responseJson != null) {
        // message = responseJson['Message'];

        setState(() {
          _isLoadingtodaylead = false;
        });
        var data = json.decode(response.body);
        var clientList = data["query"]["search"] as List;
        search.clear();
        for (var model in clientList) {
          search.add(new Search.fromJson(model));
        }
      }
      responseJson.close();
      return search;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  _buildList() {
    if (search.length == 0) {
      return SizedBox.fromSize(
        size: Size(18.0, 18.0),
      );
    } else {
      if (search.length != 0) {
        return ListView.builder(
          itemCount: search == null ? 0 : search.length,
          itemBuilder: (BuildContext context, int index) {
            final searchdata = search[index];

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: new Row(
                children: <Widget>[
                  new Container(
                      width: 10.0, height: 130.0, color: Colors.white),
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 5),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text("Title:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ),
                                  Flexible(
                                    child: Text(searchdata.title,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12)),
                                  ),
                                ]),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    child: Text("Description:",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                  ),
                                  Flexible(
                                    child: new Html(data: searchdata.snippet),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchDetailPage(searchdata.pageid.toString())));

              },
            );
          },
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    }
  }
}
