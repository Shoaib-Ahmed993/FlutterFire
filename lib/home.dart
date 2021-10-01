import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'post.dart';
import 'package:image_picker_web/image_picker_web.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream postStream =
      FirebaseFirestore.instance.collection('posts').snapshots();

  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  var pickedImage;

  @override
  Widget build(BuildContext context) {
    void pickImage() async {
      Image fromPicker =
          await ImagePickerWeb.getImage(outputType: ImageType.widget);

      if (fromPicker != null) {
        setState(() {
          pickedImage = fromPicker;
        });
      }

      print(pickedImage);
    }

    void submitPost() {
      String title = titleController.text;
      String description = descriptionController.text;

      print(title);
      print(description);
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SafeArea(
            child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Enter title'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Enter description'),
            ),
            OutlinedButton(onPressed: pickImage, child: Text("Pick an image")),
            SizedBox(
              height: 10,
            ),
            TextButton(onPressed: submitPost, child: Text("Submit post")),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: postStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return AlertDialog(
                        title: Text("Something went wrong"),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        // ignore: unnecessary_cast
                        Map data = document.data();
                        return Post(data: data);
                      }).toList(),
                    );
                  },
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
