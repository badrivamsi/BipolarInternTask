import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'Welcome to Image viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Center(child: Text('Bipolar intern project')),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: 400,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  elevation: 2.0,
                  color: Colors.grey,
                  child: TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.black,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Pets"),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text("Nature"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    apiCall(139386),
                    apiCall(1580860),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class apiCall extends StatefulWidget {
  final int pageID;
  const apiCall(this.pageID);
  @override
  _apiCallState createState() => _apiCallState();
}

// ignore: camel_case_types
class _apiCallState extends State<apiCall> {
  ScrollController _scrollController = ScrollController();
  List data = [];
  List<String> imgUrls = [];
  List<String> titles = [];
  bool showing = false;
  bool titleshowing = false;
  var pageNum = 1;

  @override
  void initState() {
    super.initState();
    getPetData(pageNum);
    _scrollController.addListener(() {
      //print(_scrollController.position.pixels);
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        pageNum = pageNum + 1;
        //print(pageNum);
        //getPetData(pageNum);
        loaderWidget(pageNum);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  loaderWidget(int pageNum) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    await getPetData(pageNum);
    Navigator.pop(context);
  }

  getPetData(int page) async {
    http.Response response = await http.get(
        "https://api.unsplash.com/collections/${widget.pageID}/photos?client_id=l0O-BB_CHrCS67IZLLWmEPsJf9g1KV_udrgvFb75HXo&page=$page");
    data = json.decode(response.body);
    for (var i = 0; i < data.length; i++) {
      imgUrls.add(data.elementAt(i)["urls"]["small"]);
      titles.add(data.elementAt(i)["description"]);
    }
    for (var i = 0; i < titles.length; i++) {
      if (titles.elementAt(i) == null) {
        titles[i] = "Not Specified";
      } else if (titles.elementAt(i).length > 60) {
        titles[i] = "Title is too long";
      }
    }
    setState(() {
      showing = true;
      titleshowing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: imgUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: !showing
                      ? CircularProgressIndicator(
                          strokeWidth: 0.0,
                        )
                      : Image(
                          image: NetworkImage(
                            imgUrls.elementAt(index),
                          ),
                        ),
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: !titleshowing
                        ? CircularProgressIndicator(
                            strokeWidth: 0.0,
                          )
                        : Text(titles.elementAt(index))),
              ],
            ),
          ),
        );
      },
    );
  }
}
/*
// ignore: camel_case_types
class secondApiCall extends StatefulWidget {
  @override
  _secondApiCallState createState() => _secondApiCallState();
}

// ignore: camel_case_types
class _secondApiCallState extends State<secondApiCall> {
  List naturedata = [];
  List<String> natureimgUrls = [];
  List<String> natureTitles = [];
  bool natureshowing = false;
  bool naturetitleshowing = false;
  getNatureData() async {
    http.Response response = await http.get(
        "https://api.unsplash.com/collections/1580860/photos?client_id=l0O-BB_CHrCS67IZLLWmEPsJf9g1KV_udrgvFb75HXo");
    naturedata = json.decode(response.body);
    for (var i = 0; i < naturedata.length; i++) {
      natureimgUrls.add(naturedata.elementAt(i)["urls"]["regular"]);
      natureTitles.add(naturedata.elementAt(i)["description"]);
    }
    for (var i = 0; i < natureTitles.length; i++) {
      if (natureTitles.elementAt(i) == null) {
        natureTitles[i] = "Not Specified";
      }
    }
    setState(() {
      natureshowing = true;
      naturetitleshowing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    getNatureData();

    return GridView.builder(
      itemCount: naturedata.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 5.0),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: !natureshowing
                      ? CircularProgressIndicator(
                          strokeWidth: 0.0,
                        )
                      : Image(
                          image: NetworkImage(
                            natureimgUrls.elementAt(index),
                          ),
                        ),
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: !naturetitleshowing
                        ? CircularProgressIndicator(
                            strokeWidth: 0.0,
                          )
                        : Text(natureTitles.elementAt(index))),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/
