import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtiapp_team10/src/pages/connect_lights/connect_page.dart';
import 'package:dtiapp_team10/src/pages/events/event_page.dart';
import 'package:dtiapp_team10/src/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

import 'package:dtiapp_team10/src/pages/home_page.dart';
import 'submit_booking.dart';

class DomeBookingPage extends StatefulWidget {
  @override
  _DomeBookingPage createState() => _DomeBookingPage();
}

class _DomeBookingPage extends State<DomeBookingPage> {
  GlobalKey<FormState> _oFormKey = GlobalKey<FormState>();

  DateTime chosenStartDateTime = DateTime.now();
  DateTime chosenEndDateTime = DateTime.now();
  bool dome1Available = true;
  bool dome2Available = true;
  bool dome3Available = true;
  bool dome4Available = true;

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ClipRRect(
      child: Container(
          height: 80,
          width: width,
          decoration: BoxDecoration(
              color: Color(0xff86cae3)
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
                                "Book a Dome",
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

  Widget _chooseDateTime(BuildContext context) {
    return Form(
        key: _oFormKey,
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Stack(
                children: <Widget> [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'dd/MM/yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2024),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Start Date',
                      timeLabelText: 'Start Time',
                      style: TextStyle(fontSize: 20),
                      onChanged: (val) => setState(() => chosenStartDateTime = DateTime.parse(val)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'dd/MM/yyyy',
                      initialValue: DateTime.now().toString(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2024),
                      icon: Icon(Icons.event),
                      dateLabelText: 'End Date',
                      timeLabelText: 'End Time',
                      style: TextStyle(fontSize: 20),
                      onChanged: (val) => setState(() => chosenEndDateTime = DateTime.parse(val)),
                    ),
                  )
                ]
            )
        )
    );
  }

  Widget _displayDomeAvailability(BuildContext context) {
    return Container(
        child: Stack(
            children: <Widget> [
              Positioned(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: _getDomeInformation(context, 1, dome1Available)
                  )
              ),
              Positioned(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                      child: _getDomeInformation(context, 2, dome2Available)
                  )
              ),
              Positioned(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 180, 0, 0),
                      child: _getDomeInformation(context, 3, dome3Available)
                  )
              ),
              Positioned(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(0, 270, 0, 0),
                      child: _getDomeInformation(context, 4, dome4Available)
                  )
              ),

            ]
        )
    );
  }

  Widget _getDomeInformation(BuildContext context, int domeNum, bool domeAvailability) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>> (
        stream: FirebaseFirestore.instance.collection('domeAvailability').where("domeID", isEqualTo: domeNum).orderBy("bookingStart", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print(snapshot);
          if (snapshot.hasData) {
            var docs = snapshot.data!.docs;
            int numOfBookings = docs.length;
            for (int i=0; i < numOfBookings-1; i++) {
              var booking = docs[i].data()! as Map;
              var nextBooking = docs[i+1].data()! as Map;
              DateTime bookingStart = (booking['bookingStart'] as Timestamp).toDate();
              DateTime bookingEnd = (booking['bookingEnd'] as Timestamp).toDate();
              DateTime nextBookingStart = (nextBooking['bookingStart'] as Timestamp).toDate();
              if (chosenStartDateTime.isAfter(bookingStart)) {
                if (chosenEndDateTime.isBefore(bookingEnd)) {
                  int domeID = booking['domeID'];
                  return _checkDomeAvailability(context, domeID, domeAvailability, chosenStartDateTime, chosenEndDateTime, bookingStart, bookingEnd, nextBookingStart);
                }
              }
            }
            if (numOfBookings > 0) {
              var final_booking = docs[numOfBookings-1].data()! as Map;
              int domeID = final_booking['domeID'];
              DateTime bookingStart = (final_booking['bookingStart'] as Timestamp).toDate();
              DateTime bookingEnd = (final_booking['bookingEnd'] as Timestamp).toDate();
              return _checkLastDomeAvailability(context, domeID, domeAvailability, chosenStartDateTime, chosenEndDateTime, bookingStart, bookingEnd);
            }
          } print("NO DATA");
          return _showDomeAvailability(context, domeNum, domeAvailability, chosenStartDateTime, chosenEndDateTime);
        }
    );
  }

  Widget _checkDomeAvailability(BuildContext context, int domeNum, bool domeAvailability, DateTime chosenStartDateTime, DateTime chosenEndDateTime, DateTime bookingStart, DateTime bookingEnd, DateTime nextBookingStart) {
    print(domeNum);
    if ((chosenStartDateTime.isAfter(bookingStart)) && (chosenStartDateTime.isBefore(bookingEnd))) {
      print("Not available 1");
      domeAvailability = false;
    }
    else if ((chosenEndDateTime.isAfter(bookingStart)) && (chosenEndDateTime.isBefore(bookingEnd))) {
      print("Not available 2");
      domeAvailability = false;
    }
    else if ((bookingStart.isAfter(chosenStartDateTime)) && (bookingStart.isBefore(chosenEndDateTime))) {
      print("Not available 3");
      domeAvailability = false;
    }
    else if ((bookingEnd.isAfter(chosenStartDateTime)) && (bookingEnd.isBefore(chosenEndDateTime))) {
      print("Not available 4");
      domeAvailability = false;
    }
    else if ((chosenStartDateTime.isAfter(bookingEnd)) && (chosenEndDateTime.isAfter(bookingEnd)) && (chosenEndDateTime.isBefore(nextBookingStart))) {
      print("Available");
      domeAvailability = true;
    }
    else if ((chosenStartDateTime.isBefore(bookingStart)) && (chosenEndDateTime.isBefore(bookingStart))) {
      print("Available");
      domeAvailability = true;
    }

    return _showDomeAvailability(context, domeNum, domeAvailability, chosenStartDateTime, chosenEndDateTime);
  }

  Widget _checkLastDomeAvailability(BuildContext context, int domeNum, bool domeAvailability, DateTime chosenStartDateTime, DateTime chosenEndDateTime, DateTime bookingStart, DateTime bookingEnd) {
    print(domeNum);
    if ((chosenStartDateTime.isAfter(bookingStart)) && (chosenStartDateTime.isBefore(bookingEnd))) {
      print("Not available 1");
      domeAvailability = false;
    }
    else if ((chosenEndDateTime.isAfter(bookingStart)) && (chosenEndDateTime.isBefore(bookingEnd))) {
      print("Not available 2");
      domeAvailability = false;
    }
    else if ((bookingStart.isAfter(chosenStartDateTime)) && (bookingStart.isBefore(chosenEndDateTime))) {
      print("Not available 3");
      domeAvailability = false;
    }
    else if ((bookingEnd.isAfter(chosenStartDateTime)) && (bookingEnd.isBefore(chosenEndDateTime))) {
      print("Not available 4");
      domeAvailability = false;
    }
    else if ((chosenStartDateTime.isAfter(bookingEnd)) && (chosenEndDateTime.isAfter(bookingEnd))) {
      print("Available");
      domeAvailability = true;
    }
    else if ((chosenStartDateTime.isBefore(bookingStart)) && (chosenEndDateTime.isBefore(bookingStart))) {
      print("Available");
      domeAvailability = true;
    }

    return _showDomeAvailability(context, domeNum, domeAvailability, chosenStartDateTime, chosenEndDateTime);
  }

  Widget _showDomeAvailability(BuildContext context, int domeNum, bool domeAvailability, DateTime chosenStartDateTime, DateTime chosenEndDateTime) {
    return Container(
        child: domeAvailability ? _availableDome(context, chosenStartDateTime, chosenEndDateTime, domeID: domeNum) : _unavailableDome(context, domeID: domeNum)
    );
  }

  Widget _availableDome(BuildContext context, DateTime chosenStartDateTime, DateTime chosenEndDateTime, {int domeID = 0}) {
    var startDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(chosenStartDateTime);
    var endDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(chosenEndDateTime);
    return Container(
        padding: EdgeInsets.only(left: 20),
        child: Stack(
          children: <Widget> [
            Positioned(
                child: Container(
                    child: Text(
                        "Dome ${domeID}",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                    )
                )
            ),
            Row(
                children: <Widget> [
                  Positioned(
                      child: Container(
                          padding: EdgeInsets.only(top: 30, right: 15, bottom: 20),
                          child: Container(
                              alignment: Alignment.center,
                              width: 130,
                              height: 37,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Color(0xff8fbd35), width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                              ),
                              child: Text(
                                  "Available",
                                  style: TextStyle(fontSize: 20, color: Color(0xff8fbd35))
                              )
                          )
                      )
                  ),
                  Positioned(
                      child: Container(
                          padding: EdgeInsets.only(top: 30, bottom: 20),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff86cae3),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                              ),
                              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder:(context) => submitBookingPage(startDateTime: startDateTime, endDateTime: endDateTime, domeID: domeID)));},
                              child: Text(
                                  "Book Now",
                                  style: TextStyle(fontSize: 20))
                          )
                      )
                  )
                ]
            )
          ],
        )
    );
  }

  Widget _unavailableDome(BuildContext context, {int domeID = 0}) {
    return Container(
      alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 20),
        child: Stack(
          children: <Widget> [
            Positioned(
                child: Text(
                    "Dome ${domeID}",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
                )
            ),
            Positioned(
                child: Container(
                    padding: EdgeInsets.only(top: 35),
                    child: Container(
                        alignment: Alignment.center,
                        width: 130,
                        height: 37,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        child: Text(
                            "Unavailable",
                            style: TextStyle(fontSize: 20, color: Colors.red)
                        )
                    )
                )
            ),
          ],
        )
    );
  }

  @override
  void initState() {
    super.initState();
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
          currentIndex: 1,
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
                  children: <Widget> [
                    _header(context),
                    _chooseDateTime(context),
                    Divider(height: 50, thickness: 0),
                    _displayDomeAvailability(context)
                  ]
              )
          )
      ),
    );
  }
}