import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:safe_mate/components/PrimaryButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(FlutterContactsExample());

class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Scaffold(

          body: _body()));

  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Color.fromARGB(255, 250, 163, 192),
            child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/contact_profile.jpg'),
                ),
                title: Text(_contacts![i].displayName, style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w400
                ),),
                onTap: () async {
                  //launchUrlString('tel/:+${_contacts![i].phones.first.number}');
                  //launchUrlString('mailto : ${_contacts![i].emails}');
                 // FlutterPhoneDirectCaller.callNumber(_contacts![i].phones.first.number);
                  final fullContact =
                  await FlutterContacts.getContact(_contacts![i].id);
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
                }),
          ),
        ));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 5.0,
              color: Color.fromARGB(255, 250, 163, 192),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      contact.displayName,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/contact_profile.jpg'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                          title: TextButton(
                              onPressed: () async {
                                
                              },
                              child: Text(
                                'Contact: ${contact.phones.first.number}',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20
                                ),
                              ))),
                    ),
                    SizedBox(height: 10.0,),
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                          title: TextButton(
                              onPressed: () async {
            
                              },
                              child: Text(
                                  'First name: ${contact.name.first}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20
                                ),
                              ))),
                    ),
                    SizedBox(height: 10),
                    Card(
                      color: Colors.white70,
                      child: ListTile(
                          title: TextButton(
                              onPressed: () async {
            
                              },
                              child: Text(
                                'Last name: ${contact.name.last}',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20
                                ),
                              ))),
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () {
                        launchUrlString("tel://${ contact.phones.first.number}");
                      }, child: Text("CALL",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                    /*PrimaryButton(
                        title: "CALL",
                        onPressed: () {
                          launchUrlString("tel://${ contact.phones.first.number}");
                        })*/
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
      // appBar: AppBar(title: Text(contact.displayName)),
      // body: Column(children: [
      //   Text('First name: ${contact.name.first}'),
      //   Text('Last name: ${contact.name.last}'),
      //   GestureDetector(
      //     onTap: () {
      //       launchUrlString("tel://${ contact.phones.first.number}");
      //     },
      //     child: Text(
      //         'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
      //   ),
      //   Text(
      //       'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      // ])
  );
}