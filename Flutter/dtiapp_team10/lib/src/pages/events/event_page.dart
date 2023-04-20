import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtiapp_team10/src/pages/booking/booking_page.dart';
import 'package:dtiapp_team10/src/pages/connect_lights/connect_page.dart';
import 'package:dtiapp_team10/src/pages/events/event_details_page.dart';
import 'package:dtiapp_team10/src/pages/home_page.dart';
import 'package:dtiapp_team10/src/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {

  Widget _header(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
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
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
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
                      ))),
            ],
          )),
    );
  }

  Widget _eventInformation(BuildContext context) {
    List<String> eventTitle = [];
    List<String> eventShortDescription = [];
    List<String> eventImage = [];
    List<int> eventNum = [];

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('eventInfo').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            var docs = snapshot.data!.docs;
            int numOfEvents = docs.length;
            for (int i=0; i < numOfEvents; i++) {
              var event = docs[i].data()! as Map;
              eventTitle.add(event['eventTitle']);
              eventShortDescription.add(event['eventShortDescription']);
              eventImage.add(event['eventImage']);
              eventNum.add(event['eventNum']);
            }
            return Column(
              children: <Widget> [
                for (int i=0; i < numOfEvents; i++) _eventCard(context, eventTitle: eventTitle[i], eventDescription: eventShortDescription[i], imgPath: eventImage[i], eventPage: EventDetailsPage(eventNum: eventNum[i])),
              ],
            );
          }
          return Container();
        }
    );
  }

  Widget _eventCard(BuildContext context, {String eventTitle = "", String eventDescription = "", String imgPath = "", eventPage}) {
    return InkWell(
        onTap: () {Navigator.of(context).push(MaterialPageRoute(builder:(context) => eventPage));},
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0, 5),
                      blurRadius: 10,
                      color: Colors.purple.withAlpha(20)
                  )
                ]
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                    child: Stack(
                        children: <Widget>[
                          Positioned(
                              top: 10,
                              bottom: 10,
                              left: 10,
                              child: Container(
                                  width: 100,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(imgPath, fit: BoxFit.fitHeight,)
                                  )
                              )
                          ),
                          Positioned(
                              top: 10,
                              left: 125,
                              right: 10,
                              child: _eventInfo(context, eventTitle, eventDescription)
                          )
                        ]
                    )
                )
            )
        )
    );
  }

  Widget _eventInfo(BuildContext context, String eventTitle, String eventDescription) {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                      eventTitle,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  )
              ),
              Container(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                      eventDescription,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black
                      )
                  )
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: 3,
        items: [
          BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()))), label: "Home", ),
          BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.calendar_month), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DomeBookingPage()))), label: "Bookings"),
          BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.connected_tv), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectPage()))), label: "Connect"),
          BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.event_outlined), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventsPage()))), label: "Events"),
          BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.person), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage()))), label: "Profile")
        ]
      ),
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