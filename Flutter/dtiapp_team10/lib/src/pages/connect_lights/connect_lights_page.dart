import 'package:dtiapp_team10/src/pages/booking/booking_page.dart';
import 'package:dtiapp_team10/src/pages/events/event_page.dart';
import 'package:dtiapp_team10/src/pages/home_page.dart';
import 'package:dtiapp_team10/src/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'connect_page.dart';

class ConnectLightsPage extends StatefulWidget {
  const ConnectLightsPage({Key ? key, required this.domeNum}): super(key: key);
  final int domeNum;

  @override
  _ConnectLightsPage createState() => _ConnectLightsPage();
}

class _ConnectLightsPage extends State<ConnectLightsPage> {
  bool isSwitched = false;

  double currentSliderValue = 20;
  HSVColor color = HSVColor.fromColor(Colors.blue);

  void onColorChanged(HSVColor value) => this.color = value;

  void changeLEDStatus(bool isSwitched, int domeNum) async {
    final updated = {"value" : isSwitched ? 1 : 0};
    final Map<String, Map> updates = {};
    updates['/DOME1/LED_STATUS'] = updated;
    return FirebaseDatabase.instance.ref().update(updates);
  }

  void changeColorPreset(String colorName) async {
    final updated = {"color": colorName};
    final Map<String, Map> updates = {};
    updates['/DOME1/LED_COLOR_PRESET'] = updated;
    return FirebaseDatabase.instance.ref().update(updates);
  }

  void changePatternPreset(String patternName) async {
    final updated = {"pattern": patternName};
    final Map<String, Map> updates = {};
    updates['/DOME1/LED_PATTERN_PRESET'] = updated;
    return FirebaseDatabase.instance.ref().update(updates);
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
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ConnectPage())),
                              )
                          ),
                          Positioned(
                              top: 43,
                              left: 70,
                              child: Text(
                                "Connect",
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

  Widget _titleRow(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 95),
        height: 30,
        child: Stack(
            children: <Widget>[
              Positioned(
                  left: 20,
                  child: Text(
                      "LED controls for Dome ${widget.domeNum}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25
                      ),
                      textAlign: TextAlign.left
                  )
              )
            ]
        )
    );
  }

  Widget _lightControls(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget> [
          Container(
            padding: EdgeInsets.only(left: 20, top: 130),
            child: Row(
             children: <Widget> [
               Text(
                 "Toggle LED On/Off",
                 style: TextStyle(fontSize: 20)
               ),
               _setLEDStatus()
             ]
            )
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Stack(
              children: <Widget> [
                Text(
                  "Choose LED Color Presets",
                  style: TextStyle(fontSize: 20)
                ),
                _chooseLEDColorPreset()
              ]
            )
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Stack(
              children: <Widget> [
                Text(
                  "Choose LED Pattern Presets",
                  style: TextStyle(fontSize: 20)
                ),
                _chooseLEDPatternPreset()
              ]
            )
          )
        ]
      )
    );
  }

  Widget _setLEDStatus() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Switch(
        value: isSwitched,
        onChanged: (value) {
          setState(() {
            isSwitched = value;
            changeLEDStatus(isSwitched, widget.domeNum);
            print("LED Status: ${isSwitched}");
          });
        },
        activeTrackColor: Colors.lightGreenAccent,
        activeColor: Colors.green,
      )
    );
  }

  Widget _chooseLEDColorPreset() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Stack(
        children: <Widget> [
          Container(
            child: Row(
                children: <Widget> [
                  _colorLEDPreset("Passion", Color(0xffee4035)),
                  _colorLEDPreset("Sunrise", Color(0xfff37736)),
                  _colorLEDPreset("Sunset", Color(0xfffcd400)),
                ]
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 45),
            child: Row(
                children: <Widget> [
                  _colorLEDPreset("Nature", Color(0xff7bc043)),
                  _colorLEDPreset("Cool", Color(0xff0392cf)),
                  _colorLEDPreset("Punky", Color(0xff673888)),
                ]
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 90),
            child: Row(
                children: <Widget> [
                  _colorLEDPreset("Coral", Color(0xffff99ff)),
                  _colorLEDPreset("Fission", Color(0xffffca2a)),
                  _colorLEDPreset("Rainbow", Color(0xff000000)),
                ]
            ),
          ),
        ]
      )
    );
  }

  Widget _chooseLEDPatternPreset() {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Stack(
        children: <Widget> [
          Container(
            child: Row(
              children: <Widget> [
                _patternLEDPreset("None"),
                _patternLEDPreset("Fade"),
              ]
            ),
          ),
        ]
      )
    );
  }

  Widget _colorLEDPreset(String colorName, Color color) {
    return Container(
      padding: EdgeInsets.only(right: 15),
      child: ElevatedButton(
        child: Text(
          colorName,
          style: TextStyle(fontSize: 18, color: Colors.white)
        ),
        onPressed: () {
          setState(() {
            changeColorPreset(colorName);
          });
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(color),
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: color)
            )
          )
        )
      )
    );
  }

  Widget _patternLEDPreset(String patternName) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      child: ElevatedButton(
        child: Text(
          patternName,
          style: TextStyle(fontSize: 18, color: Colors.white)
        ),
        onPressed: () {
          setState(() {
            changePatternPreset(patternName);
          });
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(color: Colors.black)
            )
          )
        )
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
          currentIndex: 2,
          items: [
            BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.home), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()))), label: "Home", ),
            BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.calendar_month), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DomeBookingPage()))), label: "Bookings"),
            BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.connected_tv), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConnectPage()))), label: "Connect"),
            BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.event_outlined), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventsPage()))), label: "Events"),
            BottomNavigationBarItem(icon: IconButton(icon: Icon(Icons.person), onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserProfilePage()))), label: "Profile")
          ]
      ),
      body: Center(
          child: Stack(
              children: <Widget> [
                _header(context),
                _titleRow(context),
                _lightControls(context)
              ]
          )
      ),
    );
  }
}
