import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'profile_page.dart';

class UserQRPage extends StatefulWidget {
  @override
  _UserQRPage createState() => _UserQRPage();
}

class _UserQRPage extends State<UserQRPage> {

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
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage())),
                              )
                          ),
                          Positioned(
                              top: 43,
                              left: 70,
                              child: Text(
                                "Your Profile",
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

  Widget _qrContent() {
    return Container(
        child: Column(
            children: <Widget> [
              Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: Text(
                      "Share your personal QR Code with others",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                      "Allow others to view your profile and connect with them",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.grey)
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: QrImage(
                      size: 300,
                      data: "Jackson Thomas",
                      gapless: false,
                      version: QrVersions.auto
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
                      _qrContent()
                    ]
                )
            )
        )
    );
  }
}