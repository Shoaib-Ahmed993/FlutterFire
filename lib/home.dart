import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'post.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

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
  // var pickedImage;
  String imagePath;

  @override
  Widget build(BuildContext context) {

    
    // void pickImage() async {
    // Image fromPicker =
    //     await ImagePickerWeb.getImage(outputType: ImageType.widget);

    // if (fromPicker != null) {
    //   setState(() {
    //     pickedImage = fromPicker;
    //   });
    // }

    // print(fromPicker);
    // }

    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);

      setState(() {
        imagePath = image.path;
      });
    }

    // void submitPost() async {
    //   try {
    //     String title = titleController.text;
    //     String description = descriptionController.text;
    //     firebase_storage.FirebaseStorage storage =
    //         firebase_storage.FirebaseStorage.instance;
    //     firebase_storage.Reference ref =
    //         firebase_storage.FirebaseStorage.instance.ref('/notes.txt');
    //     // File file = File(pickedImage);
    //     // await ref.putFile(file);
    //     String downloadedUrl = await ref.getDownloadURL();
    //     print('File uploaded successfully');
    //     print(downloadedUrl);
    //   } catch (e) {
    //     print(e.message);
    //   }
    // }

    void submitPost() async {
      try {
        String title = titleController.text;
        String description = descriptionController.text;
        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String downloadedUrl = await ref.getDownloadURL();
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('posts').add(
            {'title': title, 'description': description, 'url': downloadedUrl});

        titleController.clear();
        descriptionController.clear();
      } catch (e) {
        print(e.message);
      }
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
                        String id = document.id;
                        data['id'] = id;
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
