import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:safe_mate/utils/constants.dart';
class Patent_Review_Page extends StatefulWidget {
  const Patent_Review_Page({super.key});

  @override
  State<Patent_Review_Page> createState() => _Patent_Review_PageState();
}

class _Patent_Review_PageState extends State<Patent_Review_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Reviews',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('reviews')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final data = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  "Location : ${data['location']}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                ),
                                Text(
                                  "Comments : ${data['views']}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                                RatingBar.builder(
                                  initialRating: data['ratings'],
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  unratedColor: Colors.grey.shade300,
                                  itemPadding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: kColorDarkRed),
                                  onRatingUpdate: (rating) {

                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
