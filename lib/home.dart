import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void backToLogin() {
      Navigator.of(context).pushNamed('/login');
    }

    return Center(
      child: Container(
          child: Column(
        children: [
          Text("Home Page"),
          SizedBox(height: 15,),
          ElevatedButton(onPressed: backToLogin, child: Text("Back to Login"))
        ],
      )),
    );
  }
}
