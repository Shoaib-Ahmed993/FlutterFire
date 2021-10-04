import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/editDialog.dart';
import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final Map data;
  Post({this.data});
  @override
  Widget build(BuildContext context) {
    // print(data['id']);
    void deletePost() async {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('posts').doc(data['id']).delete();
      } catch (e) {
        print(e.message);
      }
    }

    void editPost(){
      showDialog(context: context, builder: (BuildContext context){
        return EditDialog(data: data);
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.black,
        width: 2,
      )),
      child: Column(
        children: [
          Image(
            image: NetworkImage(
              data['url'],
            ),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(data['title']),
          Text(data['description']),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: editPost),
              FloatingActionButton(
                onPressed: deletePost,
                child: Text("Delete"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
