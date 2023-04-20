import 'package:dtiapp_team10/src/pages/booking/booking_page.dart';
import 'package:dtiapp_team10/src/pages/events/event_page.dart';
import 'package:dtiapp_team10/src/pages/home_page.dart';
import 'package:dtiapp_team10/src/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'connect_lights_page.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({Key? key}): super(key: key);

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
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
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

  Widget _domeCard(BuildContext context, int domeNumber, lightPage) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 100,
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
        child: Stack(
            children: <Widget>[
              Positioned(
                  top: 30,
                  left: 30,
                  child: Text(
                      'Dome ${domeNumber}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                      )
                  )
              ),
              Positioned(
                top: 23,
                left: 250,
                child: IconButton(
                    icon: Icon(Icons.lightbulb, size: 30),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => lightPage))
                ),
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
            currentIndex: 2,
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
                      _domeCard(context, 1, ConnectLightsPage(domeNum: 1)),
                      _domeCard(context, 2, ConnectLightsPage(domeNum: 2)),
                      _domeCard(context, 3, ConnectLightsPage(domeNum: 3)),
                      _domeCard(context, 4, ConnectLightsPage(domeNum: 4))
                    ]
                )
            )
        )
    );
  }
}