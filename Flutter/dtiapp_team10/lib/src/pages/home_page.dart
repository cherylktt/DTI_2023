import 'package:dtiapp_team10/src/pages/events/event_details_page.dart';
import 'package:dtiapp_team10/src/pages/events/event_filter_page.dart';
import 'package:dtiapp_team10/src/pages/profile/scanned_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'booking/booking_page.dart';
import 'connect_lights/connect_page.dart';
import 'events/event_page.dart';
import 'profile/profile_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  DateTime currentDateTime = DateTime.now();
  static String scanQRDetails = "Unknown";

  @override
  void initState() {
    super.initState();
  }

  _GoToNextPage(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ScannedProfilePage(profileName: scanQRDetails);
    }));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);

    setState(() {
      scanQRDetails = barcodeScanRes;
      _GoToNextPage(context);
    });

    // scanQRDetails = barcodeScanRes;
    // setState(() => scannedProfilePage(profileName: scanQRDetails));
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: Container(
        height: 120,
        width: width,
        decoration: BoxDecoration(
          color: Color(0xff86cae3),
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 50,
              left: 0,
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Explore",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.w500),
                        )
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.qr_code_scanner,
                          color: Colors.black,
                          size: 40,
                        ),
                        onPressed: () => scanQR(),
                      )
                    ),
                  ],
                )
              )
            ),
          ],
        )
      ),
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _categoryRow(BuildContext context, String title, Color primary, Color textColor, String chipText, page) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 33,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          _chip(context, chipText, primary, page)
        ],
      ),
    );
  }

  Widget _eventsRow(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: 20),
          _eventchip(context, "Seminars", Color(0xff78b5cc), Colors.white, height: 6),
          SizedBox(width: 10),
          _eventchip(context, "Workshops", Color(0xff78b5cc), Colors.white, height: 6),
          SizedBox(width: 10),
          _eventchip(context, "Networking", Color(0xff78b5cc), Colors.white, height: 6),
        ],
      )
    );
  }

  Widget _featuredRowA(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('eventInfo').doc('event0').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var events = snapshot.data!.data() as Map;
                  String eventTitle = events['eventTitle'];
                  String eventImage = events['eventImage'];
                  return _card(context, Colors.white, eventTitle, 0, _decorationContainer(Colors.white, 50, -30), eventImage);
                } return Container();
              }
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('eventInfo').doc('event1').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var events = snapshot.data!.data() as Map;
                  String eventTitle = events['eventTitle'];
                  String eventImage = events['eventImage'];
                  return _card(context, Colors.white, eventTitle, 1, _decorationContainer(Colors.white, 50, -30), eventImage);
                } return Container();
              }
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('eventInfo').doc('event2').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var events = snapshot.data!.data() as Map;
                  String eventTitle = events['eventTitle'];
                  String eventImage = events['eventImage'];
                  return _card(context, Colors.white, eventTitle, 2, _decorationContainer(Colors.white, 50, -30), eventImage);
                } return Container();
              }
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('eventInfo').doc('event3').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var events = snapshot.data!.data() as Map;
                  String eventTitle = events['eventTitle'];
                  String eventImage = events['eventImage'];
                  return _card(context, Colors.white, eventTitle, 3, _decorationContainer(Colors.white, 50, -30), eventImage);
                } return Container();
              }
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('eventInfo').doc('event4').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasData) {
                  var events = snapshot.data!.data() as Map;
                  String eventTitle = events['eventTitle'];
                  String eventImage = events['eventImage'];
                  return _card(context, Colors.white, eventTitle, 4, _decorationContainer(Colors.white, 50, -30), eventImage);
                } return Container();
              }
            ),
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('eventInfo').doc('event5').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    var events = snapshot.data!.data() as Map;
                    String eventTitle = events['eventTitle'];
                    String eventImage = events['eventImage'];
                    return _card(context, Colors.white, eventTitle, 5, _decorationContainer(Colors.white, 50, -30), eventImage);
                  } return Container();
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, Color primary, String title, int eventNum, Widget backWidget, String imgPath) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 185,
      width: width * .65,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: primary.withAlpha(200),
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
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsPage(eventNum: eventNum))),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 68,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(imgPath)
                )
              ),
              Positioned(
                top: 123,
                left: 9,
                right: 9,
                child: _cardInfo(context, title, Colors.black),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _cardInfo(BuildContext context, String title, Color textColor, {bool isPrimaryCard = false}) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: MediaQuery.of(context).size.width * .65,
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isPrimaryCard ? Colors.black : textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String text, Color textColor, page) {
    return InkWell(
      onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));},
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xffb6dfee),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 17
          ),
        ),
      )
    );
  }

  Widget _eventchip(BuildContext context, String text, Color textColor, Color chipColor,
      {double height = 0, bool isPrimaryCard = false}) {
    return Container(
      child: TextButton(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => EventsFilterPage(eventTag: text))),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: textColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(7)),
        color: chipColor,
      ),
    );
  }

  Widget _decorationContainer(Color primary, double top, double left) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 20,
          right: -30,
          child: _circularContainer(80, Colors.transparent,
              borderColor: Colors.white),
        )
      ],
    );
  }

  Widget _domeRow(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _getDomeData(context, 1),
            _getDomeData(context, 2)
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _getDomeData(context, 3),
            _getDomeData(context, 4)
          ]
        ),
      ]
    );
  }
  
  Widget _getDomeData(BuildContext context, int domeNum) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('domeAvailability').where("domeID", isEqualTo: domeNum).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          var docs = snapshot.data!.docs;
          int numOfBookings = docs.length;
          for (int i = 0; i < numOfBookings; i++) {
            var booking = docs[i].data()! as Map;
            DateTime bookingStart = (booking['bookingStart'] as Timestamp).toDate();
            DateTime bookingEnd = (booking['bookingEnd'] as Timestamp).toDate();
            if (currentDateTime.isAfter(bookingStart)) {
              if (currentDateTime.isBefore(bookingEnd)) {
                return _domeCard(
                  context,
                  domeColor: Color(0xfffa897b),
                  domeNumber: "Dome ${domeNum}",
                  domeAvailability: "Unavailable from\n${DateFormat("HH:mm").format(bookingStart)} - ${DateFormat("HH:mm").format(bookingEnd)}"
                );
              }
            } else if (currentDateTime.isAfter(bookingStart)) {
              return _domeCard(
                context,
                domeColor: Color(0xffD0E6A5),
                domeNumber: "Dome ${domeNum}",
                domeAvailability: "Available Now"
              );
            }
          }
        } return _domeCard(
          context,
          domeColor: Color(0xffD0E6A5),
          domeNumber: "Dome ${domeNum}",
          domeAvailability: "Available Now"
        );
      }
    );
  }

  Widget _domeCard(BuildContext context,
    {Color domeColor = Colors.green,
      String domeNumber = "",
      String domeAvailability = "Available Now"}) {

    return Container(
      height: 90,
      width: 160,
      margin: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 0),
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
                child: Container(
                  height: 90,
                  width: 30,
                  color: domeColor
                )
              ),
              Positioned(
                top: 8,
                left: 40,
                child: _domeInfo(context, domeNumber, domeAvailability)
              )
            ]
          )
        )
      )
    );
  }

  Widget _domeInfo(BuildContext context, String domeNumber, String domeAvailability) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            alignment: Alignment.topLeft,
            child: Text(
              domeNumber,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              )
            )
          ),
          Container(
            padding: EdgeInsets.only(right: 10, top: 8),
            alignment: Alignment.topLeft,
            child: Text(
              domeAvailability,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black
              )
            )
          ),
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
        currentIndex: 0,
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
              SizedBox(height: 15),
              _categoryRow(context, "Upcoming Events", Colors.black, Colors.black, "See All", EventsPage()),
              SizedBox(height: 10),
              _eventsRow(context),
              _featuredRowA(context),
              // SizedBox(height: 5),
              _categoryRow(context, "Dome Availability", Colors.black, Colors.black, "Book Now", DomeBookingPage()),
              _domeRow(context),
            ],
          ),
        ),
      ),
    );
  }
}