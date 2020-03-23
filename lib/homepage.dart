import 'dart:async';

import 'package:coronatracker/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var statistics;
  var bottomSheetController;
  var listviewController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  var icon = Icons.search;
  Widget titleWidget = Text('Covid Situation');
  Color pastelBlue = Color(0xff193f66);
  String filter = '';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    statistics = fetchStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: titleWidget,
          actions: <Widget>[
            IconButton(
                icon: Icon(icon),
                onPressed: () {
                  changeAppBar();
                })
          ],
          backgroundColor: pastelBlue,
        ),
        body: listBody());
  }

  listBody() {
    return FutureBuilder(
        future: statistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: pastelBlue,
              ),
            );
          else
            return NotificationListener<ScrollUpdateNotification>(
              child: ListView.builder(
                  controller: listviewController,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => filter.isEmpty
                      ? ListTile(
                          title: Text(
                            snapshot.data[index].country,
                            style: TextStyle(fontSize: 18, color: pastelBlue),
                          ),
                          trailing: Text(
                            snapshot.data[index].confirmed,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, color: pastelBlue),
                          ),
                          onTap: () {
                            bottomSheetController =
                                bottomSheet(snapshot, index);
                          },
                        )
                      : snapshot.data[index].country
                              .toLowerCase()
                              .contains(filter.toLowerCase())
                          ? ListTile(
                              title: Text(
                                snapshot.data[index].country,
                                style:
                                    TextStyle(fontSize: 18, color: pastelBlue),
                              ),
                              trailing: Text(
                                snapshot.data[index].confirmed,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: pastelBlue),
                              ),
                              onTap: () {
                                bottomSheetController =
                                    bottomSheet(snapshot, index);
                              },
                            )
                          : Container()),
              onNotification: (update) {
                if (update.scrollDelta != 0 && bottomSheetController != null)
                  try {
                    bottomSheetController.close();
                  } catch (e) {}
                return true;
              },
            );
        });
  }

  bottomSheet(AsyncSnapshot snapshot, int index) {
    return scaffoldKey.currentState.showBottomSheet(
      (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: pastelBlue,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  snapshot.data[index].country,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  'Cases Confirmed',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              Text(
                '${snapshot.data[index].confirmed}',
                style: TextStyle(fontSize: 50, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  'Deaths',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              Text(
                '${snapshot.data[index].deaths}',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                  'Recovered',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              Text(
                '${snapshot.data[index].recovered}',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Last Updated on: ${snapshot.data[index].date}',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  changeAppBar() {
    if (icon == Icons.search) {
      setState(() {
        icon = Icons.close;
        titleWidget = TextField(
          controller: textEditingController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          onChanged: (text) {
            setState(() {
              filter = text;
            });
          },
        );
      });
    } else {
      setState(() {
        icon = Icons.search;
        titleWidget = Text('Covid Situation');
        setState(() {
          filter = '';
        });
        textEditingController.clear();
      });
    }
  }
}
