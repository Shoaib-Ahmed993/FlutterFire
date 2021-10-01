import 'dart:ui';

import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  final Map data;
  Post({this.data});
  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}
