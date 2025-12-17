import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_mate/chat_module/chat_screen.dart';
import 'package:safe_mate/parent/parent_review_watching.dart';
import 'package:safe_mate/utils/constants.dart';
import '../child/child_login_screen.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.white38,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                //accountName: Text(FirebaseAuth.instance.currentUser!.phoneNumber.toString()),
                accountEmail: Text(FirebaseAuth.instance.currentUser!.email.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/OIP.jpeg'),
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/contact_profile.jpg'),
                  // backgroundImage: AssetImage('images/widgets/materialWidgets/mwLayoutWidgtes/MWUserAccountDrawerHeaderWidget/ic_user2.png'),
                ), accountName: null,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Card(
                      color: Colors.pinkAccent,
                      child: ListTile(
                          title: TextButton(
                              onPressed: () async {
                                goTo(context, Patent_Review_Page());
                              },
                              child: Text(
                                "VIEW REVIEWS",
                                style: TextStyle(
                                    color: Colors.white,
                                  fontSize: 15.0
                                ),
                              ))),
                    ),
                    SizedBox(height: 10.0,),
                    Card(
                      color: Colors.pinkAccent,
                      child: ListTile(
                          title: TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance.signOut();
                                  goTo(context, LoginScreen());
                                } on FirebaseAuthException catch (e) {
                                  dialogueBox(context, e.toString());
                                }
                              },
                              child: Text(
                                "SING OUT",
                                style: TextStyle(
                                    color: Colors.white,
                                  fontSize: 15.0
                                ),
                              ))),
                    ),
                  ],
                ),
              ),
              /*ListTile(
            title: Text('My Account', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              scaffoldKey.currentState!.openEndDrawer();
            },
          ),*/
              /*ListTile(
            title: Text('Setting', style: primaryTextStyle()),
            onTap: () {
              scaffoldKey.currentState!.openEndDrawer();
              toasty(context, "Setting");
            },
          ),
          ListTile(
            title: Text('Logout', style: primaryTextStyle()),
            onTap: () {
              scaffoldKey.currentState!.openEndDrawer();
              toasty(context, "Logout");
            },
          )*/
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        // backgroundColor: Color.fromARGB(255, 250, 163, 192),
        title: Text("SELECT CHILD"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('type', isEqualTo: 'child')
            .where('guardiantEmail',
            isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: progressIndicator(context));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final d = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color.fromARGB(255, 250, 163, 192),
                  child: ListTile(
                    onTap: () {
                      goTo(
                          context,
                          ChatScreen(
                              currentUserId:
                              FirebaseAuth.instance.currentUser!.uid,
                              friendId: d.id,
                              friendName: d['name']));
                      // Navigator.push(context, MaterialPa)
                    },
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(d['name']),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
