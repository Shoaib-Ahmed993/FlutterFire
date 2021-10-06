import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void loginUser() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final String email = emailController.text;
      final String password = passwordController.text;

      try {
        final UserCredential user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        final DocumentSnapshot snapshot =
            await firestore.collection('users').doc(user.user.uid).get();
        final data = snapshot.data();
        print("User is logged in successfully");
        print(data);

        // print(data['username']);
        // print(data['email']);
        // print(data['password']);
      } catch (e) {
        print('error: $e');
      }
    }

    void goToRegister() {
      Navigator.of(context).pushNamed('/register');
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
            child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Enter email'),
            ),
            TextFormField(
              controller: passwordController,
              decoration:
                  const InputDecoration(labelText: 'Enter passowrd'),
            ),
            SizedBox(
              height: 20,
            ),

            // Text Button
            TextButton(onPressed: loginUser, child: Text("Login")),

            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: goToRegister, child: Text("Go to Register"))

            // Outlined Button
            // OutlinedButton(onPressed: registerUser, child: Text("Register"))
          ],
        )),
      ),
    );
  }
}
