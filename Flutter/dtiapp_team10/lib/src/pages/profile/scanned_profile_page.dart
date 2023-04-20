import 'package:dtiapp_team10/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'profile_qrcode.dart';

class ScannedProfilePage extends StatefulWidget {
  const ScannedProfilePage({Key? key, required this.profileName}) : super(key: key);
  final String profileName;

  @override
  _ScannedProfilePage createState() => _ScannedProfilePage();
}

class _ScannedProfilePage extends State<ScannedProfilePage> {

  final db = FirebaseFirestore.instance;

  void updateFollowingStatus(String followProfileName) {
    final followRef = db.collection("userProfile").doc(followProfileName);
    followRef.update({"followed": true});
  }

  void showColor() async {
    final updated = {"color": "Fission"};
    final Map<String, Map> updates = {};
    updates ['/DOME1/LED_COLOR_PRESET'] = updated;
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
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
                              )
                          ),
                          Positioned(
                              top: 43,
                              left: 70,
                              child: Text(
                                "${widget.profileName.split(' ')[0]}'s Profile",
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

  Widget _userInformation(BuildContext context, String documentName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('userProfile').doc(documentName).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data!.data() as Map;
            String userName = userData['name'];
            String userCompany = userData['company'];
            String userJob = userData['job'];
            String userJobScope = userData['jobScope'];
            String userLinkedinProfile = userData['linkedinProfile'];
            String userInterests = userData['interests'];
            bool followed = userData['followed'];
            return _userInfo(
                context,
                name: userName,
                company: userCompany,
                job: userJob,
                jobScope: userJobScope,
                linkedinProfile: userLinkedinProfile,
                interests: userInterests,
                followed: followed
            );
          }
          return Container();
        }
    );
  }

  Widget _userInfo(BuildContext context, {String imgPath = "", String name = "", String company = "", String job = "", String jobScope = "", String linkedinProfile = "", String interests = "", bool followed = false}) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage("https://as2.ftcdn.net/jpg/01/07/43/45/220_F_107434511_iarF2z88c6Ds6AlgtwotHSAktWCdYOn7.jpg"),
                      minRadius: 20,
                      maxRadius: 50
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  alignment: Alignment.center,
                  child: Text(
                      "${name}",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      )
                  )
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(8, 5, 8, 0),
                  alignment: Alignment.center,
                  child: Text(
                      "${job} at ${company}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18
                      )
                  )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Column(
                    children: <Widget> [
                      ListTile(
                        title: Text("Job Scope", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                        subtitle: Text("${jobScope}", style: TextStyle(fontSize: 16)),
                        visualDensity: VisualDensity(vertical: -3),
                        minVerticalPadding: 2,
                      ),
                      Divider(thickness: 2),
                      ListTile(
                        title: Text("LinkedIn Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                        subtitle: Text("${linkedinProfile}", style: TextStyle(fontSize: 16)),
                        visualDensity: VisualDensity(vertical: -3),
                        minVerticalPadding: 2,
                      ),
                      Divider(thickness: 2),
                      ListTile(
                        title: Text("Interests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                        subtitle: Text("${interests}", style: TextStyle(fontSize: 16)),
                        visualDensity: VisualDensity(vertical: -3),
                        minVerticalPadding: 2,
                      ),
                      Divider(thickness: 2)
                    ]
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(8, 10, 8, 0),
                  child: Container(
                      width: 380,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: followed ? Border.all(color: Colors.white) : Border.all(color: Color(0xff78b5cc)),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          color: followed ? Color(0xff78b5cc) : Colors.white
                      ),
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.all(10)
                          ),
                          onPressed: followed ? null : () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text("Follow ${name}?"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            followed = false;
                                            Navigator.pop(context, "No");
                                          });
                                        },
                                        child: Text("No")
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            followed = true;
                                            updateFollowingStatus(name);
                                            showColor();
                                            Navigator.pop(context, "Yes");
                                          });
                                        },
                                        child: Text("Yes")
                                    )
                                  ]
                              )
                          ),
                          child: followed ? Text("Following", style: TextStyle(color: Colors.white, fontSize: 20)) : Text("Follow", style: TextStyle(color: Color(0xff78b5cc), fontSize: 20))
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
                    children: <Widget>[
                      _header(context),
                      _userInformation(context, widget.profileName)
                    ]
                )
            )
        )
    );
  }
}