import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'post.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Stream postStream = FirebaseFirestore.instance
      .collection('posts')
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
              child: StreamBuilder<QuerySnapshot>(
            stream: postStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  // ignore: unnecessary_cast
                  Map data = document.data();
                  return Post(data: data);
                }).toList(),
              );
            },
          )),
        ),
      ),
    );
  }
}
