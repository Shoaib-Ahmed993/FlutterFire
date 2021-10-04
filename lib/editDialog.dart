import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;

class EditDialog extends StatefulWidget {
  final Map data;
  EditDialog({this.data});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  String imagePath;

  TextEditingController titleController =
      TextEditingController();
  TextEditingController descriptionController =
      TextEditingController();

      @override
        void initState() {
          super.initState();
          titleController.text = widget.data['title'];
          descriptionController.text = widget.data['description'];
        }
  @override
  Widget build(BuildContext context) {

    void pickImage() async {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.getImage(source: ImageSource.gallery);

      setState(() {
        imagePath = image.path;
      });
    }

    void donePost() async {
      try {
        String imageName = path.basename(imagePath);
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/$imageName');

        File file = File(imagePath);
        await ref.putFile(file);
        String downloadedUrl = await ref.getDownloadURL();
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        Map<String, dynamic> newPost = {
          "title": titleController.text,
          "description": descriptionController.text,
          "url": downloadedUrl
        };

        firestore.collection('posts').doc(widget.data['id']).set(newPost);
        Navigator.of(context).pop();
      } catch (e) {
        print(e.message);
      }
    }

    return AlertDialog(
      content: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
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
          TextButton(onPressed: donePost, child: Text("Done post"))
        ],
      )),
    );
  }
}
