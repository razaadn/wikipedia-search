import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SearchDetailPage extends StatefulWidget {
  String pageid;

  SearchDetailPage(this.pageid);

  SearchDetailPageState createState() => SearchDetailPageState(pageid);
}

class SearchDetailPageState extends State<SearchDetailPage> {
  String pageid;

  String title = "";
  String Description = "";

  var _isLoadingtodaylead = false;

  SearchDetailPageState(this.pageid);

  @override
  void initState() {
    // TODO: implement initState

    viewtodaysLeadsapi(pageid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Detail page", style: TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: _isLoadingtodaylead ? Center(
          child: CircularProgressIndicator(),
        ) : new ListView(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    // URLLauncher().launchURL(record.url);
                  },
                  child: new Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new Row(
                      children: [
                        // First child in the Row for the name and the
                        new Expanded(
                          // Name and Address are in the same column
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Code to create the view for name.

                              Container(
                                width: 60,
                                child: Text("Title:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                              SizedBox.fromSize(
                                size: Size(0.0, 5.0),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(title,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),
                              SizedBox.fromSize(
                                size: Size(0.0, 5.0),
                              ),
                              Container(
                                child: Text("Description:",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                              SizedBox.fromSize(
                                size: Size(0.0, 5.0),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(Description,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12)),
                              ),



                            ],
                          ),
                        ),
                        // Icon to indicate the phone number.
                        /*new Icon(
                          Icons.phone,
                          color: Colors.red[500],
                        ),
                        new Text(' ${record.contact}'),*/
                      ],
                    ),
                  )
              ),
            ]
        ));
  }

  viewtodaysLeadsapi(String pageid) async {
    setState(() {
      _isLoadingtodaylead = true;
    });
    var url =
        'https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&pageids=' +
            pageid;

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
        String heading = data["query"]["pages"][pageid]["title"];
        String content = data["query"]["pages"][pageid]["extract"];
        setState(() {

          title = heading;
          Description = content;

        });

      }

    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

}
