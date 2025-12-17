import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_mate/chat_module/chat_screen.dart';
import 'package:safe_mate/utils/constants.dart';
class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink,
            // backgroundColor: Color.fromARGB(255, 250, 163, 192),
            title: Text("Chat With Others"),
            bottom: TabBar(
                onTap: (index) {
                  print(index);
                },
                indicatorColor: Colors.white,
                labelColor: primaryColor,
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold
                ),
                tabs: [
                  Tab(
                    child: Text("Child",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                  Tab(
                      child: Text("Parent",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  )]),
          ),

          body: TabBarView(children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('type', isEqualTo: 'child')
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
                          onTap: () async{
                            /*await FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .collection('trustedUser')
                                .add({
                              'userId': FirebaseAuth.instance.currentUser,
                              });*/
                            // Navigator.push(context, MaterialPa)
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(d['name']),
                          ),
                          trailing: GestureDetector(
                              onTap: () async{
                                goTo(
                                    context,
                                    ChatScreen(
                                        currentUserId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                        friendId: d.id,
                                        friendName: d['name']));
                              },
                              child:
                              Icon(Icons.chat_outlined, color: Colors.white,)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('type', isEqualTo: 'parent')
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

                            // Navigator.push(context, MaterialPa)
                          },
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(d['name']),
                          ),
                          trailing: GestureDetector(
                              onTap: () async{
                                goTo(
                                    context,
                                    ChatScreen(
                                        currentUserId:
                                        FirebaseAuth.instance.currentUser!.uid,
                                        friendId: d.id,
                                        friendName: d['name']));
                              },
                              child:
                              Icon(Icons.chat_outlined, color: Colors.white,)),
                        ),
                      ),
                    );

                  },
                );
              },
            ),]),
        ),
      ),
    );
  }
}
