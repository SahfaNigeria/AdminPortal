import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadScreen extends StatefulWidget {
  static const String routeName = '\UploadScreen';

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _images;
  String? fileName;

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      setState(() {
        _images = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  upLoadBannerToFirebaseStorage(dynamic image) async {
    Reference ref = _storage.ref().child('Banner').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapShot = await uploadTask;

    String downloadUrl = await snapShot.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFireStore() async {
    EasyLoading.show();
    if (_images != null) {
      String imageUrl = await upLoadBannerToFirebaseStorage(_images);
      await _firestore.collection('New Banners').doc(fileName).set(
        {
          'image': imageUrl,
        },
      ).whenComplete(() => EasyLoading.dismiss());

      setState(() {
        _images = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Upload',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: 120,
                        height: 130,
                        child: _images != null
                            ? Image.memory(_images)
                            : Center(
                                child: Text(
                                'Upload Banner',
                              )),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade700),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Center(child: Text('Save')),
                      onPressed: () {
                        uploadToFireStore();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    pickImage();
                  },
                  child: Center(
                    child: Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
