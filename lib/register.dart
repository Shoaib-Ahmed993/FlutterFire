import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void registerUser() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final String username = usernameController.text;
      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final UserCredential user = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await firestore.collection('users').doc(user.user.uid).set({
          'username': username,
          'email': email,
          'password': password
        });

        print("User is registered successfully");
        // print("username: $username");
        // print("email: $email");
        // print("password: $password");
      } catch (e) {
        print('error: $e');
      }
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
            child: Column(
          children: [
            TextFormField(
              controller: usernameController,
              decoration:
                  const InputDecoration(labelText: 'Enter your username'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Enter your email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration:
                  const InputDecoration(labelText: 'Enter your passowrd'),
            ),
            SizedBox(
              height: 20,
            ),

            // Text Button
            // TextButton(
            //   onPressed: (){},
            //   child: Text("Register")
            // ),

            // Outlined Button
            OutlinedButton(onPressed: registerUser, child: Text("Register"))
          ],
        )),
      ),
    );
  }
}
