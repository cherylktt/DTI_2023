import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'booking_page.dart';

class submitBookingPage extends StatefulWidget {
  const submitBookingPage({Key? key, required this.startDateTime, required this.endDateTime, required this.domeID}) : super(key: key);
  final String startDateTime;
  final String endDateTime;
  final int domeID;

  @override
  _submitBookingPage createState() => _submitBookingPage();
}

class _submitBookingPage extends State<submitBookingPage> {

  final eventNameController = TextEditingController();

  var db = FirebaseFirestore.instance;

  void _pushBookingToFirestore(int domeNum, String eventName, String date, String startTime, String endTime) {
    String _startDateTime = "${date} ${startTime}";
    String _endDateTime = "${date} ${endTime}";
    DateTime startDateTime = new DateFormat('dd/MM/yyyy HH:mm').parse(_startDateTime);
    DateTime endDateTime = new DateFormat('dd/MM/yyyy HH:mm').parse(_endDateTime);
    Timestamp startBooking = Timestamp.fromDate(startDateTime);
    Timestamp endBooking = Timestamp.fromDate(endDateTime);
    final bookingInformation = <String, dynamic> {
      "domeID": domeNum,
      "eventName": eventName,
      "bookingStart": startBooking,
      "bookingEnd": endBooking,
    };
    db.collection("domeAvailability").add(bookingInformation);
  }

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
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DomeBookingPage())),
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

  Widget _bookingBody(BuildContext context) {
    DateTime chosenStartDateTime = DateTime.parse(widget.startDateTime);
    DateTime chosenEndDateTime = DateTime.parse(widget.endDateTime);
    var chosenDate = DateFormat("dd/MM/yyyy").format(chosenStartDateTime);
    var startTime  = DateFormat("HH:mm").format(chosenStartDateTime);
    var endTime = DateFormat("HH:mm").format(chosenEndDateTime);

    return Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text(
                  "Create booking for Dome ${widget.domeID}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                      "Date: ${chosenDate}",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20)
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                      "Start Time: ${startTime}",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20)
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                    "End Time: ${endTime}",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20)
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                    "Event Name:",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20)
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 18),
                    controller: eventNameController,
                  )
              ),
              Container(
                  width: 380,
                  height: 70,
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: Colors.white
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              fixedSize: Size(380, 50)
                          ),
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text("Confirm Booking?"),
                                content: Text("Booking of Dome ${widget.domeID} for ${eventNameController.text}\nDate: ${chosenDate}\nTime: ${startTime} - ${endTime}"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.pop(context, "No");
                                        });
                                      },
                                      child: Text("No")
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _pushBookingToFirestore(widget.domeID, eventNameController.text, chosenDate, startTime, endTime);
                                          Navigator.of(context).push(MaterialPageRoute(builder:(context) => DomeBookingPage()));
                                        });
                                      },
                                      child: Text("Yes")
                                  )
                                ]
                            ),
                          ),
                          child: Text("Book", style: TextStyle(color: Colors.lightBlue, fontSize: 20))
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
      body: SingleChildScrollView(
          child: Container(
              child: Column(
                  children: <Widget> [
                    _header(context),
                    _bookingBody(context),
                  ]
              )
          )
      ),
    );
  }
}