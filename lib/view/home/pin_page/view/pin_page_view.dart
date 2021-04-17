import 'package:engelsiz_yollar/view/home/anasayfa/view/ana_sayfa_view.dart';
import 'package:engelsiz_yollar/view/home/pin_page/viewmodel/pin_page_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz_yollar/core/models/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class PinPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  File image;
  PinPage({this.latitude, this.longitude, this.image});

  @override
  _PinPageState createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  //final PinPageViewModel _pinPageViewModel = PinPageViewModel();

  final Reference storageRef = FirebaseStorage.instance.ref();
  final usersRef = FirebaseFirestore.instance.collection('users');
  final pinsRef = FirebaseFirestore.instance.collection('pins');
  TextEditingController captionController = TextEditingController();
  String pinId = Uuid().v4();

  createPinInFirestore(
      {String mediaUrl,
      String description,
      UserFromFirebase user,
      double latitude,
      double longitude,
      //DocumentSnapshot doc
      }) {
    pinsRef.doc(pinId).set({
      "pinId": pinId,
      //"ownerId": doc['uid'],
      "mediaUrl": mediaUrl,
      "description": description,
      "latitude": latitude,
      "longitude": longitude,
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(widget.image.readAsBytesSync());
    final compressedImageFile = File('$path/img_$pinId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      widget.image = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask =
        storageRef.child("pin_$pinId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  handleSubmit(parentContext) async {
    //DocumentSnapshot doc = await usersRef.doc(user.uid).get();

    String filePath = widget.image.path;
    print(filePath);
    if (filePath.contains("jpg")) {
      await compressImage();
    }
    String mediaUrl = await uploadImage(widget.image);
    createPinInFirestore(
      mediaUrl: mediaUrl,
      description: captionController.text,
      //user: user,
      latitude: widget.latitude,
      longitude: widget.longitude,
      //doc: doc,
    );
    captionController.clear();
    setState(() {
      //isUploading = false;
      pinId = Uuid().v4();
    });

            Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AnasayfaView()));

    //_showToast();

    /* Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => afterSign(
            user: user,
            whyHere: 'profile',
          ),
        ),
      ); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(widget.image),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(24.0)),
              child: Column(
                children: [],
              )),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(24.0)),
            child: ListTile(
              title: Container(
                width: 250.0,
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: "Bir açıklama yaz ... ",
                    hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height / 50,
                        color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              label: Text(
                "Paylaş",
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                handleSubmit(context);
              },
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
