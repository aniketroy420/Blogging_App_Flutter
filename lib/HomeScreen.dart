import 'dart:async';
//import 'dart:html' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'dart:html';
import 'package:blog_horha_h_kya/PostDetailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> snapshot;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Post');

  passData(DocumentSnapshot snap) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PostDetails(
              snapshot: snap,
            )));
  }

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        snapshot = datasnapshot.docs;
      });
    });
  }

  Color gradientStart = Colors.deepPurple[700];
  Color gradientEnd = Colors.purple[500];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              debugPrint('Search Button Pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              debugPrint('Add Button Pressed');
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Relax ka App'),
              accountEmail: Text('Blog horha hai bhai'),
            ),
            ListTile(
              title: Text('First Option'),
              leading: Icon(Icons.cake, color: Colors.purple),
            ),
            ListTile(
              title: Text('Second Option'),
              leading: Icon(Icons.search, color: Colors.redAccent),
            ),
            ListTile(
              title: Text('Third Option'),
              leading: Icon(Icons.cached, color: Colors.orange),
            ),
            ListTile(
              title: Text('Fourth Option'),
              leading: Icon(Icons.menu, color: Colors.green),
            ),
            Divider(height: 10.0, color: Colors.black),
            ListTile(
              title: Text('Close'),
              trailing: Icon(Icons.close),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: const FractionalOffset(0.5, 0.0),
          end: const FractionalOffset(0.0, 0.5),
          stops: [0.0, 1.0],
        )),
        child: ListView.builder(
          itemCount: snapshot.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0.0,
              color: Colors.transparent.withOpacity(0.1),
              margin: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      child: Text(snapshot[index].data["title"][0]),
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Container(
                      width: 210.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              //snapshot[index].data["title"],
                              snapshot[index].data(),
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            onTap: () {
                              passData(snapshot[index]);
                            },
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            snapshot[index].data["content"],
                            style: TextStyle(
                                fontSize: 14.0, color: Colors.white70),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
