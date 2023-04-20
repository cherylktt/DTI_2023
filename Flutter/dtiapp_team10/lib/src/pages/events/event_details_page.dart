import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'event_page.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage ({Key ? key, required this.eventNum}): super(key: key);
  final int eventNum;

  @override
  _EventDetailsPage createState() => _EventDetailsPage();
}

class _EventDetailsPage extends State<EventDetailsPage> {

  final db = FirebaseFirestore.instance;

  void updateRegistrationStatus(String event) {
    final regRef = db.collection("eventInfo").doc(event);
    regRef.update({"registered": true});
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: Container(
        height: 80,
        width: width,
        decoration: BoxDecoration(
          color: Color(0xff86cae3),
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 30,
                      child: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.black,
                          size: 40
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage())),
                      )
                    ),
                    Positioned(
                      top: 43,
                      left: 70,
                      child: Text(
                        "Events",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                      )
                    ),
                  ],
                )
              )
            ),
          ],
        )),
    );
  }

  Widget _eventInformation(BuildContext context) {
    String documentName = 'event${widget.eventNum}';
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('eventInfo').doc(documentName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          var events = snapshot.data!.data() as Map;
          String eventTitle = events['eventTitle'];
          String eventDescription = events['eventDescription'];
          String eventImage = events['eventImage'];
          String eventDate = events['eventDate'];
          String eventTime = events['eventTime'];
          bool registered = events['registered'];
          return _eventInfo(
            context,
            event: documentName,
            imgPath: eventImage,
            title: eventTitle,
            description: eventDescription,
            date: eventDate,
            time: eventTime,
            registered: registered
          );
        }
        return Container();
      }
    );
  }

  Widget _eventInfo(BuildContext context, {String event = "", String imgPath = "", String title = "", String description = "", String date = "", String time = "", bool registered = false}) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // alignment: AlignmentDirectional.center,
        children: <Widget> [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: Image.network(imgPath, fit: BoxFit.fitHeight)
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
              textAlign: TextAlign.left,
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
              textAlign: TextAlign.left
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(
              date,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
              textAlign: TextAlign.left
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              time,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16
              ),
              textAlign: TextAlign.left
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: registered ? Border.all(color: Colors.white) : Border.all(color: Color(0xff78b5cc)),
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: registered? Color(0xff78b5cc) : Colors.white
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(10.0),
                fixedSize: Size(380, 50)
              ),
              onPressed: registered ? null : () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text("Confirm Registration?"),
                  content: Text("$title\n\n$date\n$time"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        setState(() {
                          registered = false;
                          Navigator.pop(context, "No");
                        });
                      },
                      child: Text("No")
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          registered = true;
                          updateRegistrationStatus(event);
                          Navigator.pop(context, "Yes");
                        });
                      },
                      child: Text("Yes")
                    )
                  ]
                ),
              ),
              child: registered? Text("Registered", style: TextStyle(color: Colors.white, fontSize: 20)) : Text("Register", style: TextStyle(color: Color(0xff78b5cc), fontSize: 20))
            )
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              _header(context),
              _eventInformation(context)
            ]
          )
        )
      )
    );
  }
}