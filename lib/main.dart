import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_mate/child/bottom_page.dart';
import 'package:safe_mate/child/child_login_screen.dart';
import 'package:safe_mate/child/register_child.dart';
import 'package:safe_mate/db/share_pref.dart';
import 'package:safe_mate/firebase_options.dart';
import 'package:safe_mate/child/bottom_screens/home_screen.dart';
import 'package:safe_mate/parent/parent_home_screen.dart';
import 'package:safe_mate/parent/parent_register_screen.dart';
import 'package:safe_mate/utils/constants.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MySharedPrefference.init();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder(future: MySharedPrefference.getUserType(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.data == "") {
              return LoginScreen();
            }
            if(snapshot.data == "child") {
              return BottomPage();
            }
            if(snapshot.data == "parent") {
              return ParentHomeScreen();
            }

            return progressIndicator(context);
          }
      ),
    );
  }
}
